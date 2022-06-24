module NumAssociationRules
using DataFrames
using Random

export Attribute, build_rule, feature_position, mine, evaluate, cut_point,
        supp_conf, feature_borders, calculate_fitness, Feature, load_dataset,
        preprocess_data, problem_dimension, Rule

include("preprocess.jl")
include("evaluate.jl")
include("feature.jl")
include("attribute.jl")
include("rule.jl")
include("build_rule.jl")

end
