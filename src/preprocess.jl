using DataFrames
using CSV
using CategoricalArrays

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
        curr_feature = dataset[!,f]
        if typeof(curr_feature) == Vector{Float64}
            dtype = "Float"
            min_val = minimum(curr_feature)
            max_val = maximum(curr_feature)
            categories = String[]
        elseif typeof(curr_feature) == Vector{Int64}
            dtype = "Int"
            min_val = minimum(curr_feature)
            max_val = maximum(curr_feature)
            categories = String[]
        else
            dtype = "Cat"
            min_val = -1.0
            max_val = -1.0
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
        if f.dtype == "Float" || f.dtype == "Int"
            dimension += 3
        else
            dimension += 2
        end
    end

    return dimension
end
