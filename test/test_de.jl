@testset "Differential Evolution Tests" begin
    sphere(x; kwargs...) = sum(x .^ 2)
    problem = Problem(2, -5.12, 5.12)
    f1 = de(sphere, problem, StoppingCriterion(maxevals=500), seed=1234)
    f2 = de(sphere, problem, StoppingCriterion(maxiters=500), seed=1234)
    f3 = de(sphere, problem, StoppingCriterion(acceptable_fitness=0.0), seed=1234)

    @test f3 <= 0.0
    @test f1 == de(sphere, problem, StoppingCriterion(maxevals=500), seed=1234)
    @test f2 == de(sphere, problem, StoppingCriterion(maxiters=500), seed=1234)
    @test f3 == de(sphere, problem, StoppingCriterion(acceptable_fitness=0.0), seed=1234)
    @test f1 == f2
end