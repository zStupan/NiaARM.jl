function randomsearch(feval::Function, problem::Problem, stoppingcriterion::StoppingCriterion; seed::Union{Int64,Nothing}=nothing, kwargs...)
    evals = 0
    iters = 0
    rng = MersenneTwister(seed)

    bestfitness = Inf
    while !terminate(stoppingcriterion, evals, iters, bestfitness)
        solution = problem.lowerinit .+ rand!(rng, zeros(problem.dimension)) .* (problem.upperinit - problem.lowerinit)
        fitness = feval(solution, problem=problem; kwargs...)

        if fitness < bestfitness
            bestfitness = fitness
        end

        evals += 1
        iters += 1
    end
    return bestfitness
end
