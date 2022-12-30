using NumAssociationRules
using Test

#function TestFeatureDataTypes(dataset)
wiki = dataset("test_data/wiki.csv")
sporty = dataset("test_data/sporty.csv")

# how many features exist in datasets
@test length(wiki.features) == 2
@test length(sporty.features) == 8

# check the dataype for features

@test wiki.features[1].name == "Feat1"
@test wiki.features[1].dtype == "Cat"
@test wiki.features[1].categories == ["A", "B"]
#println(features2)

@test sporty.features[1].name == "duration"
@test sporty.features[1].dtype == "Float"
@test sporty.features[1].min == 43.15
@test sporty.features[1].max == 80.68333333


# test calculation of dimension of the problem
# TODO test it manually
@test wiki.dimension == 8
@test sporty.dimension == 33

transactions = wiki.transactions
features = wiki.features
rules = Rule[]

##### test scenario 1 #####
problem = Problem(wiki.dimension, 0.0, 1.0)
solution = [0.45328107, 0.20655004, 0.2060223, 0.19727931, 0.10291945, 0.18117294, 0.50567635]
fitness = evaluate(solution, problem=problem, transactions=transactions, features=features, rules=rules)

@test length(rules) == 1

# TODO check manually
@test rules[1].support == 3.0 / 7.0
@test rules[1].confidence == 0.75
@test rules[1].fitness == 33/56

##### test scenario 2 #####
