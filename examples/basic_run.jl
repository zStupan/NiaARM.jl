using NiaARM, CSV, DataFrames

# read dataset from CSV file
transactions = CSV.read("dataset.csv", DataFrame)
# set stopping criterion
# there exist three stopping criteria: maxevals, maxiters, acceptable_fitness
criterion = StoppingCriterion(maxevals=5000)
# call function for rule mining
# the second parameter is the name of the optimization algorithm
# for now, Bat Algorithm, Particle Swarm Optimization, Differential Evolution, Genetic Algorithm, Simulated Annealing and Random Search are implemented
rules = mine(transactions, de, criterion, seed=1234)

# print identified rules
for rule in rules
    println(rule)
end
