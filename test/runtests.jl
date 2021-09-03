using Test

using MachineGa

@testset "Floats to bytes" begin
    @testset "Single float to bytes" begin
        bytes = [0x1f, 0x85, 0xeb, 0x51, 0xb8, 0x1e, 0x01, 0x40]
        result = floattobytes(2.14)
        @test bytes == result
    end

    @testset "Float array to bytes" begin
        bytes = [
            0x1f,
            0x85,
            0xeb,
            0x51,
            0xb8,
            0x1e,
            0x09,
            0x40,
            0xae,
            0x47,
            0xe1,
            0x7a,
            0x14,
            0xae,
            0x05,
            0x40,
        ]
        result = floatstobytes([3.14, 2.71])
        @test bytes == result
    end

    @testset "Length of bytes" begin
        arr = [1.0, 2.0, 3.0, 4.0]
        result = floatstobytes(arr)
        @test length(result) == length(arr) * sizeof(Float64) 
    end
end


@testset "Bytes to floats" begin
    @testset "Bytes to floats" begin
        bytes = [
            0x1f,
            0x85,
            0xeb,
            0x51,
            0xb8,
            0x1e,
            0x09,
            0x40,
            0xae,
            0x47,
            0xe1,
            0x7a,
            0x14,
            0xae,
            0x05,
            0x40,
        ]
        result = bytestofloats(bytes)
        @test result == [3.14, 2.71]
    end
end

@testset "Near byte mutation (inc or dec of bytes)" begin
    bytes = floatstobytes([3.14, 2.71])
    mutated = nearbytemutation(bytes, mutateprob = 1.0)
    difference = bytes .- mutated 
    # Since the mutation probability is 1.0
    # Vector of differences of original and mutated bytes
    # can not include zeros
    @test all(x -> x != 0, difference)
end

@testset "Random byte mutation (replace random byte)" begin
    bytes = floatstobytes([3.14, 2.71])
    mutated = randombytemutation(bytes, mutateprob = 1.0)
    difference = bytes .- mutated 
    # Since the mutation probability is 1.0
    # Vector of differences of original and mutated bytes
    # can not include zeros
    @test all(x -> x != 0, difference)
end