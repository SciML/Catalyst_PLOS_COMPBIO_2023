### Preparations ###

import Pkg
Pkg.DEFAULT_IO[] = stdout;

using Catalyst, ModelingToolkit, OrdinaryDiffEq, DifferentialEquations

### Make Figure ###

rs = @reaction_network begin
    (kB,kD), 2A <--> B
end

@parameters kB kD
@variables t 
@species A(t) B(t)

reactions = [Reaction(kB, [A], [B], [2], [1]),
                    Reaction(kD, [B], [A], [1], [2])]
rs = @reaction_network begin
    (kB,kD), 2A <--> B
end

@parameters kB kD
@variables t 
@species A(t) B(t)

reactions = [Reaction(kB, [A], [B], [2], [1]),
                    Reaction(kD, [B], [A], [1], [2])]
@named rs  = ReactionSystem(reactions, t)

os = convert(ODESystem,rs)

os.eqs

u0 = [A => 1.0, B => 1.0]
p = [kD => 1.0, kB => 1.0]
tspan = (0.0,10.0)

oprob = ODEProblem(os,u0,tspan,p)
sol = solve(oprob);

ModelingToolkit.generate_function(os)

