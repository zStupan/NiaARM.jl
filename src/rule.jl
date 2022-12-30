import Base: show, ==

struct ContingencyTable
    countall::Int64
    countlhs::Int64
    countrhs::Int64
    countnull::Int64

    ContingencyTable() = new(0, 0, 0, 0)

    function ContingencyTable(antecedent::Vector{Attribute}, consequent::Vector{Attribute}, transactions::DataFrame)
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

        countall = sum(contains_antecedent .& contains_consequent)
        countlhs = sum(contains_antecedent .& .!contains_consequent)
        countrhs = sum(.!contains_antecedent .& contains_consequent)
        countnull = sum(.!contains_antecedent .& .!contains_consequent)

        return new(countall, countlhs, countrhs, countnull)
    end
end

countall(ct::ContingencyTable) = ct.countall

countlhs(ct::ContingencyTable) = ct.countlhs

countrhs(ct::ContingencyTable) = ct.countrhs

countnull(ct::ContingencyTable) = ct.countnull

struct Rule
    antecedent::Vector{Attribute}
    consequent::Vector{Attribute}
    fitness::Float64
    ct::ContingencyTable

    Rule(antecedent::Vector{Attribute}, consequent::Vector{Attribute}, fitness::Float64, ct::ContingencyTable) = new(antecedent, consequent, fitness, ct)

    Rule(antecedent::Vector{Attribute}, consequent::Vector{Attribute}) = new(antecedent, consequent, -Inf, ContingencyTable())

    Rule(antecedent::Vector{Attribute}, consequent::Vector{Attribute}, transactions::DataFrame) = new(antecedent, consequent, -Inf, ContingencyTable(antecedent, consequent, transactions))

    Rule(rule::Rule, transactions::DataFrame) = new(rule.antecedent, rule.consequent, rule.fitness, ContingencyTable(rule.antecedent, rule.consequent, transactions))
end

countall(r::Rule) = countall(r.ct)

countlhs(r::Rule) = countlhs(r.ct)

countrhs(r::Rule) = countrhs(r.ct)

countnull(r::Rule) = countnull(r.ct)

function show(io::IO, rule::Rule)
    print(io, "[$(join(rule.antecedent, ", "))] => [$(join(rule.consequent, ", "))]")
end

function ==(lhs::Rule, rhs::Rule)
    return lhs.antecedent == rhs.antecedent && lhs.consequent == rhs.consequent
end
