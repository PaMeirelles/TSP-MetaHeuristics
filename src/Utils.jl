function nodeCost(route::Vector{Int}, index::Int64, weights::Matrix{Float64})::Float64
    size = length(route)
    value = route[index]

    prev = index == 1 ? route[size] : route[index - 1]
    next = index == size ? route[1] : route[index + 1]

    return weights[prev, value] + weights[value, next]

end