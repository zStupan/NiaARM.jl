import Base: show, ==

struct Attribute
    name::String
    dtype::String
    min::Float64
    max::Float64
    category::String
end

function show(io::IO, attribute::Attribute)
    if attribute.dtype == "Float"
        print(io, attribute.name, "(min = ", round(attribute.min, digits=2), ", max = ", round(attribute.max, digits=2), ")")
    elseif attribute.dtype == "Int"
        print(io, attribute.name, "(min = ", Int(attribute.min), ", max = ", Int(attribute.max), ")")
    else
        print(io, attribute.name, "(category = ", attribute.category, ")")
    end
end

function ==(lhs::Attribute, rhs::Attribute)
    return lhs.name == rhs.name && lhs.dtype == rhs.dtype && isequal(lhs.min, rhs.min) && isequal(lhs.max, rhs.max) && lhs.category == rhs.category
end
