
mutable struct Rule
    antecedent::Vector{Attribute}
    consequent::Vector{Attribute}
    fitness::Float64
    support::Float64
    confidence::Float64
end

