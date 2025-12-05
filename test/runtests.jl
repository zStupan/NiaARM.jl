using NiaARM
using DataFrames
using CSV
using Random
using Test

@testset verbose = true "NiaARM.jl Tests" begin
    include("test_attribute.jl")
    include("test_feature.jl")
    include("test_dataset.jl")
    include("test_rule.jl")
    include("test_metrics.jl")
    include("test_narm.jl")
    include("test_problem.jl")
    include("test_stoppingcriterion.jl")
    include("test_population.jl")
    include("test_randomsearch.jl")
    include("test_de.jl")
    include("test_pso.jl")
    include("test_bat.jl")
    include("test_mine.jl")
end
