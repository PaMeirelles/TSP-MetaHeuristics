using Random

function basicGreedy(tsp::TSP)::Tuple{Vector{Int}, Int64}
    visitedNodes::Vector{Int} = [0 for _ in 1:tsp.dimension]
    cost = 0.0  
    startingNode = 1
    visitedNodes[startingNode] = 1
    visitedNodesCount = 1
    currentNode = startingNode
    solution::Vector{Int} = [startingNode]

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

function randomPath(tsp::TSP)::Solution
    route::Vector{Int} = shuffle([i for i in 1:tsp.dimension])
    route = [route ; route[1]]
    sol = Solution(route, 0)
    updateCost!(sol, tsp.weights)
    return sol
end