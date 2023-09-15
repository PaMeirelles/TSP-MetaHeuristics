using TSPLIB

module ConstructiveSolution 
    using ..TSPLIB
    export basicGreedy  

    function basicGreedy(tsp::TSP, startingNode::Int)
        visitedNodes = [0 for _ in 1:tsp.dimension] 
        cost = 0.0  
        visitedNodes[startingNode] = 1
        visitedNodesCount = 1
        currentNode = startingNode
        solution = [startingNode]

        function compareByValue(pair1, pair2)  
            return pair1[2] < pair2[2]
        end

        while(visitedNodesCount < tsp.dimension)
            row = tsp.weights[currentNode, :]
            indexed = [(index, value) for (index, value) in enumerate(row) if visitedNodes[index] == 0]

            minIndex = argmin([pair[2] for pair in indexed])
            minElement = indexed[minIndex]
            
            currentNode = minElement[1]
            cost += minElement[2]

            visitedNodes[minElement[1]] = 1
            push!(solution, minElement[1])  
            visitedNodesCount += 1;
        end
        
        cost += tsp.weights[currentNode, startingNode]
        return (solution, cost)
    end
end
