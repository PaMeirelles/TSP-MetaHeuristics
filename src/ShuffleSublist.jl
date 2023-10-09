using Random

struct ShuffleSublist
    data::TSP
    solution::Solution
 end

 function keep_new(_::ShuffleSublist)::Bool
    return false;
 end

 function perform_operation!(shuffle_sublist::ShuffleSublist)
    size = length(shuffle_sublist.solution.route) + 1
    start_shuffle = rand(2:size-2)
    end_shuffle = rand(start_shuffle:size-1)
    shuffle!(view(shuffle_sublist.solution.route, start_shuffle:end_shuffle))
end
