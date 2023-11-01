mutable struct StageDisturb
    data::TSP
    solution::Solution
    neighbourSearch::Vector{Any}
    currentIteration::Int
    stageThresholds::Vector{Int}
    disturbFunctions::Vector{Function}
    gap::Int
 end

 function iteratedLocalSearch(stageDisturb::StageDisturb)
    logfile = open("log.txt", "a")

    sol = stageDisturb.solution
    
    @info "Initial solution" sol

    bestSol = deepcopy(stageDisturb.solution)
    maxIter = stageDisturb.stageThresholds[end]
    disturb = ShuffleSublist(instance, sol, stageDisturb.gap)

    while stageDisturb.currentIteration < maxIter
        logAndPrint(logfile, @sprintf("Iteration %d", sd.currentIteration))

        room_to_improve = true
        while room_to_improve
            room_to_improve = false
            shuffle!(stageDisturb.neighbourSearch)
            for ns in stageDisturb.neighbourSearch
                if bestImprovement!(ns)
                    room_to_improve = true
                    updateCost!(ns.solution, ns.data.weights)
                    break
                else 
                    updateCost!(ns.solution, ns.data.weights)
                end
            end
        end

        currSol = stageDisturb.neighbourSearch[1].solution

        if currSol.cost < bestSol.cost 
            @info "Best Improvement solution" currSol.route currSol.cost
            logAndPrint(logfile, @sprintf("New best: %d", currSol.cost))
            if (abs(currSol.cost - instance.optimal) < 1e-5)
                @info "Solution is optimal"
                break
            else
                @warn "Solution is not optimal"
            end
            bestSol = deepcopy(currSol)
            stageDisturb.currentIteration = 0
        end

        sol = deepcopy(bestSol)

        disturb.solution = sol

        for i in 1:(length(stageDisturb.stageThresholds)) 
            if stageDisturb.currentIteration < stageDisturb.stageThresholds[i]
                stageDisturb.disturbFunctions[i](disturb)
                break
            end
        end
        updateCost!(sol, instance.weights)
        
        for ns in stageDisturb.neighbourSearch
            ns.solution = deepcopy(sol)
        end

        stageDisturb.currentIteration += 1
    end

end

