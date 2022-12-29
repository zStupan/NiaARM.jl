struct Problem
    dimension::Int64
    lowerbound::Float64
    upperbound::Float64
    lowerinit::Float64
    upperinit::Float64

    function Problem(dimension::Int64, lowerbound::Float64, upperbound::Float64, lowerinit::Float64, upperinit::Float64)
        if dimension <= 0
            error("dimension <= 0")
        end

        if lowerbound >= upperbound
            error("lowerbound >= upperbound")
        end

        if lowerinit >= upperinit
            error("lowerinit >= upperinit")
        end

        new(dimension, lowerbound, upperbound, lowerinit, upperinit)
    end

    Problem(dimension::Int64, lowerbound::Float64, upperbound::Float64) = Problem(dimension, lowerbound, upperbound, lowerbound, upperbound)
end
