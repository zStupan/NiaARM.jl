rules = Rule[]

function mine(dataset)
    # LOAD DATASET
    instances = load_dataset(dataset)
    # GET PREPROCESSED FEATURES
    features = preprocess_data(instances)

    # PARAMETERS
    MAX_ITER = 500
    dimension = problem_dimension(features)
    # RUN random search for now
    rng = MersenneTwister(1234)
    iters = 0
    best_fitness = 0
    while iters < MAX_ITER
        solution = rand!(rng, zeros(dimension))
        fitness = evaluate(solution, features, instances)
        if fitness > best_fitness
            println("Best: ", fitness)
            best_fitness = fitness
        end
        iters += 1
    end

    global rules
    return rules
    
end

function evaluate(solution, features, instances)
    support = -1.0
    confidence = -1.0
    fitness = -1.0
    global rules
    # obtain cut point value and remove this value from a vector of solutions
    cut_value = last(solution)
    pop!(solution)

    # calculate cut point
    cut = cut_point(cut_value, length(features))
    # build a rule from candidate solution
    rule = build_rule(solution, features)
    
    # get antecedent and consequent of rule
    antecedent = rule[begin:cut]
    consequent = rule[cut + 1:end]

    antecedent = collect(skipmissing(antecedent))
    consequent = collect(skipmissing(consequent))

    if length(antecedent) > 0 && length(consequent) > 0
        support, confidence = supp_conf(antecedent, consequent, instances, features)
        fitness = calculate_fitness(support, confidence)
        newrule = Rule(antecedent, consequent, fitness, support, confidence)

        if support > 0.0 && confidence > 0.0 && newrule ∉ rules
            push!(rules, newrule)
        end
    end

    return fitness
end

function cut_point(sol, num_attr)
    """Calculate cut point.
    Note: The cut point denotes which part of the vector belongs to the
    antecedent and which to the consequence of the mined association rule.
    """
    cut = trunc(Int, (sol * num_attr))
    if cut == 0
        cut = 1
    end
    if cut > num_attr - 1
        cut = num_attr - 2
    end
    return cut
end

function supp_conf(antecedent, consequent, instances, features)
    ant_final = 0
    con_final = 0
    for instance in eachrow(instances)
        numant = 0
        # antecedents first
        for attribute in antecedent
            if attribute.dtype != "Cat"
                if instance[attribute.name] >= attribute.min_val && instance[attribute.name] <= attribute.max_val
                    numant = numant + 1
                end
            else
                if attribute.categories == instance[attribute.name]
                    numant = numant + 1
                end
            end
        end

        if numant == length(antecedent)
            ant_final = ant_final + 1
        end

        # consequents
        numcon = 0
        for attribute in consequent
            if attribute.dtype != "Cat"
                if instance[attribute.name] >= attribute.min_val && instance[attribute.name] <= attribute.max_val
                    numcon = numcon + 1
                end
            else
                if attribute.categories == instance[attribute.name]
                    numcon = numcon + 1
                end
            end
        end
        if numcon == length(consequent) && numant == length(antecedent)
            con_final = con_final + 1
        end
    end
    supp = con_final / nrow(instances)
    conf = con_final / ant_final
    return supp, conf
end

# Unused for now
function feature_borders(features, name)
    index = findfirst(feature -> feature.name == name, features)
    feature = features[index]
    return feature.min_val, feature.max_val
end

function calculate_fitness(supp, conf)
    return ((1.0 * supp) + (1.0 * conf)) / 2
end
