function randchoice(rng::AbstractRNG, n::Int64, k::Int64)
    perm = randperm(rng, n)
    return first(perm, k)
end

function randchoice(rng::AbstractRNG, n::AbstractArray, k::Int64)
    perm = shuffle(rng, n)
    return first(perm, k)
end
