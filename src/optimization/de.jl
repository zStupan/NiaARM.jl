function sample(rng::AbstractRNG, n::Int64, k::Int64)
    perm = randperm(rng, n)
    return first(perm, k)
end

"""
    de(feval, problem, stoppingcriterion; popsize=10, cr=0.8, f=0.9, seed=nothing)

Returns the optimal solution to `feval` found using the Differential Evolution algorithm.

Reference:

Storn, R., Price, K. Differential Evolution - A Simple and Efficient Heuristic for global Optimization over Continuous Spaces. Journal of Global Optimization 11, 341-359 (1997). https://doi.org/10.1023/A:1008202821328
"""
function de(feval::Function, problem::Problem, stoppingcriterion::StoppingCriterion; popsize::Int64=50, cr::Float64=0.8, f::Float64=0.9, seed::Union{Int64,Nothing}=nothing, kwargs...)
    if popsize < 4
        throw(DomainError("popsize < 4"))
    end

    evals = 0
    iters = 0
    rng = MersenneTwister(seed)

    pop = initpopulation(popsize, problem, rng)

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

    while !terminate(stoppingcriterion, evals, iters, bestfitness)
        for i = 1:popsize
            perm = sample(rng, popsize, 4)
            @inbounds a = perm[1]
            @inbounds b = perm[2]
            @inbounds c = perm[3]
            @inbounds k = perm[4]

            if a == i
                a = k
            elseif b == i
                b = k
            elseif c == i
                c = k
            end

            r = rand(rng, 1:problem.dimension)

            @inbounds y = pop[i, :]

            for d = 1:problem.dimension
                if d == r || rand(rng) < cr
                    @inbounds y[d] = pop[a, d] + f * (pop[b, d] - pop[c, d])
                    @inbounds y[d] = clamp(y[d], problem.lowerbound, problem.upperbound)
                end
            end

            newfitness = feval(y, problem=problem; kwargs...)

            if newfitness < fitness[i]
                @inbounds fitness[i] = newfitness
                @inbounds pop[i, :] = y

                if newfitness < bestfitness
                    bestfitness = newfitness
                    bestindex = i
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
