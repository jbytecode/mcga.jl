using Test

using MachineGa

@testset "Validation of byte arrays" begin
    @testset "NaN value" begin
        # 0x255, 0x255, ..., 0x255
        bytes = map(x -> UInt8(255), 1:8)
        @test !ByteWorks.validate(bytes)
    end

    @testset "NaN multiple values" begin
        # 0x255, 0x255, ..., 0x255
        bytes = map(x -> UInt8(255), 1:32)
        @test !ByteWorks.validate(bytes)
    end

    @testset "Valid value" begin
        bytes = ByteWorks.floattobytes(3.14159265)
        @test ByteWorks.validate(bytes)
    end

    @testset "Multiple valid values" begin
        bytes = ByteWorks.floatstobytes([3.14159265, 2.71828, 1234.5])
        @test ByteWorks.validate(bytes)
    end
end


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


@testset "Byte crossover on floats" begin
    @testset "One-point crossover" begin
        floats = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
        floatsnew = FloatOperators.onepointcrossover(floats, floats)
        difference = floats .- floatsnew .|> abs
        @test all(x -> x == 0, difference)
    end

    @testset "Uniform crossover" begin
        floats = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
        floatsnew = FloatOperators.uniformcrossover(floats, floats)
        difference = floats .- floatsnew .|> abs
        @test all(x -> x == 0, difference)
    end

    @testset "Uniform crossover enhanced" begin
        floats1 = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
        floats2 = floats1 * -1.0

        floatsnew = FloatOperators.uniformcrossover(floats1, floats2)
        eitherfirstorsecond =
            map((x, a, b) -> x == a || x == b, floatsnew, floats1, floats2)
        @test all(eitherfirstorsecond)
    end
end


@testset "Genetic algorithm operators - Crossover" begin
    @testset "One-point crossover" begin
        c1 = Chromosome([1.0, 2.0], 0.0)
        c2 = Chromosome([2.0, 3.0], -1.0)
        cnew = GaOperators.onepointcrossover(c1, c2)
        @test cnew isa Chromosome
        @test isinf(cnew.cost)
        @test length(cnew.genes) == length(c1.genes)
    end

    @testset "Uniform-point crossover" begin
        c1 = Chromosome([1.0, 2.0], 0.0)
        c2 = Chromosome([2.0, 3.0], -1.0)
        cnew = GaOperators.uniformcrossover(c1, c2)
        @test cnew isa Chromosome
        @test isinf(cnew.cost)
        @test length(cnew.genes) == length(c1.genes)
    end

    @testset "Uniform-point crossover enhanced" begin
        c1 = Chromosome([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0], 0.0)
        c2 = Chromosome(c1.genes * -1, 100.0)
        cnew = GaOperators.uniformcrossover(c1, c2)
        @test cnew isa Chromosome
        @test isinf(cnew.cost)
        @test length(cnew.genes) == length(c1.genes)
        @test all(map((x, a, b) -> x == a || x == b, cnew.genes, c1.genes, c2.genes))
    end

end

@testset "Genetic algorithm operators - Mutation" begin
    @testset "Random mutation" begin
        c = Chromosome([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0], 0.0)
        cnew = GaOperators.randombytemutation(c, mutateprob = 1.0)
        @test cnew isa Chromosome
        @test isinf(cnew.cost)
        @test length(c.genes) == length(cnew.genes)
    end

    @testset "Inc Dec mutation" begin
        c = Chromosome([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0], 0.0)
        cnew = GaOperators.nearbytemutation(c, mutateprob = 1.0)
        @test cnew isa Chromosome
        @test isinf(cnew.cost)
        @test length(c.genes) == length(cnew.genes)
    end
end

@testset "Genetic algorithm operators - Tournament selection" begin
    @testset "The worst can be selected" begin
        cs = [
            Chromosome([], 10),
            Chromosome([], 20),
            Chromosome([], 30),
            Chromosome([], 40),
            Chromosome([], 50),
        ]
        c = GaOperators.tournamentselection(cs, tournaments = 2)
        @test c isa Chromosome
        @test c.cost in [10, 20, 30, 40, 50]
        @test length(c.genes) == 0
    end

    @testset "The worst should not be selected" begin
        cs = [
            Chromosome([], 10),
            Chromosome([], 20),
            Chromosome([], 30),
            Chromosome([], 40),
            Chromosome([], 50),
        ]
        c = GaOperators.tournamentselection(cs, tournaments = 1000)
        @test c isa Chromosome
        @test c.cost in [10, 20, 30, 40]
        @test length(c.genes) == 0
    end
end
