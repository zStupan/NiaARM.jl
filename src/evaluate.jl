function mine(dataset)
    # LOAD DATASET
    transactions = load_dataset(dataset)
    # GET PREPROCESSED FEATURES
    features = preprocess_data(transactions)

    # PARAMETERS
    MAX_ITER = 500
    dimension = problem_dimension(features)
    rules = Rule[]
    # RUN random search for now
    rng = MersenneTwister(1234)
    iters = 0
    best_fitness = 0
    while iters < MAX_ITER
        solution = rand!(rng, zeros(dimension))
        fitness = evaluate(solution, features, transactions, rules)
        if fitness > best_fitness
            println("Best: ", fitness)
            best_fitness = fitness
        end
        iters += 1
    end

    return rules 
end

function evaluate(solution, features, transactions, rules)
    support = -1.0
    confidence = -1.0
    fitness = -1.0
    # obtain cut point value and remove this value from a vector of solutions
    cut_value = last(solution)
    pop!(solution)

    # calculate cut point
    cut = cut_point(cut_value, length(features))
    # build a rule from candidate solution
    rule = build_rule(solution, features)
    
    # get antecedent and consequent of rule
    antecedent = rule[begin:cut]
    consequent = rule[cut + 1:end]

    antecedent = collect(skipmissing(antecedent))
    consequent = collect(skipmissing(consequent))

    if length(antecedent) > 0 && length(consequent) > 0
        support, confidence = metrics(antecedent, consequent, transactions)
        fitness = calculate_fitness(support, confidence)
        newrule = Rule(antecedent, consequent, fitness, support, confidence)

        if support > 0.0 && confidence > 0.0 && newrule ∉ rules
            push!(rules, newrule)
        end
    end

    return fitness
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

function metrics(antecedent, consequent, transactions)
    num_transactions = nrow(transactions)
    contains_antecedent = trues(num_transactions)
    contains_consequent = trues(num_transactions)

    for attribute in antecedent
        contains_antecedent .&= transactions[:, attribute.name] .>= attribute.min_val
        contains_antecedent .&= transactions[:, attribute.name] .<= attribute.max_val
    end

    for attribute in consequent
        contains_consequent .&= transactions[:, attribute.name] .>= attribute.min_val
        contains_consequent .&= transactions[:, attribute.name] .<= attribute.max_val
    end

    count_full = sum(contains_antecedent .& contains_consequent)
    count_lhs = sum(contains_antecedent .& .!contains_consequent)
    # count_rhs = sum(.!contains_antecedent .& contains_consequent)
    count_x = count_full + count_lhs

    support = count_full / num_transactions
    confidence = count_full / count_x

    return support, confidence
end

# Unused for now
function feature_borders(features, name)
    index = findfirst(feature -> feature.name == name, features)
    feature = features[index]
    return feature.min_val, feature.max_val
end

function calculate_fitness(supp, conf)
    return (1.0 * supp + 1.0 * conf) / 2
end
