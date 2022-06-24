
function build_rule(solution, features)
    rule = Attribute[]

    # obtain permutation vector
    len = length(solution)
    permutation = solution[len-length(features)+1:len]

    #remove permutation from solution
    deleteat!(solution, len-length(features)+1:len)

    permutation = sortperm(permutation, rev=true)

    for i in permutation
        feature = features[i]

        # set current position in the vector
        vector_position = feature_position(features, feature)

        threshold_position = vector_position + 1

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
                    push!(rule, Attribute(feature.name, feature.dtype, border1, border2, "EMPTY"))

                else
                    categories = feature.categories
                    # need to check
                    selected = trunc(Int, round(solution[vector_position] * (length(categories))))
                    if selected == 0
                        selected = 1
                    end
                    push!(rule, Attribute(feature.name, feature.dtype, 1.00, 1.00, categories[selected]))
            end
        else
            continue
            #push!(rule, Attribute("EMPTY", "EMPTY", 1.00, 1.00, "EMPTY")) # TODO
        end

    end
    return rule
end

# TODO
function feature_position(features, feature)
    position = 0
    for f in features
        if f.dtype == "Int" || f.dtype == "Float"
            position = position + 2
        else
            position = position + 1
        end
        if f == feature
           break
        end
    end
    return position
end
