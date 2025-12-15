# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

NiaARM.jl is a Julia framework for mining numerical association rules based on nature-inspired algorithms for optimization. It defines association rule mining as a continuous optimization problem and uses population-based nature-inspired algorithms to search for high-quality rules.

## Development Commands

### Testing
```bash
# Run all tests
julia --project=test -e 'using Pkg; Pkg.test()'

# Run a single test file
julia --project=test test/test_de.jl

# Run tests with coverage
julia --project=test --code-coverage=user -e 'using Pkg; Pkg.test()'
```

### Documentation
```bash
# Build documentation locally
julia --project=docs docs/make.jl

# The docs use Documenter.jl and are deployed via GitHub Actions
```

### Package Development
```bash
# Activate the development environment
julia --project=.

# Install dependencies
julia --project=. -e 'using Pkg; Pkg.instantiate()'

# Update dependencies
julia --project=. -e 'using Pkg; Pkg.update()'
```

## Architecture

### Core Data Flow

The mining process follows this pipeline:

1. **Dataset → Features → Problem Dimension**: A CSV file or DataFrame is loaded into a `Dataset` struct (src/dataset.jl), which extracts feature metadata and computes the optimization problem dimension.

2. **Optimization Algorithm → narm() → Rules**: An optimization algorithm (e.g., `de`, `pso`, `ga`) minimizes the `narm` objective function (src/narm.jl), which decodes candidate solutions into association rules and evaluates them using interestingness metrics.

3. **Rule Evaluation**: Each rule consists of an antecedent and consequent, evaluated via a `ContingencyTable` (src/rule.jl) that counts transaction coverage and computes metrics like support, confidence, lift, etc.

### Key Components

**Attributes and Features** (src/attribute.jl, src/feature.jl):
- `NumericalAttribute`: Interval constraint [min, max] on a numerical column
- `CategoricalAttribute`: Equality constraint on a categorical column
- `NumericalFeature` / `CategoricalFeature`: Column metadata extracted from datasets
- Features determine the problem dimension: each numerical feature contributes 3 decision variables (2 for bounds + 1 for threshold), categorical features contribute 2

**Solution Encoding** (src/narm.jl):
- Solutions are continuous vectors in [0, 1] decoded into rules
- The last element determines the cut point (where antecedent ends and consequent begins)
- The final N elements (where N = number of features) form a permutation vector that orders attributes
- Each feature has 2-3 variables: a threshold, bounds (for numerical), or category selector (for categorical)
- The `build_rule()` function decodes solutions into attribute constraints

**Objective Function** (src/narm.jl):
- `narm(solution; problem, features, transactions, rules, metrics)` is the fitness function
- It decodes a solution, builds a rule, evaluates it on transactions, and returns negated fitness (for minimization)
- Novel rules with positive support and confidence are stored in the `rules` vector
- Fitness is a weighted combination of interestingness metrics

**Interestingness Metrics** (src/metrics.jl):
- `support`: Fraction of transactions satisfying both antecedent and consequent
- `confidence`: Conditional probability P(consequent | antecedent)
- `coverage`: Support of the antecedent
- `lift`, `conviction`, `interestingness`, `yulesq`, `netconf`, `zhang`, `leverage`: Various statistical measures
- `amplitude`: Measures how much of the feature space the rule covers
- `inclusion`: Fraction of features included in the rule
- `comprehensibility`: Readability measure (inversely related to rule complexity)

**Optimization Algorithms** (src/optimization/algorithms/):
- Each algorithm follows the same interface: `algorithm(feval, problem, stoppingcriterion; kwargs...)`
- Algorithms implemented: Random Search, Differential Evolution (DE), Particle Swarm Optimization (PSO), Genetic Algorithm (GA), Simulated Annealing (SA), Bat Algorithm (BA), L-SHADE, Evolution Strategy (ES), Artificial Bee Colony (ABC), Cuckoo Search (CS), Firefly Algorithm (FA), Flower Pollination Algorithm (FPA)
- All algorithms use `initpopulation()` from src/optimization/utils.jl to initialize populations
- Stopping criteria (src/optimization/stoppingcriterion.jl): `maxevals`, `maxiters`, `acceptable_fitness`

**Problem Definition** (src/optimization/problem.jl):
- `Problem` struct defines the continuous search space with bounds and initialization ranges
- For association rule mining, bounds are always [0, 1]
- The dimension is computed from features: `length(features) + 1 + sum(isnumerical(f) ? 3 : 2 for f in features)`

### Important Patterns

**Rule Construction Flow**:
1. Optimization algorithm generates candidate solution vector
2. `narm()` extracts cut point from last element
3. `build_rule()` decodes remaining elements into attributes
4. Rule is split at cut point into antecedent and consequent
5. `ContingencyTable` evaluates rule against transactions
6. Metrics are computed and combined into fitness
7. Novel rules are added to the results vector

**Metrics Specification**:
Users can specify metrics in three ways:
- `Vector{Symbol}`: Equal weight, e.g., `[:support, :confidence]`
- `Vector{String}`: Equal weight, e.g., `["support", "confidence"]`
- `Dict{Symbol,Float64}`: Custom weights, e.g., `Dict(:support => 0.7, :confidence => 0.3)`

The `normalize_metrics()` and `get_metric_value()` functions in src/narm.jl handle conversion and lookup.

**Algorithm Implementation Requirements**:
- Accept `feval::Function` as the objective function to minimize
- Accept `problem::Problem` for dimension and bounds
- Accept `stoppingcriterion::StoppingCriterion` for termination
- Use `kwargs...` to pass through context (features, transactions, rules, metrics)
- Return the best fitness found
- Check `terminate(stoppingcriterion, evals, iters, bestfitness)` regularly
- Use seeded `Xoshiro` RNG for reproducibility when `seed` is provided

## Testing Patterns

Tests are organized by component (test/test_*.jl). Each algorithm has its own test file that:
1. Creates a small synthetic dataset
2. Defines stopping criterion
3. Calls `mine()` with the algorithm
4. Asserts that rules are discovered

When adding new algorithms or metrics, follow the existing test structure.

## Common Pitfalls

- **Solution dimension mismatch**: Ensure the problem dimension matches the expected length: `numfeatures + 1 + sum(isnumerical ? 3 : 2 for each feature)`
- **Fitness sign**: Algorithms minimize, but we want to maximize interestingness, so `narm()` returns `-fitness`
- **Empty rules**: Rules with empty antecedent or consequent are rejected (src/narm.jl:29-41)
- **Duplicate rules**: Only novel rules are added to the results vector (src/narm.jl:38)
- **Bounds clamping**: When mutating solutions, always clamp to `[problem.lowerbound, problem.upperbound]`
