# API Reference

```@meta
CurrentModule = NiaARM
```

## Data and features

```@docs
Dataset
AbstractFeature
NumericalFeature
CategoricalFeature
dtype
isnumerical
iscategorical
```

## Attributes and rules

```@docs
AbstractAttribute
NumericalAttribute
CategoricalAttribute
ContingencyTable
Rule
countall
countlhs
countrhs
countnull
```

## Metrics

```@docs
support
confidence
coverage
rhs_support
lift
conviction
interestingness
yulesq
netconf
zhang
leverage
amplitude
inclusion
comprehensibility
```

## Mining pipeline

```@docs
mine
narm
```

## Optimization setup

```@docs
Problem
StoppingCriterion
terminate
```

## Algorithms

```@docs
randomsearch
pso
de
ba
sa
ga
lshade
es
abc
cs
fa
fpa
```

## Utilities

```@docs
randchoice
randlevy
initpopulation
```
