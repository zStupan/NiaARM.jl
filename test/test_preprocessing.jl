using NumAssociationRules
using Test

function TestDatasetLoading(dataset)
    df = load_dataset(dataset)
    features = preprocess_data(df)
    return features
end

function GetInstance(dataset)
    instances = load_dataset(dataset)
    return instances
end

function TestAntecedentConsequence(sol, instances, features)

    len = length(sol)
    cut_value = last(sol)
    pop!(sol)

    # calculate cut point
    cut = cut_point(cut_value, length(features))

    rule = build_rule(sol, features)

    # get antecedent and consequent of rule
    antecedent = rule[1:cut]
    consequent = rule[(cut+1):end]

    return antecedent, consequent, cut_value, cut
end

#function TestFeatureDataTypes(dataset)
features1 = TestDatasetLoading("test_data/wiki.csv")
features2 = TestDatasetLoading("test_data/sporty.csv")

# how many features exist in datasets
@test length(features1) == 2
@test length(features2) == 8

# check the dataype for features

@test features1[1].name == "Feat1"
@test features1[1].dtype == "Cat"
@test features1[1].categories == ["A", "B"]
#println(features2)

@test features2[1].name == "duration"
@test features2[1].dtype == "Float"
@test features2[1].min_val == 43.15
@test features2[1].max_val == 80.68333333


# test calculation of dimension of the problem
# TODO test it manually
@test problem_dimension(features1) == 8
@test problem_dimension(features2) == 33

instances = GetInstance("test_data/wiki.csv")
features = TestDatasetLoading("test_data/wiki.csv")

##### test scenario 1 #####
sol = [0.98328107, 0.93655004, 0.6860223, 0.78527931, 0.96291945, 0.18117294, 0.50567635, 0.33333333]
antecedent, consequent, cut_value, cut = TestAntecedentConsequence(sol, instances, features)

@test cut_value == 2
@test cut == 0.33333333

support, confidence = supp_conf(antecedent, consequent, instances, features)

# TODO check manually
@test support == 0.42857142857142855
@test confidence == 1.0

##### test scenario 2 #####
