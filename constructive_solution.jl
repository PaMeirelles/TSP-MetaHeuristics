using TSPLIB

module ConstructiveSolution 
    export basic_greedy
    function basic_greedy(tsp, starting_node)
        remaining_nodes = Set(1:tsp.dimension)
        cost = 0
        delete!(remaining_nodes, starting_node)
        current_node = starting_node
        solution = [starting_node]

        compare_by_value(pair1, pair2) = pair1[2] < pair2[2]

        while(length(remaining_nodes) > 0)
            row = tsp.weights[current_node, :]
            indexed = [(index, value) for (index, value) in enumerate(row) if index in remaining_nodes]

            min_index = argmin([pair[2] for pair in indexed])
            min_element = indexed[min_index]
            
            current_node = min_element[1]
            cost += min_element[2]

            delete!(remaining_nodes, min_element[1])
            push!(solution, min_element[1])  
        end
        
        cost += tsp.weights[current_node, starting_node]
        return (solution, cost)
    end
end