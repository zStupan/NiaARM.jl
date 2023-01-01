@testset "Attribute Tests" begin
    @test_throws ArgumentError NumericalAttribute("name", 12, 3)
    @test dtype(NumericalAttribute("name", 0 , 1)) == Int64
    @test dtype(NumericalAttribute("name", 0.0 , 1.0)) == Float64
    @test dtype(CategoricalAttribute("gender", "M")) == String
    @test isnumerical(NumericalAttribute("name", 0 , 1))
    @test !isnumerical(CategoricalAttribute("gender", "M"))
    @test iscategorical(CategoricalAttribute("gender", "M"))
    @test !iscategorical(NumericalAttribute("name", 0 , 1))
end
