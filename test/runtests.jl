using NiaARM
using Test

@testset verbose = true "NiaARM.jl Tests" begin
    @testset "Data Loading Tests" begin
        wiki = dataset("test_data/wiki.csv")
        sporty = dataset("test_data/sporty.csv")

        # how many features exist in datasets
        @test length(wiki.features) == 2
        @test length(sporty.features) == 8

        # check the dataype for features
        @test wiki.features[1].name == "Feat1"
        @test iscategorical(wiki.features[1])
        @test wiki.features[1].categories == ["A", "B"]

        @test sporty.features[1].name == "duration"
        @test isnumerical(sporty.features[1])
        @test dtype(sporty.features[1]) == Float64
        @test sporty.features[1].min == 43.15
        @test sporty.features[1].max == 80.68333333

        # test problem dimensions
        @test wiki.dimension == 8
        @test sporty.dimension == 33
    end

    @testset "Fitness and Metrics Tests" begin
        transactions, features, dimension = dataset("test_data/wiki.csv")
        rules = Rule[]
        problem = Problem(dimension, 0.0, 1.0)
        solution = [0.45328107, 0.20655004, 0.2060223, 0.19727931, 0.10291945, 0.18117294, 0.50567635, 0.33333333]
        fitness = narm(solution, problem=problem, transactions=transactions, features=features, rules=rules)

        @test length(rules) == 1
        @test support(rules[1]) == 3.0 / 7.0
        @test confidence(rules[1]) == 0.75
        @test rules[1].fitness == 33 / 56
        @test rules[1].fitness == -fitness
    end
end
