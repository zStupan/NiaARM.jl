import Base: show, ==

abstract type Attribute end

struct NumericalAttribute{T<:Real} <: Attribute
    name::String
    min::T
    max::T
end

dtype(attribute::NumericalAttribute) = first(typeof(attribute).parameters)

show(io::IO, attribute::NumericalAttribute) = print(io, "$(attribute.name)(min = $((attribute.min)), max = $((attribute.max)))")

==(lhs::NumericalAttribute, rhs::NumericalAttribute) = lhs.name == rhs.name && isequal(lhs.min, rhs.min) && isequal(lhs.max, rhs.max)

struct CategoricalAttribute <: Attribute
    name::String
    category::String
end

show(io::IO, attribute::CategoricalFeature) = print(io, "$(attribute.name)(category = $((attribute.category)))")

==(lhs::CategoricalAttribute, rhs::CategoricalAttribute) = lhs.name == rhs.name && lhs.category == rhs.category

isnumerical(attribute::Attribute) = isa(attribute, NumericalAttribute)

iscategorical(attribute::Attribute) = isa(attribute, CategoricalAttribute)
