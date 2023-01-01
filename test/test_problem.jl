@testset "Problem Tests" begin
    @test_throws DomainError Problem(0, 0.0, 2.0)
    @test_throws ArgumentError Problem(10, 2.0, 1.0)
    @test_throws ArgumentError Problem(10, 0.0, 1.0, 1.0, 0.5)
end
