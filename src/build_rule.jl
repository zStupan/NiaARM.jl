
function build_rule(solution, features)
    rule = []

    # obtain permutation vector
    len = length(solution)
    permutation = solution[len-length(features)+1:len]
    permutation = sortperm(permutation, rev=true)

    for i in permutation
        feature = features[i]

        # set current position in the vector
        vector_position = feature_position(features, i)

        threshold_position = vector_position + 1 + Int(feature.dtype != "Cat")

        if solution[vector_position] > solution[threshold_position]
            if feature.dtype != "Cat"
                border1 = solution[vector_position] * (feature.max_val - feature.min_val) + feature.min_val
                vector_position = vector_position + 1
                border2 = solution[vector_position] * (feature.max_val - feature.min_val) + feature.min_val
                if border1 > border2
                    border1, border2 = border2, border1
                end
                if feature.dtype == "Int"
                    border1 = round(border1)
                    border2 = round(border2)
                end
                push!(rule, Attribute(feature.name, feature.dtype, border1, border2, ""))

            else
                categories = feature.categories
                selected = trunc(Int, solution[vector_position] * (length(categories)))
                if selected == 0
                    selected = 1
                end
                push!(rule, Attribute(feature.name, feature.dtype, 1.00, 1.00, categories[selected]))
            end
        else
            push!(rule, missing)
        end

    end
    return rule
end

function feature_position(features, feature)
    position = 1
    for f in features[begin:feature-1]
        position += Int(f.dtype != "Cat") + 2
    end
    return position
end
