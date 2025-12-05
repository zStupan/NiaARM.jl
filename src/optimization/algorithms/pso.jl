function pso(feval::Function, problem::Problem, stoppingcriterion::StoppingCriterion; popsize::Int64=10, omega::Float64=0.7, c1::Float64=2.0, c2::Float64=2.0, seed::Union{Int64,Nothing}=nothing, kwargs...)
    evals = 0
    iters = 0
    rng = Xoshiro(seed)
    
    range = problem.upperbound - problem.lowerbound
    lowervelocity = -range
    uppervelocity = range
    pop = initpopulation(popsize, problem, rng)
    pbest = copy(pop)
    velocity = -lowervelocity .+ rand!(rng, similar(pop)) .* (uppervelocity - lowervelocity)

    fitness = zeros(popsize)
    bestfitness = Inf
    bestindex = 1
    for (i, individual) in enumerate(eachrow(pop))
        f = feval(individual, problem=problem; kwargs...)
        @inbounds fitness[i] = f
        if f < bestfitness
            bestfitness = f
        end
        evals += 1

        if terminate(stoppingcriterion, evals, iters, bestfitness)
            return bestfitness
        end
    end

    while !terminate(stoppingcriterion, evals, iters, bestfitness)
        for i = 1:popsize
            for d = 1:problem.dimension
                @inbounds velocity[i, d] = omega * velocity[i, d] + c1 * rand(rng) * (pbest[i, d] - pop[i, d]) + c2 * rand(rng) * (pop[bestindex, d] - pop[i, d])
                @inbounds velocity[i, d] = clamp(velocity[i, d], lowervelocity, uppervelocity)
            end

            @inbounds pop[i, :] = pop[i, :] .+ velocity[i, :]
            @inbounds pop[i, :] = clamp!(pop[i, :], problem.lowerbound, problem.upperbound)

            newfitness = feval(pop[i, :], problem=problem; kwargs...)

            if newfitness < fitness[i]
                @inbounds fitness[i] = newfitness
                @inbounds pbest[i, :] = pop[i, :]

                if newfitness < bestfitness
                    bestindex = i
                    bestfitness = newfitness
                end
            end

            evals += 1

            if terminate(stoppingcriterion, evals, iters, bestfitness)
                return bestfitness
            end

        end

        iters += 1
    end

    return bestfitness
end
