@testset "Metrics Tests" begin
    transactions = CSV.read("test_data/wiki.csv", DataFrame)
    rule1 = Rule(Attribute[CategoricalAttribute("Feat1", "A")], Attribute[NumericalAttribute("Feat2", 0, 0)], transactions)
    rule2 = Rule(Attribute[CategoricalAttribute("Feat1", "B")], Attribute[NumericalAttribute("Feat2", 1, 1)], transactions)

    @test support(rule1) == 3 / 7
    @test support(rule2) == 2 / 7

    @test confidence(rule1) == 3 / 4
    @test confidence(rule2) == 2 / 3

end
