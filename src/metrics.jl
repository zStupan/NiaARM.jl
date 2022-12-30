struct ContingencyTable
    count_all::Int64
    count_lhs::Int64
    count_rhs::Int64
    count_null::Int64
end

function ContingencyTable(antecedent::Vector{Any}, consequent::Vector{Any}, transactions::DataFrame)
    num_transactions = nrow(transactions)
    contains_antecedent = trues(num_transactions)
    contains_consequent = trues(num_transactions)

    for attribute in antecedent
        if attribute.dtype != "Cat"
            contains_antecedent .&= transactions[:, attribute.name] .>= attribute.min
            contains_antecedent .&= transactions[:, attribute.name] .<= attribute.max
        else
            contains_antecedent .&= transactions[:, attribute.name] .== attribute.category
        end
    end

    for attribute in consequent
        if attribute.dtype != "Cat"
            contains_consequent .&= transactions[:, attribute.name] .>= attribute.min
            contains_consequent .&= transactions[:, attribute.name] .<= attribute.max
        else
            contains_consequent .&= transactions[:, attribute.name] .== attribute.category
        end
    end

    count_all = sum(contains_antecedent .& contains_consequent)
    count_lhs = sum(contains_antecedent .& .!contains_consequent)
    count_rhs = sum(.!contains_antecedent .& contains_consequent)
    count_null = sum(.!contains_antecedent .& .!contains_consequent)

    return ContingencyTable(count_all, count_lhs, count_rhs, count_null)
end

ContingencyTable(rule::Rule, transactions::DataFrame) = ContingencyTable(rule.antecedent, rule.consequent, transactions)

function support(t::ContingencyTable)
    n = t.count_all + t.count_lhs + t.count_rhs + t.count_null
    res = t.count_all / n
    return isfinite(res) ? res : 0.0
end

function confidence(t::ContingencyTable)
    count_x = t.count_all + t.count_lhs
    res = t.count_all / count_x
    return isfinite(res) ? res : 0.0
end
