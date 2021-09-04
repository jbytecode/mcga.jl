module GaOperators

import MachineGa.Chromosome
import MachineGa.FloatOperators
import MachineGa.MCGA

function onepointcrossover(c1::Chromosome, c2::Chromosome)::Chromosome
    Chromosome(FloatOperators.onepointcrossover(c1.genes, c2.genes), Inf64)
end

function uniformcrossover(c1::Chromosome, c2::Chromosome)::Chromosome
    Chromosome(FloatOperators.uniformcrossover(c1.genes, c2.genes), Inf64)
end

function randombytemutation(c::Chromosome; mutateprob::Float64 = 0.10)::Chromosome
    Chromosome(FloatOperators.randombytemutation(c.genes, mutateprob = mutateprob), Inf64)
end

function nearbytemutation(c::Chromosome; mutateprob::Float64 = 0.10)::Chromosome
    Chromosome(FloatOperators.nearbytemutation(c.genes, mutateprob = mutateprob), Inf64)
end

function tournamentselection(cs::Array{Chromosome,1}; tournaments::Int = 2)::Chromosome
    csample = rand(cs, tournaments)
    bestindex = sortperm(csample, by = x -> x.cost) |> first
    best = cs[bestindex]
    return Chromosome(best.genes, best.cost)
end

function generation(mcga::MCGA, chs::Array{Chromosome, 1})::Array{Chromosome, 1}
    # Calculate fitness
    chs = map(x -> Chromosome(x.genes, mcga.cost(x.genes)), chs)

    newpop = Array{Chromosome, 1}(undef, mcga.popsize)
    for i in 1:mcga.popsize
        ch1 = tournamentselection(chs)
        ch2 = tournamentselection(chs)
        off = uniformcrossover(ch1, ch2)
        offmutated = nearbytemutation(off)
        newpop[i] = offmutated
    end
    newpop = map(x -> Chromosome(x.genes, mcga.cost(x.genes)), newpop)

    wholepop = vcat(chs, newpop)
    wholepop = sort(wholepop, by = x -> x.cost)
    return wholepop[1:mcga.popsize]
end

end # module
