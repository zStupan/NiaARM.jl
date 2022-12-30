struct StoppingCriterion
    maxevals::Int64
    maxiters::Int64
    acceptable_fitness::Float64

    StoppingCriterion(; maxevals::Int64=typemax(Int64), maxiters::Int64=typemax(Int64), acceptable_fitness::Float64=-Inf) = new(maxevals, maxiters, acceptable_fitness)
end

function terminate(criterion::StoppingCriterion, evals::Int64, iters::Int64, bestfitness::Float64)
    return evals >= criterion.maxevals || iters >= criterion.maxiters || bestfitness <= criterion.acceptable_fitness
end
