# Getting Started

This guide walks through installing NiaARM.jl, loading data, and mining your first
association rules.

## Installation

Activate the project and install dependencies:

```julia
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

Or add the package directly in the REPL:

```julia
julia> using Pkg
julia> Pkg.add("NiaARM")
```

## Loading data

NiaARM expects tidy tabular data. You can pass either a `DataFrame` or a path to a CSV
file:

```julia
using NiaARM, CSV, DataFrames

transactions = CSV.read("datasets/sporty.csv", DataFrame)
dataset = Dataset(transactions)
```

The `Dataset` wrapper infers `AbstractFeature`s (numerical ranges or categorical values)
and computes the problem dimensionality required by the optimizers.

## Mining rules

1. Choose an optimization algorithm (e.g. `de`, `pso`, `ga`, `sa`, `randomsearch`).
2. Configure a `StoppingCriterion` (limit evaluations, iterations, or acceptable
   fitness).
3. Pick metrics for fitness aggregation. Provide a vector of metric names (equal
   weights) or a `Dict{Symbol,Float64}` of weights.

```julia
using Random

criterion = StoppingCriterion(maxevals=5_000)
metrics = Dict(:support => 0.4, :confidence => 0.4, :lift => 0.2)

rules = mine(dataset, de, criterion; metrics=metrics, seed=1234)

for rule in rules[1:5]  # top 5
    println(rule, " | fitness=", rule.fitness, " support=", support(rule))
end
```

## Picking metrics

Available metrics include `support`, `confidence`, `coverage`, `lift`, `conviction`,
`interestingness`, `yulesq`, `netconf`, `zhang`, `leverage`, `amplitude`, `inclusion`,
and `comprehensibility`. See [Interestingness Measures](interestingness_measures.md) for
definitions and guidance.

## Reusing discovered rules

Rules are returned as `Rule` objects with cached contingency tables. You can compute any
metric later without re-evaluating transactions:

```julia
r = rules[1]
println(confidence(r))
println(rhs_support(r))
```

## Next steps

- Explore algorithm choices and parameter hints in [Algorithms](algorithms.md).
- Visualize mined rules with [NarmViz.jl](https://github.com/firefly-cpp/NarmViz.jl)
  following [Visualization](visualization.md).
