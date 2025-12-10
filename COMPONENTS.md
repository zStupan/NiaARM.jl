# Components overview

This document summarizes the main components that are currently available in **NiaARM.jl**.

## Nature-inspired optimization algorithms

The mining of numerical association rules in NiaARM.jl is formulated as an optimization problem that is solved with the stochastic population-based nature-inspired algorithms. At the moment, the following algorithms are implemented in this package and can be passed to `mine` (e.g. `mine(transactions, de, criterion, ...)`):

| Algorithm | Reference |
| --- | --- |
| **Particle Swarm Optimization (PSO)** | J. Kennedy, R. C. Eberhart, *Particle Swarm Optimization*, Proc. 1995 IEEE Int. Conf. on Neural Networks, pp. 1942–1948, 1995. |
| **Differential Evolution (DE)** | R. Storn, K. Price, *Differential Evolution – A Simple and Efficient Heuristic for Global Optimization over Continuous Spaces*, Journal of Global Optimization, 11:341–359, 1997. |
| **Random Search (baseline)** | Generic stochastic search used as a simple baseline optimizer in NiaARM.jl. |
| **Firefly Algorithm** | Yang, Xin-She. Nature-inspired metaheuristic algorithms. Luniver press, 2010. |
| **Bat Algorithm** | Yang, Xin-She. "A new metaheuristic bat-inspired algorithm." Nature inspired cooperative strategies for optimization (NICSO 2010). Springer, Berlin, Heidelberg, 2010. 65-74. |
| **Cuckoo Search** | Yang, Xin-She, and Suash Deb. "Cuckoo search via Lévy flights." Nature & Biologically Inspired Computing, 2009. NaBIC 2009. World Congress on. IEEE, 2009. |
| **Artificial Bee Colony** | Karaboga, D., and Bahriye B. "A powerful and efficient algorithm for numerical function optimization: artificial bee colony (ABC) algorithm." Journal of global optimization 39.3 (2007): 459-471. |
| **LSHADE** | Ryoji Tanabe and Alex Fukunaga: Improving the Search Performance of SHADE Using Linear Population Size Reduction, Proc. IEEE Congress on Evolutionary Computation (CEC-2014), Beijing, July, 2014. |
| **Simulated Annealing** | Kirkpatrick, S., Gelatt, C. D., & Vecchi, M. P. (1983). Optimization by simulated annealing. Science, 220(4598), 671-680. |

NiaARM.jl follows the design and ARM-specific adaptations proposed in the following works on numerical association rule mining:

- I. Fister Jr. et al., *Differential evolution for association rule mining using categorical and numerical attributes*, Intelligent Data Engineering and Automated Learning (IDEAL), 2018.
- I. Fister Jr., V. Podgorelec, I. Fister, *Improved Nature-Inspired Algorithms for Numeric Association Rule Mining*, in: Intelligent Computing and Optimization (ICO 2020), Springer, 2020.
- I. Fister Jr., I. Fister, *A brief overview of swarm intelligence-based algorithms for numerical association rule mining*, Springer Tracts in Nature-Inspired Computing, 2021.
- Ž. Stupan, I. Fister Jr., *NiaARM: A minimalistic framework for Numerical Association Rule Mining*, Journal of Open Source Software, 7(77), 4448, 2022.

## Preprocessing methods

NiaARM.jl focuses on numerical association rules and therefore assumes tabular input data (e.g. a `DataFrame`) that can contain both numerical and categorical attributes. The main preprocessing steps are:

- **Dataset loading**
  - Reading transaction data from CSV via `CSV.read` and `DataFrames.jl`.
  - Construction of an internal `Dataset` representation that stores:
    - the list of features (attributes),
    - transactions,
    - basic statistics used by the optimization and evaluation procedures.

- **Attribute representation**
  - Numerical attributes are represented as **interval attributes** (e.g. `NumericalAttribute`) with lower and upper bounds.
  - Categorical attributes are represented as **categorical attributes** with a finite set of levels.
  - Association rules are built on top of these attribute descriptors (vectors of antecedent and consequent attributes), which are also reused by companion packages (e.g. NarmViz.jl).

- **Basic cleaning / type handling**
  - Delegated to the Julia data ecosystem (CSV.jl, DataFrames.jl), but tightly integrated with `Dataset` so that:
    - column types are mapped to appropriate attribute types,
    - missing values and non-supported types can be filtered or transformed before mining.

## Interestingness measures

During optimization, NiaARM-style frameworks evaluate candidate rules with standard **interestingness measures** (also called quality or interest measures). NiaARM.jl is designed to work with the same family of measures as the original Python implementation, including (but not limited to):

- **Support** – relative frequency of the rule in the transaction database.
- **Confidence** – conditional probability of the consequent given the antecedent.

## Visualization methods

TODO
