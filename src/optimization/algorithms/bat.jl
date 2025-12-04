function bat(feval::Function, problem::Problem, stoppingcriterion::StoppingCriterion; popsize::Int64=20, fmin::Float64=0.0, fmax::Float64=2.0, alpha::Float64=0.9, gamma::Float64=0.9, seed::Union{Int64,Nothing}=nothing, kwargs...)
    if popsize <= 0
        throw(DomainError("popsize <= 0"))
    end

    evals = 0
    iters = 0
    rng = Xoshiro(seed)

    dim = problem.dimension
    pop = initpopulation(popsize, problem, rng)
    velocity = zeros(popsize, dim)
    freq = zeros(popsize)
    loudness = ones(popsize)
    pulse_rate = fill(0.5, popsize)
    fitness = zeros(popsize)

    candidate = zeros(dim)
    randbuf = similar(candidate)
    best = similar(candidate)

    bestfitness = Inf
    bestindex = 1

    for (i, individual) in enumerate(eachrow(pop))
        f = feval(individual, problem=problem; kwargs...)
        @inbounds fitness[i] = f
        if f < bestfitness
            bestfitness = f
            bestindex = i
        end
        evals += 1

        if terminate(stoppingcriterion, evals, iters, bestfitness)
            return bestfitness
        end
    end

    @inbounds best .= pop[bestindex, :]

    lb = problem.lowerbound
    ub = problem.upperbound
    has_vector_bounds = lb isa AbstractArray

    while !terminate(stoppingcriterion, evals, iters, bestfitness)
        mean_loudness = sum(loudness) / popsize
        for i = 1:popsize
            freq[i] = fmin + (fmax - fmin) * rand(rng)

            @views @inbounds begin
                vi = velocity[i, :]
                xi = pop[i, :]
                @. vi = vi + (xi - best) * freq[i]
                @. candidate = xi + vi
            end

            if has_vector_bounds
                @inbounds for d = 1:dim
                    lbd = lb[d]
                    ubd = ub[d]
                    v = candidate[d]
                    candidate[d] = v < lbd ? lbd : (v > ubd ? ubd : v)
                end
            else
                clamp!(candidate, lb, ub)
            end

            if rand(rng) > pulse_rate[i]
                rand!(rng, randbuf)
                @views @. candidate = best + mean_loudness * (randbuf - 0.5)

                if has_vector_bounds
                    @inbounds for d = 1:dim
                        lbd = lb[d]
                        ubd = ub[d]
                        v = candidate[d]
                        candidate[d] = v < lbd ? lbd : (v > ubd ? ubd : v)
                    end
                else
                    clamp!(candidate, lb, ub)
                end
            end

            newfitness = feval(candidate, problem=problem; kwargs...)

            if newfitness < fitness[i] && rand(rng) < loudness[i]
                @views @inbounds pop[i, :] .= candidate
                @inbounds fitness[i] = newfitness

                loudness[i] *= alpha
                pulse_rate[i] *= exp(-gamma)

                if newfitness < bestfitness
                    bestfitness = newfitness
                    @inbounds best .= candidate
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
