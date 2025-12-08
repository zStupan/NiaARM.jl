module NiaARM

using DataFrames
using Random
using CSV
using CategoricalArrays

export Attribute,
    NumericalAttribute,
    CategoricalAttribute,
    Feature,
    NumericalFeature,
    CategoricalFeature,
    isnumerical,
    iscategorical,
    dtype,
    Rule,
    ContingencyTable,
    countall,
    countlhs,
    countrhs,
    countnull,
    support,
    confidence,
    Dataset,
    mine,
    narm,
    Problem,
    StoppingCriterion,
    terminate,
    initpopulation,
    randomsearch,
    pso,
    de,
    ba,
    sa,
    ga,
    lshade,
    es,
    abc

include("optimization/problem.jl")
include("optimization/stoppingcriterion.jl")
include("optimization/population.jl")
include("optimization/utils.jl")
include("optimization/algorithms/randomsearch.jl")
include("optimization/algorithms/pso.jl")
include("optimization/algorithms/de.jl")
include("optimization/algorithms/ba.jl")
include("optimization/algorithms/sa.jl")
include("optimization/algorithms/ga.jl")
include("optimization/algorithms/lshade.jl")
include("optimization/algorithms/es.jl")
include("optimization/algorithms/abc.jl")
include("feature.jl")
include("attribute.jl")
include("rule.jl")
include("metrics.jl")
include("dataset.jl")
include("narm.jl")
include("mine.jl")

end
