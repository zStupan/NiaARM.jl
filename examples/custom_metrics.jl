using NiaARM, CSV, DataFrames

# read dataset from CSV file
transactions = CSV.read("dataset.csv", DataFrame)
criterion = StoppingCriterion(maxevals=5000)

# Example 1: Mine rules using only support metric (Vector{Symbol})
# This will find rules with high support (frequency in the dataset)
metrics_support = [:support]
rules_support = mine(transactions, de, criterion, metrics=metrics_support, seed=1234)

println("Rules optimized for support:")
for rule in rules_support[1:min(5, length(rules_support))]
    println("$rule => Support: $(support(rule)), Confidence: $(confidence(rule))")
end
println()

# Example 2: Mine rules using only confidence metric (Vector{String})
# This will find rules with high confidence (reliability)
metrics_confidence = ["confidence"]
rules_confidence = mine(transactions, de, criterion, metrics=metrics_confidence, seed=1234)

println("Rules optimized for confidence:")
for rule in rules_confidence[1:min(5, length(rules_confidence))]
    println("$rule => Support: $(support(rule)), Confidence: $(confidence(rule))")
end
println()

# Example 3: Mine rules using a weighted combination of metrics (Dict)
# Give more weight to support than confidence
metrics_weighted = Dict(:support => 2.0, :confidence => 1.0)
rules_weighted = mine(transactions, de, criterion, metrics=metrics_weighted, seed=1234)

println("Rules optimized for weighted combination (2*support + 1*confidence):")
for rule in rules_weighted[1:min(5, length(rules_weighted))]
    println("$rule => Support: $(support(rule)), Confidence: $(confidence(rule))")
end
println()

# Example 4: Mine rules using multiple metrics for comprehensive evaluation
# This balances support, confidence, coverage, and interestingness (equal weights)
metrics_comprehensive = [:support, :confidence, :coverage, :interestingness]
rules_comprehensive = mine(transactions, de, criterion, metrics=metrics_comprehensive, seed=1234)

println("Rules optimized for comprehensive metrics:")
for rule in rules_comprehensive[1:min(5, length(rules_comprehensive))]
    println("$rule")
    println("  Support: $(support(rule))")
    println("  Confidence: $(confidence(rule))")
    println("  Coverage: $(coverage(rule))")
    println("  Interestingness: $(interestingness(rule))")
    println()
end

# Example 5: All available metrics
# You can use any combination of these metrics:
# - support: frequency of the rule in the dataset
# - confidence: conditional probability of consequent given antecedent
# - coverage: frequency of antecedent in the dataset
# - interestingness: combined measure of support, confidence, and novelty
# - comprehensibility: how understandable the rule is (based on length)
# - amplitude: range coverage of numerical attributes
# - inclusion: proportion of features involved in the rule
# - rhs_support: frequency of consequent in the dataset

metrics_all = [:support, :confidence, :coverage, :interestingness, :comprehensibility, :amplitude, :inclusion, :rhs_support]
rules_all = mine(transactions, de, criterion, metrics=metrics_all, seed=1234)

println("Rules optimized for all available metrics:")
for rule in rules_all[1:min(3, length(rules_all))]
    println("$rule => Fitness: $(rule.fitness)")
end
