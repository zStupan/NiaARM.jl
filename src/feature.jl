import Base: show

struct Feature
    name::String
    dtype::String
    min::Float64
    max::Float64
    categories::Vector{String}
end

function show(io::IO, feature::Feature)
    if feature.dtype == "Float"
        print(io, "$(feature.name)(min = $(round(feature.min, digits=2)), max = $(round(feature.max, digits=2)))")
    elseif feature.dtype == "Int"
        print(io, "$(feature.name)(min = $(Int(feature.min)), max = $(Int(feature.max)))")
    else
        print(io, "$(feature.name)(categories = $(feature.categories))")
    end
end
