using IncompleteLU, LinearAlgebra

function get_cvode_pcs(τIn,model)
    osys = convert(ODESystem,model.rn)
    oprob = ODEProblem(osys,Float64[],(0.0,0.0),Float64[],sparse=true,jac=true)
    ofun =  ODEFunction(osys;sparse=true,jac=true);
    jaccache = ofun.jac(oprob.u0,oprob.p,0.0)
    W = I - 1.0*jaccache
    prectmp = ilu(W, τ = 50.0)
    preccache = Ref(prectmp)
    
    function psetupilu(p, t, u, du, jok, jcurPtr, gamma)
        if jok
            ofun.jac(jaccache,u,p,t)
            jcurPtr[] = true

            # W = I - gamma*J
            @. W = -gamma*jaccache
            idxs = diagind(W)
            @. @view(W[idxs]) = @view(W[idxs]) + 1

            # Build preconditioner on W
            preccache[] = ilu(W, τ = τIn)
        end
    end
  
    function precilu(z,r,p,t,y,fy,gamma,delta,lr)
        ldiv!(z,preccache[],r)
    end

    return (precilu,psetupilu)
end

function get_julia_pcs(τIn)
    function incompletelu(W,du,u,p,t,newW,Plprev,Prprev,solverdata)
        if newW === nothing || newW
            Pl = ilu(convert(AbstractMatrix,W), τ = τIn)
        else
            Pl = Plprev
        end
        Pl,nothing
    end
    return incompletelu
end
