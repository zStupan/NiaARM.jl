function narm(solution; problem, features, transactions, rules, kwargs...)
    if length(solution) != problem.dimension
        throw(DimensionMismatch("$(length(solution)) != $(problem.dimension)"))
    end

    fitness = -Inf
    # obtain cut point value and remove this value from a vector of solutions
    cut_value = last(solution)

    # calculate cut point
    cut = cut_point(cut_value, length(features))
    # build a rule from candidate solution
    rule = build_rule(solution[begin:end-1], features)

    # get antecedent and consequent of rule
    antecedent = rule[begin:cut]
    consequent = rule[cut+1:end]

    antecedent = collect(skipmissing(antecedent))
    consequent = collect(skipmissing(consequent))

    if length(antecedent) > 0 && length(consequent) > 0
        ct = ContingencyTable(antecedent, consequent, transactions)
        supp = support(ct)
        conf = confidence(ct)
        fitness = calculate_fitness(supp, conf)
        newrule = Rule(antecedent, consequent, fitness, ct)

        if supp > 0.0 && conf > 0.0 && newrule ∉ rules
            push!(rules, newrule)
        end
    end

    return -fitness  # Maximization
end

function cut_point(sol, num_attr)
    """Calculate cut point.
    Note: The cut point denotes which part of the vector belongs to the
    antecedent and which to the consequence of the mined association rule.
    """
    cut = trunc(Int, (sol * num_attr))
    if cut == 0
        cut = 1
    end
    if cut > num_attr - 1
        cut = num_attr - 2
    end
    return cut
end

function calculate_fitness(supp, conf)
    return (1.0 * supp + 1.0 * conf) / 2
end

function build_rule(solution, features)
    rule = Union{Missing,Attribute}[]

    # obtain permutation vector
    permutation = last(solution, length(features))
    permutation = sortperm(permutation)

    for i in permutation
        feature = features[i]

        # set current position in the vector
        vector_position = feature_position(features, i)

        threshold_position = vector_position + 1 + Int(isnumerical(feature))

        if solution[vector_position] > solution[threshold_position]
            if isnumerical(feature)
                min = solution[vector_position] * (feature.max - feature.min) + feature.min
                vector_position = vector_position + 1
                max = solution[vector_position] * (feature.max - feature.min) + feature.min
                if dtype(feature) <: Integer
                    min = round(dtype(feature), min)
                    max = round(dtype(feature), max)
                end
                min, max = minmax(min, max)
                push!(rule, NumericalAttribute{dtype(feature)}(feature.name, min, max))
            else
                categories = feature.categories
                selected = trunc(Int, solution[vector_position] * (length(categories)))
                selected = selected == 0 ? 1 : selected
                push!(rule, CategoricalAttribute(feature.name, categories[selected]))
            end
        else
            push!(rule, missing)
        end
    end
    return rule
end

function feature_position(features, index)
    position = 1
    for f in features[begin:index-1]
        position += Int(isnumerical(f)) + 2
    end
    return position
end
