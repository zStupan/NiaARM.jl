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
