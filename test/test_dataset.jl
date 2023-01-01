@testset "Dataset Tests" begin
    wiki_df = CSV.read("test_data/wiki.csv", DataFrame)
    sporty_df = CSV.read("test_data/sporty.csv", DataFrame)

    wiki = Dataset("test_data/wiki.csv")
    sporty = Dataset("test_data/sporty.csv")

    @test Dataset(wiki_df).transactions == wiki.transactions
    @test Dataset(sporty_df).transactions == sporty.transactions

    @test Dataset(wiki_df).features == wiki.features
    @test Dataset(sporty_df).features == sporty.features

    @test Dataset(wiki_df).dimension == wiki.dimension
    @test Dataset(sporty_df).dimension == sporty.dimension

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
