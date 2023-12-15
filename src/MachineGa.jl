module MachineGa

struct Chromosome
    genes::Vector{Float64}
    cost::Float64
end

struct MCGA
    popsize::Int
    chsize::Int
    costfunction::Function
    mutationprobability::Float64
    crossoverprobability::Float64
    lowerbounds::Vector{Float64}
    upperbounds::Vector{Float64}
end

include("./byteworks.jl")
include("./rawoperators.jl")
include("./floatoperators.jl")
include("./gaoperators.jl")


# exports 
export MCGA
export Chromosome

export ByteWorks
export RawOperators
export FloatOperators
export GaOperators

end # module
