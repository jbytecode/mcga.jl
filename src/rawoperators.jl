module RawOperators

function nearbytemutation(bytes::Array{UInt8,1}; mutateprob::Float64 = 0.10)::Array{UInt8,1}
    function singlebytemutate(byte::UInt8)::UInt8
        if rand() < mutateprob
            if rand() < 0.5
                byte += 1
                if byte > 255
                    byte = 0
                end
            else
                byte -= 1
                if byte < 0
                    byte = 255
                end
            end
        end
        return byte
    end

    return map(singlebytemutate, bytes)
end


function randombytemutation(
    bytes::Array{UInt8,1};
    mutateprob::Float64 = 0.10,
)::Array{UInt8,1}
    function singlebytemutate(byte::UInt8)::UInt8
        if rand() < mutateprob
            byte = rand(0:255)
        end
    end

    return map(singlebytemutate, bytes)
end


function onepointcrossover(fbytes::Array{UInt8,1}, sbytes::Array{UInt8,1})::Array{UInt8,1}
    len = length(fbytes)
    @assert len == length(sbytes)
    @assert len > 1
    cutpoint = rand(2:(len-1))
    return vcat(fbytes[1:cutpoint], sbytes[(cutpoint+1):len])
end

function uniformcrossover(fbytes::Array{UInt8,1}, sbytes::Array{UInt8,1})::Array{UInt8,1}
    len = length(fbytes)
    @assert len == length(sbytes)
    @assert len > 1

    function selector(b1::UInt8, b2::UInt8)::UInt8
        if rand() < 0.5
            return b1
        else
            return b2
        end
    end
    return map(selector, fbytes, sbytes)
end



export nearbytemutation
export randombytemutation
export onepointcrossover
export uniformcrossover

end # End of module

