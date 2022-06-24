
function mine(dataset)
    # LOAD DATASET
    instances = load_dataset(dataset)
    # GET PREPROCESSED FEATURES
    features = preprocess_data(instances)

    # PARAMETERS
    MAX_ITER = 500
    NP = problem_dimension(features)
    println("dimensions: ", NP)
    # RUN random search for now
    iters = 0
    best_fitness = 0.0
    rng = MersenneTwister(1234)
    while iters < MAX_ITER
        solution = rand!(rng, zeros(NP))
        fitness = evaluate(solution, features, instances)
        if fitness > 0.0
            println("Best: ", fitness)
            global best_fitness = fitness
        end
        global iters += 1
    end
end

function evaluate(solution, features, instances)
    support = -1.0
    confidence = -1.0
    fitness = -1.0
    rules = Rule[]
    # obtain cut point value and remove this value from a vector of solutions
    cut_value = last(solution)
    pop!(solution)

    # calculate cut point
    cut = cut_point(cut_value, length(features))
    # build a rule from candidate solution
    rule = build_rule(solution, features)

    println("Rule: ", rule)
    # get antecedent and consequent of rule
    if length(rule) > 0
        antecedent = rule[1:cut]
        consequent = rule[(cut+1):end]
    else
        antecedent = Rule[]
        consequent = Rule[]
    end

    if length(antecedent) > 0 && length(consequent) > 0
        support, confidence = supp_conf(antecedent, consequent, instances, features)
    end

    if support > 0.0 && confidence > 0.0
        fitness = calculate_fitness(support, confidence)

        newrule = Rule(antecedent, consequent, fitness, support, confidence)

        if newrule ∉ rules
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
                feature_min, feature_max = feature_borders(features, attribute.name)
                if instance[attribute.name] >= feature_min && instance[attribute.name] < feature_max
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
                feature_min, feature_max = feature_borders(features, attribute.name)
                if instance[attribute.name] >= feature_min && instance[attribute.name] < feature_max
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

function feature_borders(features, name)
    min_val = 0.0
    max_val = 0.0
    for f in features
        if f.name == name
            min_val = f.min_val
            max_val = f.max_val
        end
    end
    return min_val, max_val
end

function calculate_fitness(supp, conf)
    return ((1.0 * supp) + (1.0 * conf)) / 2
end
