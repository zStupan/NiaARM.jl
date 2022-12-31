struct StoppingCriterion
    maxevals::Int64
    maxiters::Int64
    acceptable_fitness::Float64

    function StoppingCriterion(maxevals::Int64=typemax(Int64), maxiters::Int64=typemax(Int64), acceptable_fitness::Float64=-Inf)
        if maxevals < 0
            throw(DomainError("maxevals < 0"))
        end

        if maxiters < 0
            throw(DomainError("maxiters < 0"))
        end

        if maxevals == typemax(Int64) && maxiters == typemax(Int64) && acceptable_fitness == -Inf
            throw(ArgumentError("At least one of 'maxevals', 'maxiters' or 'acceptable_fitness' must be set"))
        end

        new(maxevals, maxiters, acceptable_fitness)
    end

    StoppingCriterion(; maxevals::Int64=typemax(Int64), maxiters::Int64=typemax(Int64), acceptable_fitness::Float64=-Inf) = StoppingCriterion(maxevals, maxiters, acceptable_fitness)
end

function terminate(criterion::StoppingCriterion, evals::Int64, iters::Int64, bestfitness::Float64)
    return evals >= criterion.maxevals || iters >= criterion.maxiters || bestfitness <= criterion.acceptable_fitness
end
