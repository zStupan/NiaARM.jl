import Base.show

struct Feature
    name::String
    dtype::String
    min_val::Float64
    max_val::Float64
    categories::Vector{String}
end

function Base.show(io::IO, feature::Feature)
    if feature.dtype == "Float"
        print(io, feature.name, "(min = ", round(feature.min_val, digits=2), ", max = ", round(feature.max_val, digits=2), ")")
    elseif feature.dtype == "Int"
        print(io, feature.name, "(min = ", Int(feature.min_val), ", max = ", Int(feature.max_val), ")")
    else
        print(io, feature.name, "(categories = ", feature.categories, ")")
    end
end
