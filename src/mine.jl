function mine(dataset::Dataset, algorithm::Function, stoppingcriterion::StoppingCriterion; kwargs...)
    problem = Problem(dataset.dimension, 0.0, 1.0)
    rules = Rule[]
    algorithm(narm, problem, stoppingcriterion, features=dataset.features, transactions=dataset.transactions, rules=rules; kwargs...)
    sort!(rules, by=rule -> rule.fitness, rev=true)
    return rules
end

mine(path_or_df::Union{String,DataFrame}, algorithm::Function, stoppingcriterion::StoppingCriterion; kwargs...) = mine(Dataset(path_or_df), algorithm, stoppingcriterion; kwargs...)
