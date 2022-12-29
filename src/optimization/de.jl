function de(feval::Function, problem::Problem, stoppingcriterion::StoppingCriterion; popsize::Int64=50, cr::Float64=0.8, f::Float64=0.9, seed::Union{Int64,Nothing}=nothing, kwargs...)
    if popsize < 3
        error("popsize < 3")
    end

    evals = 0
    iters = 0
    rng = MersenneTwister(seed)

    pop = initpopulation(popsize, problem, rng)

    fitness = zeros(popsize)
    bestfitness = Inf
    bestindex = 1
    for (i, individual) in enumerate(eachrow(pop))
        fitness[i] = feval(individual, problem=problem; kwargs...)
        if fitness[i] < bestfitness
            bestfitness = fitness[i]
            bestindex = i
        end
        evals += 1

        if terminate(stoppingcriterion, evals, iters, bestfitness)
            return bestfitness
        end
    end

    while !terminate(stoppingcriterion, evals, iters, bestfitness)
        permutation = randperm(rng, popsize)
        i = permutation[1]
        a = permutation[2]
        b = permutation[3]
        c = permutation[4]

        r = rand(rng, 1:problem.dimension)

        y = pop[i, :]

        for d = 1:problem.dimension
            if d == r || rand(rng) < cr
                y[d] = pop[a, d] + f * pop[b, d] - pop[c, d]
                y[d] = clamp(y[d], problem.lowerbound, problem.upperbound)
            end 
        end

        newfitness = feval(y, problem=problem; kwargs...)

        if newfitness < fitness[i]
            fitness[i] = newfitness
            pop[i, :] = y

            if newfitness < bestfitness
                bestfitness = newfitness
                bestindex = i
            end
        end

        evals += 1
        iters +=1
    end

    return bestfitness
end
