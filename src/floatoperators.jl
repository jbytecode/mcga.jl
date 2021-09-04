module FloatOperators

import MachineGa.ByteWorks
import MachineGa.RawOperators

function nearbytemutation(
    values::Array{Float64,1};
    mutateprob::Float64 = 0.10,
)::Array{Float64,1}
    return RawOperators.nearbytemutation(
        ByteWorks.floatstobytes(values),
        mutateprob = mutateprob,
    ) |> ByteWorks.bytestofloats
end

function randombytemutation(
    values::Array{Float64,1};
    mutateprob::Float64 = 0.10,
)::Array{Float64,1}
    return RawOperators.randombytemutation(
        ByteWorks.floatstobytes(values),
        mutateprob = mutateprob,
    ) |> ByteWorks.bytestofloats
end

function onepointcrossover(
    fvals::Array{Float64,1},
    svals::Array{Float64,1},
)::Array{Float64,1}
    return RawOperators.onepointcrossover(
        ByteWorks.floatstobytes(fvals),
        ByteWorks.floatstobytes(svals),
    ) |> ByteWorks.bytestofloats
end


function uniformcrossover(
    fvals::Array{Float64,1},
    svals::Array{Float64,1},
)::Array{Float64,1}
    return RawOperators.uniformcrossover(
        ByteWorks.floatstobytes(fvals),
        ByteWorks.floatstobytes(svals),
    ) |> ByteWorks.bytestofloats
end

end # end of module
