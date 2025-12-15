# Visualization

Visualization is handled by the companion package
[NarmViz.jl](https://github.com/firefly-cpp/NarmViz.jl). It operates directly on the
`Rule` objects returned by `mine`, so you can move seamlessly from mining to visual
analysis.

## Setup

Install NarmViz alongside NiaARM:

```julia
julia> using Pkg
julia> Pkg.add("NarmViz")
```

## Typical workflow

1. Mine rules with NiaARM:

   ```julia
   rules = mine("datasets/sporty.csv", de, StoppingCriterion(maxevals=2_000); metrics=[:support, :confidence])
   ```

2. Pass the rules and original transactions to NarmViz. Consult NarmViz's documentation
   for available plots.

   ```julia
   using NarmViz, CSV, DataFrames
   dataset = Dataset("datasets/sporty.csv")

   visualize(
    rules[1],
    dataset,
    path="example.pdf", # path (if not specified, the plot will be displayed in the GUI)
    allfeatures=false, # visualize all features, not only antecedents and consequence
    antecedent=true, # visualize antecedent
    consequent=true, # visualize consequent
    timeseries=true, # set false for non-time series datasets
    intervalcolumn="interval", # Name of the column which denotes the interval (only for time series datasets)
    interval=3 # which interval to visualize
   )
   ```
