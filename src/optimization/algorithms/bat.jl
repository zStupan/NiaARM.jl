function bat(feval::Function, problem::Problem, stoppingcriterion::StoppingCriterion; popsize::Int64=20, fmin::Float64=0.0, fmax::Float64=2.0, alpha::Float64=0.9, gamma::Float64=0.9, seed::Union{Int64,Nothing}=nothing, kwargs...)
    if popsize <= 0
        throw(DomainError("popsize <= 0"))
    end

    evals = 0
    iters = 0
    rng = Xoshiro(seed)

    pop = initpopulation(popsize, problem, rng)
    velocity = zeros(popsize, problem.dimension)
    freq = zeros(popsize)
    loudness = ones(popsize)
    pulse_rate = fill(0.5, popsize)

    fitness = zeros(popsize)
    bestfitness = Inf
    bestindex = 1

    for (i, individual) in enumerate(eachrow(pop))
        @inbounds fitness[i] = feval(individual, problem=problem; kwargs...)
        if fitness[i] < bestfitness
            @inbounds bestfitness = fitness[i]
            bestindex = i
        end
        evals += 1

        if terminate(stoppingcriterion, evals, iters, bestfitness)
            return bestfitness
        end
    end

    best = copy(pop[bestindex, :])

    while !terminate(stoppingcriterion, evals, iters, bestfitness)
        mean_loudness = sum(loudness) / popsize
        for i = 1:popsize
            freq[i] = fmin + (fmax - fmin) * rand(rng)

            @inbounds velocity[i, :] = velocity[i, :] .+ (pop[i, :] .- best) .* freq[i]
            @inbounds candidate = pop[i, :] .+ velocity[i, :]
            @inbounds clamp!(candidate, problem.lowerbound, problem.upperbound)

            if rand(rng) > pulse_rate[i]
                @inbounds candidate = best .+ mean_loudness .* (rand(rng, problem.dimension) .- 0.5)
                @inbounds clamp!(candidate, problem.lowerbound, problem.upperbound)
            end

            newfitness = feval(candidate, problem=problem; kwargs...)

            if newfitness < fitness[i] && rand(rng) < loudness[i]
                @inbounds pop[i, :] = candidate
                @inbounds fitness[i] = newfitness

                loudness[i] *= alpha
                pulse_rate[i] = 1 - (1 - pulse_rate[i]) * exp(-gamma)

                if newfitness < bestfitness
                    bestfitness = newfitness
                    best = copy(candidate)
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
