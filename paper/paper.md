---
title: 'NiaARM.jl: A Julia Framework for Numerical Association Rule Mining Using Nature‑Inspired Optimization Algorithms'
tags:
  - Julia
  - numerical association rule mining
  - visualization
authors:
  - name: Žiga Stupan
    orcid: 0000-0001-9847-7306
    affiliation: 1 
  - name: Tilen Hliš
    orcid: 0000-0002-4973-4844
    affiliation: 1
  - name: Iztok Fister Jr.
    orcid: 0000-0002-6418-1272
    corresponding: true 
    affiliation: 1
affiliations:
  - name: University of Maribor, Faculty of Electrical Engineering and Computer Science
    index: 1
date: 7 December 2025
bibliography: paper.bib

# Summary

NiaARM.jl is an open-source Julia package for numerical association rule mining based on population-based nature-inspired optimization algorithms. It brings the capabilities of the original Python-based NiaARM framework [@stupan2022niaarm] to the Julia ecosystem, enabling researchers and data scientists working with datasets with mixed attribute types (consisting of categorical and numerical attributes) to discover numerical association rules. NiaARM.jl supports loading datasets, preprocessing, association rule mining, and extraction of discovered rules with associated interestingness metrics. In line with the rule mining part, this package also implements several well-known stochastic population-based nature-inspired algorithms, such as Differential Evolution (DE) [@storn1997differential], Artificial Bee Colony (ABC) [@karaboga2007powerful], Particle Swarm Optimization (PSO) [@kennedy1995particle], and several other metaphor-based nature-inspired algorithms to act as solvers for the numerical rule mining task. The entire numerical association rule mining workflow is further supported by visualization methods for numerical association rules, which is achieved through NarmViz.jl, a package well integrated with NiaARM.jl [@fister2024narmviz].

# Statement of need

TODO

# References
