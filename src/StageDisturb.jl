struct StageDisturb
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
        logAndPrint(logfile, @sprintf("Iteration %d", it))        
        shuffle!(stageDisturb.neighbourSearch)
        for ns in stageDisturb.neighbourSearch
            if ns()
                updateCost!(ns.solution, ns.data.weights)
                break
            else 
                updateCost!(ns.solution, ns.data.weights)
            end
        end
 
        if ns.solution.cost < bestSol.cost 
            @info "Best Improvement solution" ns.solution.route ns.solution.cost
            logAndPrint(logfile, @sprintf("New best: %d", ns.solution.cost))
            if (abs(ns.solution.cost - instance.optimal) < 1e-5)
                @info "Solution is optimal"
                break
            else
                @warn "Solution is not optimal"
            end
            bestSol = deepcopy(ns.solution)
            stageDisturb.currentIteration = 0
        end

        sol = deepcopy(bestSol)

        disturb.solution = sol

        for i in 1..(stageDisturb.stageThresholds.length) 
            if stageDisturb.currentIteration < stageDisturb.stageThresholds[i]
                stageDisturb.disturbFunctions[i](disturb)
                break
            end
        end
        updateCost!(sol, instance.weights)
        
        for ns in stageDisturb.neighbourSearch
            ns.solution = sol
        end

        stageDisturb.currentIteration += 1
    end

end

