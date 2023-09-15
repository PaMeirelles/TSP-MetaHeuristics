using TSPLIB

module ConstructiveSolution 
    using ..TSPLIB
    export basicGreedy  

    function basicGreedy(tsp::TSP, startingNode::Int)
        remainingNodes = Set(1:tsp.dimension)::Set{Int}  
        cost = 0.0  
        delete!(remainingNodes, startingNode)
        currentNode = startingNode
        solution = [startingNode]

        function compareByValue(pair1, pair2)  
            return pair1[2] < pair2[2]
        end

        while(length(remainingNodes) > 0)
            row = tsp.weights[currentNode, :]
            indexed = [(index, value) for (index, value) in enumerate(row) if index in remainingNodes]

            minIndex = argmin([pair[2] for pair in indexed])
            minElement = indexed[minIndex]
            
            currentNode = minElement[1]
            cost += minElement[2]

            delete!(remainingNodes, minElement[1])
            push!(solution, minElement[1])  
        end
        
        cost += tsp.weights[currentNode, startingNode]
        return (solution, cost)
    end
end
