# Artificial Bee Colony (ABC) Algorithm in Julia
# Converted from MATLAB implementation by Dervis Karaboga

using Random
using Printf

# Sphere function - matches MATLAB behavior
function sphere(x)  # Sum across dimensions, return as vector
    return sum(x .^ 2)
end

# Calculate fitness function - matches MATLAB behavior exactly
function calculatefitness(objval)
    return objval >= 0 ? 1.0 / (objval + 1) : 1.0 + abs(objval)
end

# ABC Algorithm
function abc_algorithm(;
    popsize::Int=20,                      # Colony size (employed + onlooker bees)
    limit::Int=100,                   # Abandonment limit
    maxiters::Int=500,                # Maximum number of cycles
    n::Int=4,                         # Number of parameters/dimensions
    ub=5.12,                 # Upper bounds
    lb=-5.12,                # Lower bounds
    feval=sphere,                    # Objective function
)
    foodnumber = div(popsize, 2)
    foods = rand(foodnumber, n) .* (ub - lb) .+ lb

    # Evaluate initial population
    objvals = zeros(foodnumber)
    fitness = zeros(foodnumber)

    bestfitness = Inf
    for i in 1:foodnumber
        v = feval(foods[i, :])
        objvals[i] = v
        fitness[i] = calculatefitness(v)
        bestfitness = min(bestfitness, v)
    end

    # Reset trial counters
    trial = zeros(Int, foodnumber)

    iters = 1
    while iters <= maxiters

        ############ EMPLOYED BEE PHASE ############
        for i in 1:foodnumber
            # The parameter to be changed is determined randomly
            param2change = rand(1:n)

            # A randomly chosen solution is used in producing a mutant solution
            neighbour = rand(1:foodnumber)

            # Randomly selected solution must be different from solution i
            while neighbour == i
                neighbour = rand(1:foodnumber)
            end

            # Generate new solution: v_ij = x_ij + phi_ij * (x_ij - x_kj)
            sol = copy(foods[i, :])
            sol[param2change] = foods[i, param2change] +
                                (foods[i, param2change] - foods[neighbour, param2change]) *
                                (rand() - 0.5) * 2

            # Boundary control - shift to boundaries if out of bounds
            sol = clamp.(sol, lb, ub)

            # Evaluate new solution
            objval = feval(sol)
            fitnessval = calculatefitness(objval)

            # Greedy selection between current solution and mutant
            if fitnessval > fitness[i]
                foods[i, :] = sol
                fitness[i] = fitnessval
                objvals[i] = objval
                trial[i] = 0
            else
                trial[i] += 1
            end
        end

        ############ CALCULATE PROBABILITIES ############
        # Probability proportional to fitness quality
        prob = 0.9 .* fitness ./ maximum(fitness) .+ 0.1

        ############ ONLOOKER BEE PHASE ############
        i = 1
        t = 0
        while t < foodnumber
            if rand() < prob[i]
                t += 1

                # The parameter to be changed is determined randomly
                param2change = rand(1:n)

                # A randomly chosen solution for mutation
                neighbour = rand(1:foodnumber)

                # Must be different from current solution
                while neighbour == i
                    neighbour = rand(1:foodnumber)
                end

                # Generate new solution
                sol = copy(foods[i, :])
                sol[param2change] = foods[i, param2change] +
                                    (foods[i, param2change] - foods[neighbour, param2change]) *
                                    (rand() - 0.5) * 2

                # Boundary control
                sol = clamp.(sol, lb, ub)

                # Evaluate new solution
                objval = feval(sol)
                fitnessval = calculatefitness(objval)

                # Greedy selection
                if fitnessval > fitness[i]
                    foods[i, :] = sol
                    fitness[i] = fitnessval
                    objvals[i] = objval
                    trial[i] = 0
                else
                    trial[i] += 1
                end
            end

            i += 1
            if i == foodnumber + 1
                i = 1
            end
        end

        # Memorize the best food source
        ind = argmin(objvals)
        if objvals[ind] < bestfitness
            bestfitness = objvals[ind]
        end

        ############ SCOUT BEE PHASE ############
        # Determine food source with maximum trial counter
        ind = findlast(trial .== maximum(trial))
        if trial[ind] > limit
            trial[ind] = 0
            sol = (ub - lb) .* rand(n) .+ lb
            objval = feval(sol)
            fitnessval = calculatefitness(objval)
            foods[ind, :] = sol
            fitness[ind] = fitnessval
            objvals[ind] = objval
        end

        @printf("Iter=%d ObjVal=%g\n", iters, bestfitness)
        iters += 1
    end

    return bestfitness
end

# Main execution
function main()
    println("="^60)
    println("Artificial Bee Colony (ABC) Algorithm")
    println("Optimizing Sphere Function")
    println("="^60)
    println()

    # Set random seed for reproducibility (optional)
    Random.seed!(42)

    # Run the ABC algorithm
    result = abc_algorithm(
        popsize=20,
        limit=100,
        maxiters=500,
        n=4,
        ub=5.12,
        lb=-5.12,
        feval=sphere,
    )

    println()
    println("="^60)
    println("Final Result: ", result)
    println("="^60)

    return result
end

# Run the algorithm
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end