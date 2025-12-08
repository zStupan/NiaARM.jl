"""
    es(feval, problem, stoppingcriterion; kwargs...)

Evolution Strategy with (μ,λ)-selection, uncorrelated mutation and self-adaptive step sizes.

# Arguments
- `mu::Int64=15`: Parent population size
- `lambda::Int64=100`: Offspring population size (must be ≥ mu)
- `sigma_init::Float64=0.3`: Initial step size as fraction of search range
- `tau::Union{Float64,Nothing}=nothing`: Learning rate (auto-computed if nothing)
- `tauprime::Union{Float64,Nothing}=nothing`: Global learning rate (auto-computed if nothing)
- `seed::Union{Int64,Nothing}=nothing`: Random seed
"""
function es(
    feval::Function,
    problem::Problem,
    stoppingcriterion::StoppingCriterion;
    mu::Int64=15,
    lambda::Int64=100,
    sigmainit::Float64=0.3,
    tau::Union{Float64,Nothing}=nothing,
    tauprime::Union{Float64,Nothing}=nothing,
    seed::Union{Int64,Nothing}=nothing,
    kwargs...)
    if mu < 1
        throw(DomainError("mu < 1"))
    end
    if lambda < mu
        throw(DomainError("lambda < mu"))
    end

    n = problem.dimension
    lb = problem.lowerbound
    ub = problem.upperbound

    # Learning rates (Schwefel's formulas)
    if tau === nothing
        tau = 1.0 / sqrt(2.0 * sqrt(n))
    end

    if tauprime === nothing
        tauprime = 1.0 / sqrt(2.0 * n)
    end

    sigmamin = 1e-10
    sigmamax = (ub - lb) / sqrt(n)

    evals = 0
    iters = 0
    rng = Xoshiro(seed)

    population = initpopulation(mu, problem, rng)
    popsigma = fill(sigmainit * (ub - lb), mu, n)
    fitness = zeros(mu)
    bestfitness = Inf

    for i = 1:mu
        @inbounds fx = feval(population[i, :], problem=problem; kwargs...)
        @inbounds fitness[i] = fx
        if fx < bestfitness
            bestfitness = fx
        end
        evals += 1
        if terminate(stoppingcriterion, evals, iters, bestfitness)
            return bestfitness
        end
    end

    offspring = zeros(lambda, n)
    offspringsigma = zeros(lambda, n)
    offspringfitness = zeros(lambda)

    while !terminate(stoppingcriterion, evals, iters, bestfitness)
        @inbounds for i = 1:lambda
            parentindex = rand(rng, 1:mu)

            # Self-adapt step size
            globalnoise = randn(rng)
            offspringsigma[i, :] = popsigma[parentindex, :] .* exp.(tauprime * globalnoise .+ tau .* randn(rng, n))
            offspringsigma[i, :] = clamp.(offspringsigma[i, :], sigmamin, sigmamax)
            
            # Mutate
            offspring[i, :] = population[parentindex, :] .+ offspringsigma[i, :] .* randn(rng, n)
            offspring[i, :] = clamp.(offspring[i, :], lb, ub)

            fx = feval(offspring[i, :], problem=problem; kwargs...)
            offspringfitness[i] = fx

            if fx < bestfitness
                bestfitness = fx
            end

            evals += 1
            if terminate(stoppingcriterion, evals, iters, bestfitness)
                return bestfitness
            end
        end

        # (μ,λ) selection
        keep = partialsortperm(offspringfitness, 1:mu)
        population = offspring[keep, :]
        popsigma = offspringsigma[keep, :]
        fitness = offspringfitness[keep]

        iters += 1
    end

    return bestfitness
end
