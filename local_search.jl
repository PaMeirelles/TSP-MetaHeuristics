using TSPLIB

module LocalSearch
    export perform_swap
    function node_cost(solution, node, tsp)
        prev = max(1, node-1)
        next = min(length(solution), node+1)

        return tsp.weights[solution[prev], solution[node]] + tsp.weights[solution[node], solution[next]]
    end

    function perform_swap(solution, node_1, node_2, tsp)
        prev_cost = node_cost(solution, node_1, tsp) + node_cost(solution, node_2, tsp)

        solution[node_1], solution[node_2] = solution[node_2], solution[node_1]

        new_cost = node_cost(solution, node_1, tsp) + node_cost(solution, node_2, tsp)

        return new_cost - prev_cost
    end
end