mutable struct Chromosome
    genes::Array{Float64,1}
    cost::Float64
end

struct MCGA
    popsize::Int
    chsize::Int
    chromosomes::Array{Chromosome,1}
    mutationprobability::Float64
    crossoverprobability::Float64
    lowerbounds::Array{Float64,1}
    upperbounds::Array{Float64,1}
end
