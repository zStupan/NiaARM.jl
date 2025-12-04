@testset "Bat Algorithm Tests" begin
    sphere(x; kwargs...) = sum(x .^ 2)
    problem = Problem(2, -5.12, 5.12)

    f1 = bat(sphere, problem, StoppingCriterion(maxevals=500), seed=1234)
    f2 = bat(sphere, problem, StoppingCriterion(maxiters=500), seed=1234)
    f3 = bat(sphere, problem, StoppingCriterion(acceptable_fitness=0.1, maxevals=20_000), seed=1234)
    f4 = bat(sphere, problem, StoppingCriterion(maxevals=10), popsize=30, seed=1234)

    @test_throws DomainError bat(sphere, problem, StoppingCriterion(maxevals=10), popsize=0)
    @test f3 <= 0.1
    @test f1 == bat(sphere, problem, StoppingCriterion(maxevals=500), seed=1234)
    @test f2 == bat(sphere, problem, StoppingCriterion(maxiters=500), seed=1234)
    @test f3 == bat(sphere, problem, StoppingCriterion(acceptable_fitness=0.1, maxevals=20_000), seed=1234)
    @test f4 == bat(sphere, problem, StoppingCriterion(maxevals=10), popsize=30, seed=1234)
end
