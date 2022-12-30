function initpopulation(popsize::Int64, problem::Problem, rng::MersenneTwister)
    return problem.lowerinit .+ rand!(rng, zeros(popsize, problem.dimension)) .* (problem.upperinit - problem.lowerinit)
end
