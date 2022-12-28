"""
load dataset from csv
"""
function load_dataset(dataset_name)
    return DataFrame(CSV.File(dataset_name, header=1, delim=","))
end

"""
Basic preprocessing, calculation of borders, identification
of categorical attributes
"""
function preprocess_data(dataset)
    preprocessed_data = Feature[]
    features = names(dataset)
    for f in features
        curr_feature = dataset[!, f]
        if eltype(curr_feature) <: AbstractFloat
            dtype = "Float"
            min_val = minimum(curr_feature)
            max_val = maximum(curr_feature)
            categories = String[]
        elseif eltype(curr_feature) <: Integer
            dtype = "Int"
            min_val = minimum(curr_feature)
            max_val = maximum(curr_feature)
            categories = String[]
        else
            dtype = "Cat"
            min_val = NaN
            max_val = NaN
            categories = unique!(curr_feature)
        end
        push!(preprocessed_data, Feature(f, dtype, min_val, max_val, categories))
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
