### Preparations ###

import Pkg
Pkg.DEFAULT_IO[] = stdout;

using Catalyst, Plots

default(xguide="",yguide="",xticks=[],yticks=[],grid=false,legend=:none,framestyle=:box)

# Declare the model (a brusselator).
brusselator = @reaction_network begin
    A, 0 --> X
    1, 2X + Y --> 3X
    B, X --> Y
    1, X --> 0
end


### RRE Simulation ###

using OrdinaryDiffEq
u0 = [:X => 0., :Y => 0.]
tspan = (0., 60.)
p = [:A => 1.0, :B => 4.0]
oprob = ODEProblem(brusselator,u0,tspan,p)
osol = solve(oprob,Rosenbrock23());

oplot = plot(osol,lw=13,la=0.8,ylimit=(0.,20.),xguide="")
savefig(oplot, "oplot.svg")

### CLE Simulation ###

using StochasticDiffEq
u0 = [:X => 0., :Y => 5.]
tspan = (0., 60.)
p = [:A => 1.0, :B => 4.0]
sprob = SDEProblem(brusselator,u0,tspan,p)
ssol = solve(sprob,ImplicitEM(),adaptive=false,dt=0.0001,saveat=0.01);

splot = plot(ssol,lw=4,la=0.8,ylimit=(0.,20.),xguide="")
savefig(splot, "splot.svg")


### SSA Simulation ###

using JumpProcesses
u0 = [:X => 0, :Y => 0]
tspan = (0., 60.)
p = [:A => 3.0, :B => 4.0]
dprob = DiscreteProblem(brusselator,u0,tspan,p)
jprob = JumpProblem(brusselator,dprob,Direct())
jsol = solve(jprob,SSAStepper());

jplot = plot(jsol,lw=5,la=0.8,ylimit=(0.,20.),xguide="")
savefig(jplot, "jplot.svg")