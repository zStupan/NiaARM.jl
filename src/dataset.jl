function dataset(df::DataFrame)
    features = getfeatures(df)
    dim = problemdim(features)
    return (transactions=df, features=features, dimension=dim)
end

function dataset(path::String)
    df = DataFrame(CSV.File(path, header=1, delim=","))
    return dataset(df)
end

"""
Basic preprocessing, calculation of borders, identification
of categorical attributes
"""
function getfeatures(dataset)
    features = Feature[]
    for name in names(dataset)
        curr_feature = dataset[:, name]
        if eltype(curr_feature) <: Real
            min = minimum(curr_feature)
            max = maximum(curr_feature)
            push!(features, NumericalFeature(name, min, max))
        else
            categories = unique(string.(curr_feature))
            push!(features, CategoricalFeature(name, categories))
        end
    end
    return features
end

"""
Calculate the dimension of the problem.
"""
function problemdim(features)
    dimension = length(features) + 1
    for f in features
        dimension += 2 + Int(isnumerical(f))
    end
    return dimension
end
