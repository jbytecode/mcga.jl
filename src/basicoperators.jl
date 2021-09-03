function nearbytemutation(bytes::Array{UInt8, 1}; mutateprob::Float64 = 0.10)::Array{UInt8, 1}
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


function randombytemutation(bytes::Array{UInt8, 1}; mutateprob::Float64 = 0.10)::Array{UInt8, 1}
    function singlebytemutate(byte::UInt8)::UInt8
        if rand() < mutateprob
          byte = rand(0:255)  
        end
    end
       
    return map(singlebytemutate, bytes)
end

