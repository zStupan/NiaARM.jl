import Base.show

struct Attribute
    name::String
    dtype::String
    min_val::Float64
    max_val::Float64
    categories::String
end

function Base.show(io::IO, attribute::Attribute)
    if attribute.dtype == "Float"
        print(io, attribute.name, "(min = ", round(attribute.min_val, digits=2), ", max = ", round(attribute.max_val, digits=2), ")")
    elseif attribute.dtype == "Int"
        print(io, attribute.name, "(min = ", Int(attribute.min_val), ", max = ", Int(attribute.max_val), ")")
    else
        print(io, attribute.name, "(category = ", attribute.categories, ")")
    end
end
