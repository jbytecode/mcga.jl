module FloatOperators

import MachineGa.ByteWorks
import MachineGa.RawOperators

function nearbytemutation(
    values::Vector{Float64};
    mutateprob::Float64 = 0.10,
)::Vector{Float64}
    return RawOperators.nearbytemutation(
        ByteWorks.floatstobytes(values),
        mutateprob = mutateprob,
    ) |> ByteWorks.bytestofloats
end

function randombytemutation(
    values::Vector{Float64};
    mutateprob::Float64 = 0.10,
)::Vector{Float64}
    return RawOperators.randombytemutation(
        ByteWorks.floatstobytes(values),
        mutateprob = mutateprob,
    ) |> ByteWorks.bytestofloats
end

function onepointcrossover(
    fvals::Vector{Float64},
    svals::Vector{Float64},
)::Vector{Float64}
    return RawOperators.onepointcrossover(
        ByteWorks.floatstobytes(fvals),
        ByteWorks.floatstobytes(svals),
    ) |> ByteWorks.bytestofloats
end


function uniformcrossover(
    fvals::Vector{Float64},
    svals::Vector{Float64},
)::Vector{Float64}
    return RawOperators.uniformcrossover(
        ByteWorks.floatstobytes(fvals),
        ByteWorks.floatstobytes(svals),
    ) |> ByteWorks.bytestofloats
end

end # end of module
