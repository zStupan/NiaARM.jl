function build_rule(solution, features)
    rule = []

    # obtain permutation vector
    permutation = last(solution, length(features))
    permutation = sortperm(permutation)

    for i in permutation
        feature = features[i]

        # set current position in the vector
        vector_position = feature_position(features, i)

        threshold_position = vector_position + 1 + Int(feature.dtype != "Cat")

        if solution[vector_position] > solution[threshold_position]
            if feature.dtype != "Cat"
                min = solution[vector_position] * (feature.max - feature.min) + feature.min
                vector_position = vector_position + 1
                max = solution[vector_position] * (feature.max - feature.min) + feature.min
                if feature.dtype == "Int"
                    min = round(min)
                    max = round(max)
                end
                min, max = minmax(min, max)
                push!(rule, Attribute(feature.name, feature.dtype, min, max, ""))
            else
                categories = feature.categories
                selected = trunc(Int, solution[vector_position] * (length(categories)))
                if selected == 0
                    selected = 1
                end
                push!(rule, Attribute(feature.name, feature.dtype, NaN, NaN, categories[selected]))
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
