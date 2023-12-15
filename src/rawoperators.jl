module RawOperators

function nearbytemutation(bytes::Vector{UInt8}; mutateprob::Float64 = 0.10)::Vector{UInt8}
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
    bytes::Vector{UInt8};
    mutateprob::Float64 = 0.10,
)::Vector{UInt8}
    function singlebytemutate(byte::UInt8)::UInt8
        newbyte = byte
        if rand() < mutateprob
            newbyte = rand(filter(x -> x != byte, 0:255))
        end
        return newbyte
    end

    return map(singlebytemutate, bytes)
end


function onepointcrossover(fbytes::Vector{UInt8}, sbytes::Vector{UInt8})::Vector{UInt8}
    len = length(fbytes)
    @assert len == length(sbytes)
    @assert len > 1
    cutpoint = rand(2:(len-1))
    return vcat(fbytes[1:cutpoint], sbytes[(cutpoint+1):len])
end

function uniformcrossover(fbytes::Vector{UInt8}, sbytes::Vector{UInt8})::Vector{UInt8}
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


end # End of module

