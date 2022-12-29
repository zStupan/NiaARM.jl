module NumAssociationRules
using DataFrames
using Random
using CSV
using CategoricalArrays

export Attribute, Feature, Rule, ContingencyTable, support, confidence, evaluate, load_dataset, preprocess_data, problem_dimension, mine,
        Problem, StoppingCriterion, terminate, initpopulation, randomsearch, pso, de

include("optimization/problem.jl")
include("optimization/stoppingcriterion.jl")
include("optimization/population.jl")
include("optimization/randomsearch.jl")
include("optimization/pso.jl")
include("optimization/de.jl")
include("feature.jl")
include("attribute.jl")
include("rule.jl")
include("metrics.jl")
include("preprocess.jl")
include("build_rule.jl")
include("evaluate.jl")

end
