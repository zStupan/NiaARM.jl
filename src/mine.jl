function mine(path_or_df, algorithm, stoppingcriterion; kwargs...)
    transactions, features, dimension = dataset(path_or_df)
    problem = Problem(dimension, 0.0, 1.0)
    rules = Rule[]
    algorithm(narm, problem, stoppingcriterion, features=features, transactions=transactions, rules=rules; kwargs...)
    sort!(rules, by=rule -> rule.fitness, rev=true)
    return rules
end
