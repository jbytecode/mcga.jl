module ByteWorks

function floattobytes(value::Float64)::Array{UInt8,1}
    return floatstobytes([value])
end

function floatstobytes(values::Array{Float64,1})::Array{UInt8,1}
    buf = IOBuffer()
    write(buf, values)
    bytes = take!(buf)
    return bytes
end

function bytestofloats(bytes::Array{UInt8,1})::Array{Float64,1}
    return reinterpret(Float64, bytes)
end

function validate(bytes::Array{UInt8,1})::Bool
    fvals = bytestofloats(bytes)
    all(map(x -> !isnan(x), fvals))
end

function checkandrestore(
    bytes::Array{UInt8, 1}, 
    lowerbound::Array{Float64, 1},
    upperbound::Array{Float64, 1})::Array{UInt8, 1}

    if validate(bytes)
        return bytes
    else
        return map( (L, U) -> L + rand() * (U - L), lowerbound, upperbound) |> floatstobytes
    end
end

end # end of module
