function dataset(df::DataFrame)
    features = preprocess_data(df)
    dim = problem_dimension(features)
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
function preprocess_data(dataset)
    preprocessed_data = Feature[]
    features = names(dataset)
    for f in features
        curr_feature = dataset[:, f]
        if eltype(curr_feature) <: AbstractFloat
            dtype = "Float"
            min = minimum(curr_feature)
            max = maximum(curr_feature)
            categories = String[]
        elseif eltype(curr_feature) <: Integer
            dtype = "Int"
            min = minimum(curr_feature)
            max = maximum(curr_feature)
            categories = String[]
        else
            dtype = "Cat"
            min = NaN
            max = NaN
            categories = unique!(curr_feature)
        end
        push!(preprocessed_data, Feature(f, dtype, min, max, categories))
    end
    return preprocessed_data
end

"""
Calculate the dimension of the problem.
"""
function problem_dimension(features)
    dimension = length(features) + 1
    for f in features
        dimension += 2 + Int(f.dtype != "Cat")
    end
    return dimension
end
