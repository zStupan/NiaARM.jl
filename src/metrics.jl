function support(t::ContingencyTable)
    n = t.countall + t.countlhs + t.countrhs + t.countnull
    res = t.countall / n
    return isfinite(res) ? res : 0.0
end

support(r::Rule) = support(r.ct)

function confidence(t::ContingencyTable)
    count_x = t.countall + t.countlhs
    res = t.countall / count_x
    return isfinite(res) ? res : 0.0
end

confidence(r::Rule) = confidence(r.ct)

function rhs_support(t::ContingencyTable)
    n = t.countall + t.countlhs + t.countrhs + t.countnull
    return (t.countall + t.countrhs) / n
end

rhs_support(r::Rule) = rhs_support(r.ct)

function coverage(t::ContingencyTable)
    n = t.countall + t.countlhs + t.countrhs + t.countnull
    return (t.countall + t.countlhs) / n
end

coverage(r::Rule) = coverage(r.ct)

function lift(t::ContingencyTable)
    return support(t) / (coverage(t) * rhs_support(t))
end

lift(r::Rule) = lift(r.ct)

function conviction(t::ContingencyTable)
    return (1.0 - rhs_support(t)) / (1.0 - confidence(t) + eps())
end

conviction(r::Rule) = conviction(r.ct)

function interestingness(t::ContingencyTable)
    n = t.countall + t.countlhs + t.countrhs + t.countnull
    supp = support(t)
    return confidence(t) * (supp / rhs_support(t)) * (1.0 - (supp / n))
end

interestingness(r::Rule) = interestingness(r.ct)

function yulesq(t::ContingencyTable)
    ad = countall(t) * countnull(t)
    bc = countrhs(t) * countlhs(t)
    q = (ad - bc) / (ad + bc + eps())
    return q
end

yulesq(r::Rule) = yulesq(r.ct)

function netconf(t::ContingencyTable)
    cov = coverage(t)
    num = support(t) - coverage(t) * rhs_support(t)
    den = cov * (1 - cov) + eps()
    return num / den
end

netconf(r::Rule) = netconf(r.ct)

function zhang(t::ContingencyTable)
    supportx = coverage(t)
    supporty = rhs_support(t)
    supp = support(t)

    numerator = supp - supportx * supporty
    denominator = max(supp * (1 - supportx), supportx * (supporty - supp)) + eps()
    return numerator / denominator
end

zhang(r::Rule) = zhang(r.ct)

function leverage(t::ContingencyTable)
    return support(t) - (coverage(t) * rhs_support(t))
end

leverage(r::Rule) = leverage(r.ct)

amplitude(t::ContingencyTable) = t.amplitude

amplitude(r::Rule) = amplitude(r.ct)

inclusion(t::ContingencyTable) = t.inclusion

inclusion(r::Rule) = inclusion(r.ct)

function comprehensibility(r::Rule)
    return log(1 + length(r.consequent)) / log(1 + length(r.antecedent) + length(r.consequent))
end
