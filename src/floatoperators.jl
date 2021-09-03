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


export nearbytemutation
export randombytemutation


end
