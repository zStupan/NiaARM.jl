# Algorithms

NiaARM.jl implements several population-based metaheuristics. All optimizers share a common
signature `(feval, problem, stoppingcriterion; kwargs...)` where `feval` is `narm`.

## Differential Evolution (DE)

- Entry point: `de`
- Strategy: DE/rand/1/bin with greedy selection.
- Parameters: `popsize`, `cr` (crossover rate), `f` (differential weight).
- **Reference**: Storn, R., & Price, K. (1997). Differential evolution–a simple and efficient heuristic for global optimization over continuous spaces. *Journal of Global Optimization*, 11(4), 341-359.

## Particle Swarm Optimization (PSO)

- Entry point: `pso`
- Inertia-weight PSO with personal and global best attraction.
- Parameters: `popsize`, `omega`, `c1`, `c2`.
- **Reference**: Kennedy, J., & Eberhart, R. (1995). Particle swarm optimization. *Proceedings of ICNN'95 - International Conference on Neural Networks*, 4, 1942-1948.

## Genetic Algorithm (GA)

- Entry point: `ga`
- Tournament selection, uniform crossover, and per-gene mutation.
- Parameters: `popsize`, `tournament_size`, `crossover_rate`, `mutation_rate`.
- **Reference**: Holland, J. H. (1992). *Adaptation in Natural and Artificial Systems: An Introductory Analysis with Applications to Biology, Control, and Artificial Intelligence*. MIT Press.

## Simulated Annealing (SA)

- Entry point: `sa`
- Gaussian perturbations with multiplicative cooling.
- Parameters: `initial_temp`, `cooling_rate`, `step_size`.
- **Reference**: Kirkpatrick, S., Gelatt, C. D., & Vecchi, M. P. (1983). Optimization by simulated annealing. *Science*, 220(4598), 671-680.

## Bat Algorithm (BA)

- Entry point: `ba`
- Frequency-tuned velocity updates with adaptive loudness and pulse rate.
- Parameters: `popsize`, `fmin`, `fmax`, `loudness0`, `pulse_rate0`, `alpha`, `gamma`.
- **Reference**: Yang, X. S. (2010). A new metaheuristic bat-inspired algorithm. In *Nature Inspired Cooperative Strategies for Optimization (NICSO 2010)* (pp. 65-74). Springer.

## Artificial Bee Colony (ABC)

- Entry point: `abc`
- Worker/onlooker/scout phases over food sources.
- Parameters: `popsize`, `limit`.
- **Reference**: Karaboga, D. (2005). An idea based on honey bee swarm for numerical optimization. *Technical Report TR06*, Erciyes University, Engineering Faculty, Computer Engineering Department.

## Cuckoo Search (CS)

- Entry point: `cs`
- Lévy flights with abandonment probability `pa`.
- Parameters: `popsize`, `pa`.
- **Reference**: Yang, X. S., & Deb, S. (2009). Cuckoo search via Lévy flights. *2009 World Congress on Nature & Biologically Inspired Computing (NaBIC)*, 210-214.

## Firefly Algorithm (FA)

- Entry point: `fa`
- Attraction decays exponentially with distance; random walks shrink via `theta`.
- Parameters: `popsize`, `alpha`, `beta0`, `gamma`, `theta`.
- **Reference**: Yang, X. S. (2008). Firefly algorithm. In *Nature-Inspired Metaheuristic Algorithms* (pp. 79-90). Luniver Press.

## Flower Pollination Algorithm (FPA)

- Entry point: `fpa`
- Switches between global Lévy flights and local pollination using probability `p`.
- Parameters: `popsize`, `p`.
- **Reference**: Yang, X. S. (2012). Flower pollination algorithm for global optimization. In *Unconventional Computation and Natural Computation* (pp. 240-249). Springer.

## L-SHADE

- Entry point: `lshade`
- Current-to-pbest/1/bin DE with success-history adaptation and population reduction.
- Parameters: `popsize`, `memorysize`, `pbestrate`, `archiverate`
  (requires `StoppingCriterion.maxevals` to be set).
- **Reference**: Tanabe, R., & Fukunaga, A. (2014). Improving the search performance of SHADE using linear population size reduction. *2014 IEEE Congress on Evolutionary Computation (CEC)*, 1658-1665.

## Evolution Strategy (ES)

- Entry point: `es`
- Self-adaptive step sizes with log-normal mutations in a (μ, λ) setting.
- Parameters: `mu`, `lambda`, `sigmainit`, `tau`, `tauprime`.
- **Reference**: Schwefel, H. P. (1977). *Numerische Optimierung von Computer-Modellen mittels der Evolutionsstrategie*. Birkhäuser.

## Random Search

- Entry point: `randomsearch`
- Generic stochastic search used as a simple baseline optimizer.
