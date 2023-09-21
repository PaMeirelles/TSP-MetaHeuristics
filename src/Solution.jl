mutable struct Solution
    route::Vector{Int64}
    cost::Int64
end

function updateCost!(solution::Solution, weights::Matrix{Float64})
    solution.cost = 0
    currNode = solution.route[1]

    for i in 2:length(solution.route)
        node = solution.route[i]
        solution.cost += weights[currNode, node]
        currNode = node
    end
    solution.cost += weights[currNode, solution.route[1]]

end