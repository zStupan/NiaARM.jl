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

# Optional fields if submitting to a AAS journal too, see this blog post:
# https://blog.joss.theoj.org/2018/12/a-new-collaboration-with-aas-publishing
aas-doi: 10.3847/xxxxx <- update this with the DOI from AAS once you know it.
aas-journal: Astrophysical Journal <- The name of the AAS journal.
---

# Summary

Association Rule Mining (ARM) is a fundamental data mining method for discovering interesting relationships between attributes in large datasets [@agrawal1993mining]. After its introduction by Agrawal et al., ARM gained prominence through applications such as market basket analysis and has since been applied in domains ranging from retail to health informatics [@altaf2017applications]. The classic ARM setting assumes a transactional database, where each transaction contains a subset of items, and rules of the form $X \Rightarrow Y$ (with $X \cap Y = \emptyset$) capture co‑occurrence patterns between itemsets [@kaushik2023numerical]. Traditional algorithms such as Apriori, ECLAT, and FP‑Growth were designed primarily for boolean or categorical attributes [@agrawal1993mining; @zaki2002scalable; @han2000mining]. Numerical Association Rule Mining (NARM) generalizes ARM to mixed‑type data by representing numerical attributes as value intervals and categorical attributes as discrete labels [@srikant1996mining; @kaushik2023numerical], while rule quality is typically evaluated using support and confidence.

NiaARM.jl is a Julia framework, inspired by the original NiaARM Python package [@Stupan2022], for mining numerical association rules via nature‑inspired optimization.

TODO

# Statement of need

TODO

# References
