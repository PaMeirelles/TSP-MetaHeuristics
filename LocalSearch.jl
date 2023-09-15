using TSPLIB

module LocalSearch
    using ..TSPLIB
    export first_improvement

    function node_cost(solution::Vector{Int}, node::Int, tsp::TSP)::Float64
        prev = max(1, node-1)
        next = min(length(solution), node+1)

        return tsp.weights[solution[prev], solution[node]] + tsp.weights[solution[node], solution[next]]
    end

    function perform_swap(solution::Vector{Int}, node_1::Int, node_2::Int, tsp::TSP)::Float64
        prev_cost = node_cost(solution, node_1, tsp) + node_cost(solution, node_2, tsp)

        solution[node_1], solution[node_2] = solution[node_2], solution[node_1]

        new_cost = node_cost(solution, node_1, tsp) + node_cost(solution, node_2, tsp)

        return new_cost - prev_cost
    end

    function first_improvement(solution::Vector{Int}, tsp::TSP, cost::Float64, verbose::Bool=false)::Tuple{Vector{Int}, Float64}
        for i in 1:length(solution)
            for j in i:length(solution)
                delta = perform_swap(solution, i, j, tsp)
                if (delta < 0)
                    if verbose
                        println("Score improved from $cost to $(cost+delta) by swapping $i and $j")
                    end
                    return first_improvement(solution, tsp, cost+delta, verbose)
                else
                    perform_swap(solution, j, i, tsp)
                end
            end
        end
        if verbose 
            println("Local minimum achieved")
        end
        return (solution, cost)
    end 
end
