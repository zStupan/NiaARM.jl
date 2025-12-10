import Base: show, ==

abstract type AbstractFeature end

struct NumericalFeature{T<:Real} <: AbstractFeature
    name::String
    min::T
    max::T

    NumericalFeature{T}(name::String, min::T, max::T) where {T<:Real} = min > max ? throw(ArgumentError("min > max")) : new(name, min, max)    

    NumericalFeature(name::String, min::T, max::T) where {T<:Real} = NumericalFeature{T}(name, min, max)
end

dtype(feature::NumericalFeature) = first(typeof(feature).parameters)

show(io::IO, feature::NumericalFeature) = print(io, "$(feature.name)(min = $((feature.min)), max = $((feature.max)))")

==(lhs::NumericalFeature, rhs::NumericalFeature) = lhs.name == rhs.name && isapprox(lhs.min, rhs.min, atol=1e-6, rtol=1e-6) && isapprox(lhs.max, rhs.max, atol=1e-6, rtol=1e-6)

struct CategoricalFeature <: AbstractFeature
    name::String
    categories::Vector{String}
end

dtype(::CategoricalFeature) = String

show(io::IO, feature::CategoricalFeature) = print(io, "$(feature.name)(categories = $((feature.categories)))")

==(lhs::CategoricalFeature, rhs::CategoricalFeature) = lhs.name == rhs.name && lhs.categories == rhs.categories

isnumerical(feature::AbstractFeature) = isa(feature, NumericalFeature)

iscategorical(feature::AbstractFeature) = isa(feature, CategoricalFeature)
