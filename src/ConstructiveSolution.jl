using Random

function basicGreedy(tsp::TSP)::Solution
    visitedNodes::Vector{Int} = [0 for _ in 1:tsp.dimension]
    cost = 0.0  
    startingNode = 1
    visitedNodes[startingNode] = 1
    visitedNodesCount = 1
    currentNode = startingNode
    route::Vector{Int} = [startingNode]

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
        push!(route, minElement[1])  
        visitedNodesCount += 1;
    end
    
    cost += tsp.weights[currentNode, startingNode]
    return Solution(route, cost)
end

function randomPath(tsp::TSP)::Solution
    route::Vector{Int} = shuffle([i for i in 1:tsp.dimension])
    route = [route]
    sol = Solution(route, 0)
    updateCost!(sol, tsp.weights)
    return sol
end

function cheapestInsertion(tsp::TSP)::Solution
    edges::Vector{Edge} = [Edge(i, j, tsp.weights[i,j]) for i in 1:tsp.dimension for j in i+1:tsp.dimension]
    sort!(edges, by= e -> e.Weight)

    degrees::Vector{Int64} = [0 for _ in 1:tsp.dimension]
    
    solution::Vector{Vector{Int64}} = [[] for _ in 1:tsp.dimension]
    cost = 0

    ccTracker::UnionFinder = UnionFinder(tsp.dimension)

    for edge in edges
        if degrees[edge.NodeA] >= 2 || degrees[edge.NodeB] >= 2
            continue
        end

        if find!(ccTracker, edge.NodeA) == find!(ccTracker, edge.NodeB)
            continue
        else
            union!(ccTracker, edge.NodeA, edge.NodeB)
        end
        push!(solution[edge.NodeA], edge.NodeB)
        push!(solution[edge.NodeB], edge.NodeA)

        degrees[edge.NodeA] += 1
        degrees[edge.NodeB] += 1
    end

    route::Vector{Int64} = [[x for x in 1:tsp.dimension if degrees[x] == 1][1]]
    for _ in 2:tsp.dimension
        currNode = last(route)
        next = [x for x in solution[currNode] if x != currNode][1]
        
        cost += tsp.weights[currNode, next]
        push!(route, next)
    end
    cost += tsp.weights[first(route), last(route)]
    return Solution(route, cost)
end