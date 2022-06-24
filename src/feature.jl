mutable struct Feature
    name::String
    dtype::String
    min_val::Float64
    max_val::Float64
    categories::Vector{String}
end
