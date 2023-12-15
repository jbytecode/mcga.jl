module ByteWorks

function floattobytes(value::Float64)::Vector{UInt8}
    return reinterpret(UInt8, [value])
end

function floatstobytes(values::Vector{Float64})::Vector{UInt8}
    return mapreduce(x -> floattobytes(x), vcat, values)
end

function bytestofloats(bytes::Vector{UInt8})::Vector{Float64}
    return reinterpret(Float64, bytes)
end

function isvalid(bytes::Vector{UInt8})::Bool
    fvals = bytestofloats(bytes)
    all(map(x -> !isnan(x), fvals))
end

function checkandrestore(
    bytes::Vector{UInt8}, 
    lowerbound::Vector{Float64},
    upperbound::Vector{Float64})::Vector{UInt8}

    if isvalid(bytes)
        return bytes
    else
        return map( (L, U) -> L + rand() * (U - L), lowerbound, upperbound) |> floatstobytes
    end
end

end # end of module
