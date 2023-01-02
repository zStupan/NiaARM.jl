@testset "Mining Tests" begin
    transactions = CSV.read("test_data/sporty.csv", DataFrame)
    criterion = StoppingCriterion(maxevals=100)
    rules_rs = mine(transactions, randomsearch, criterion, seed=1234)
    rules_de = mine(transactions, de, criterion, seed=1234)
    rules_pso = mine(transactions, pso, criterion, seed=1234)
    rules_wiki = mine("test_data/wiki.csv", de, criterion, seed=1234)

    @test length(rules_rs) > 0
    @test issorted(rules_rs, by=x -> x.fitness, rev=true)
    @test length(rules_de) > 0
    @test issorted(rules_de, by=x -> x.fitness, rev=true)
    @test length(rules_pso) > 0
    @test issorted(rules_pso, by=x -> x.fitness, rev=true)
    @test length(rules_wiki) > 0
    @test issorted(rules_wiki, by=x -> x.fitness, rev=true)
end
