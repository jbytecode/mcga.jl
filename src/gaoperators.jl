module GaOperators

import MachineGa.Chromosome
import MachineGa.FloatOperators

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
    bestindex = sortperm(cs, by = x -> x.cost) |> first
    best = cs[bestindex]
    return Chromosome(best.genes, best.cost)
end


end # module
