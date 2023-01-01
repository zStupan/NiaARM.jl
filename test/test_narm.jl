@testset "Fitness Tests" begin
    wiki = Dataset("test_data/wiki.csv")
    rules = Rule[]
    problem = Problem(wiki.dimension, 0.0, 1.0)
    solution = [0.45328107, 0.20655004, 0.2060223, 0.19727931, 0.10291945, 0.18117294, 0.50567635, 0.33333333]
    fitness = narm(solution, problem=problem, transactions=wiki.transactions, features=wiki.features, rules=rules)

    @test length(rules) == 1
    @test rules[1].fitness == 33 / 56
    @test rules[1].fitness == -fitness
    @test_throws DimensionMismatch narm([1.0, 2.0, 3.0], problem=problem, transactions=wiki.transactions, features=wiki.features, rules=rules)
end
