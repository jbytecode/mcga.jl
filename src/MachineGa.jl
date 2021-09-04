module MachineGa

struct Chromosome
    genes::Array{Float64,1}
    cost::Float64
end

struct MCGA
    popsize::Int
    chsize::Int
    costfunction::Function
    mutationprobability::Float64
    crossoverprobability::Float64
    lowerbounds::Array{Float64,1}
    upperbounds::Array{Float64,1}
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
