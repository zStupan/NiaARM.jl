function mine(path_or_df, algorithm, stoppingcriterion; kwargs...)
    transactions, features, dimension = dataset(path_or_df)
    problem = Problem(dimension, 0.0, 1.0)
    rules = Rule[]
    algorithm(evaluate, problem, stoppingcriterion, features=features, transactions=transactions, rules=rules; kwargs...)
    sort!(rules, by=rule -> rule.fitness, rev=true)
    return rules
end

function evaluate(solution; problem, features, transactions, rules, kwargs...)
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
        contingencytable = ContingencyTable(antecedent, consequent, transactions)
        supp = support(contingencytable)
        conf = confidence(contingencytable)
        fitness = calculate_fitness(supp, conf)
        newrule = Rule(antecedent, consequent, fitness, supp, conf)

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
