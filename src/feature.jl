import Base: show, ==

abstract type Feature end

struct NumericalFeature{T<:Real} <: Feature
    name::String
    min::T
    max::T
end

dtype(feature::NumericalFeature) = first(typeof(feature).parameters)

show(io::IO, feature::NumericalFeature) = print(io, "$(feature.name)(min = $((feature.min)), max = $((feature.max)))")

==(lhs::NumericalFeature, rhs::NumericalFeature) = lhs.name == rhs.name && isequal(lhs.min, rhs.min) && isequal(lhs.max, rhs.max)

struct CategoricalFeature <: Feature
    name::String
    categories::Vector{String}
end

dtype(::CategoricalFeature) = String

show(io::IO, feature::CategoricalFeature) = print(io, "$(feature.name)(categories = $((feature.categories)))")

==(lhs::CategoricalFeature, rhs::CategoricalFeature) = lhs.name == rhs.name && lhs.category == rhs.category

isnumerical(feature::Feature) = isa(feature, NumericalFeature)

iscategorical(feature::Feature) = isa(feature, CategoricalFeature)
