@testset "Population Tests" begin
    rng = MersenneTwister(1234)
    popsize = 50
    problem = Problem(10, -5.12, 5.12)
    population = initpopulation(popsize, problem, rng)

    @test size(population, 1) == 50
    @test size(population, 2) == 10
    @test population == initpopulation(popsize, problem, MersenneTwister(1234))
    @test population != initpopulation(popsize, problem, MersenneTwister())
end