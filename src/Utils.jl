struct Edge
    NodeA::Int64
    NodeB::Int64
    Weight::Float64
end

function prev(route::Vector{Int}, index::Int64)::Int
    return index == 1 ? last(route) : route[index-1]
end

function next(route::Vector{Int}, index::Int64)::Int
    return index == length(route) ? first(route) : route[index+1]
end

function nodeCost(route::Vector{Int}, index::Int64, weights::Matrix{Float64})::Float64
    return weights[prev(route, index), route[index]] + weights[route[index], next(route, index)]
end