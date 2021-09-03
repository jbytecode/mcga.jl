using Test

using MachineGa

@testset "Floats to bytes" begin
    @testset "Single float to bytes" begin
        bytes = [0x1f, 0x85, 0xeb, 0x51, 0xb8, 0x1e, 0x01, 0x40]
        result = ByteWorks.floattobytes(2.14)
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
        result = ByteWorks.floatstobytes([3.14, 2.71])
        @test bytes == result
    end

    @testset "Length of bytes" begin
        arr = [1.0, 2.0, 3.0, 4.0]
        result = ByteWorks.floatstobytes(arr)
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
        result = ByteWorks.bytestofloats(bytes)
        @test result == [3.14, 2.71]
    end
end

@testset "Near byte mutation" begin
    bytes = ByteWorks.floatstobytes([3.14, 2.71])
    mutated = RawOperators.nearbytemutation(bytes, mutateprob = 1.0)
    difference = bytes .- mutated
    # Since the mutation probability is 1.0
    # Vector of differences of original and mutated bytes
    # can not include zeros
    @test all(x -> x != 0, difference)
end

@testset "Random byte mutation" begin
    bytes = ByteWorks.floatstobytes([3.14, 2.71])
    mutated = RawOperators.randombytemutation(bytes, mutateprob = 1.0)
    difference = bytes .- mutated
    # Since the mutation probability is 1.0
    # Vector of differences of original and mutated bytes
    # can not include zeros
    @test all(x -> x != 0, difference)
end

@testset "Crossover on bytes" begin
    @testset "One-point crossover on bytes -> x(C, C) = C" begin
        bytes1 = [0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0x10]
        child = RawOperators.onepointcrossover(bytes1, bytes1)
        @test child == bytes1
    end

    @testset "One-point crossover on bytes -> x(C, D)" begin
        bytes1 = [0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0x0a]
        bytes2 = [0x0a, 0x09, 0x08, 0x7, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1]
        child = RawOperators.onepointcrossover(bytes1, bytes2)
        @test map((par1, par2, x) -> x in [par1, par2], bytes1, bytes2, child) |> all
    end

    @testset "Uniform crossover on bytes" begin
        bytes1 = [0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0x0a]
        bytes2 = [0x0a, 0x09, 0x08, 0x7, 0x6, 0x5, 0x4, 0x3, 0x2, 0x1]
        child = RawOperators.uniformcrossover(bytes1, bytes2)
        @test map((par1, par2, x) -> x in [par1, par2], bytes1, bytes2, child) |> all
    end
end


@testset "Mutation on bytes of floats" begin

    @testset "Near byte mutation" begin

        floats_original = [3.14, 2.71, 5.0]
        bytes_original = ByteWorks.floatstobytes(floats_original)

        floats_mutated = FloatOperators.nearbytemutation(floats_original, mutateprob = 1.0)
        bytes_mutated = ByteWorks.floatstobytes(floats_mutated)

        differences = bytes_original .- bytes_mutated .|> abs

        @test all(x -> x != 0, differences)
    end


    @testset "Random byte mutation" begin

        floats_original = [3.14, 2.71, 5.0]
        bytes_original = ByteWorks.floatstobytes(floats_original)

        floats_mutated =
            FloatOperators.randombytemutation(floats_original, mutateprob = 1.0)
        bytes_mutated = ByteWorks.floatstobytes(floats_mutated)

        differences = bytes_original .- bytes_mutated .|> abs

        @test all(x -> x != 0, differences)
    end
end


