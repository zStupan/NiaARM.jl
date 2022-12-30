import Base: show, ==

struct Rule
    antecedent::Vector{Attribute}
    consequent::Vector{Attribute}
    fitness::Float64
    support::Float64
    confidence::Float64
end

function show(io::IO, rule::Rule)
    print(io, "[", join(rule.antecedent, ", "), "]")
    print(io, " => ")
    print(io, "[", join(rule.consequent, ", "), "]")
end

function ==(lhs::Rule, rhs::Rule)
    return lhs.antecedent == rhs.antecedent && lhs.consequent == rhs.consequent
end
