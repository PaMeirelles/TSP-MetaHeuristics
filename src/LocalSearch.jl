using TSPLIB

module LocalSearch
    using ..TSPLIB
    export firstImprovement

    function nodeCost(solution::Vector{Int}, node::Int, tsp::TSP)::Float64
        prev = max(1, node-1)
        next = min(length(solution), node+1)

        return tsp.weights[solution[prev], solution[node]] + tsp.weights[solution[node], solution[next]]
    end

    function performSwap(solution::Vector{Int}, node1::Int, node2::Int, tsp::TSP)::Float64
        prevCost = nodeCost(solution, node1, tsp) + nodeCost(solution, node2, tsp)

        solution[node1], solution[node2] = solution[node2], solution[node1]

        newCost = nodeCost(solution, node1, tsp) + nodeCost(solution, node2, tsp)

        return newCost - prevCost
    end

    function firstImprovement(solution::Vector{Int}, tsp::TSP, cost::Float64, verbose::Bool=false)::Tuple{Vector{Int}, Float64}
        for i in 1:length(solution)
            for j in i:length(solution)
                delta = performSwap(solution, i, j, tsp)
                if (delta < 0)
                    if verbose
                        println("Score improved from $cost to $(cost+delta) by swapping $i and $j")
                    end
                    return firstImprovement(solution, tsp, cost+delta, verbose)
                else
                    performSwap(solution, j, i, tsp)
                end
            end
        end
        if verbose 
            println("Local minimum achieved")
        end
        return (solution, cost)
    end 
end
