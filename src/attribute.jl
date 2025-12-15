import Base: show, ==

"""
    AbstractAttribute

Abstract supertype for all attribute descriptors that can appear in a mined rule.
"""
abstract type AbstractAttribute end

"""
    NumericalAttribute(name, min, max)

Closed interval constraint on a numerical feature used in rule antecedents or consequents.
`min` must be less than or equal to `max`; the numeric element type is inferred from the
provided bounds.
"""
struct NumericalAttribute{T<:Real} <: AbstractAttribute
    name::String
    min::T
    max::T

    NumericalAttribute{T}(name::String, min::T, max::T) where {T<:Real} = min > max ? throw(ArgumentError("min > max")) : new(name, min, max)

    NumericalAttribute(name::String, min::T, max::T) where {T<:Real} = NumericalAttribute{T}(name, min, max)
end

"""
    dtype(attribute)

Return the underlying numeric element type carried by an attribute or feature. For
categorical elements, `String` is returned.
"""
dtype(attribute::NumericalAttribute) = first(typeof(attribute).parameters)

show(io::IO, attribute::NumericalAttribute) = print(io, "$(attribute.name)(min = $((attribute.min)), max = $((attribute.max)))")

==(lhs::NumericalAttribute, rhs::NumericalAttribute) = lhs.name == rhs.name && isapprox(lhs.min, rhs.min, atol=1e-6, rtol=1e-6) && isapprox(lhs.max, rhs.max, atol=1e-6, rtol=1e-6)

"""
    CategoricalAttribute(name, category)

Equality constraint on a categorical feature. Rules will match rows where the column
`name` equals `category`.
"""
struct CategoricalAttribute <: AbstractAttribute
    name::String
    category::String
end

dtype(::CategoricalAttribute) = String

show(io::IO, attribute::CategoricalAttribute) = print(io, "$(attribute.name)(category = $((attribute.category)))")

==(lhs::CategoricalAttribute, rhs::CategoricalAttribute) = lhs.name == rhs.name && lhs.category == rhs.category

"""
    isnumerical(attribute)

Return `true` when an attribute is numerical.
"""
isnumerical(attribute::AbstractAttribute) = isa(attribute, NumericalAttribute)

"""
    iscategorical(attribute)

Return `true` when an attribute is categorical.
"""
iscategorical(attribute::AbstractAttribute) = isa(attribute, CategoricalAttribute)
