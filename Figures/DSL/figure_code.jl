import Pkg
Pkg.DEFAULT_IO[] = stdout;

using Catalyst

erk_model = @reaction_network begin
    (k₁,k₋₁), M + MKK ↔ C_M_MKK
    k₂, C_M_MKK → Mp + MKK
    (k₃,k₋₃), Mp + MKK ↔ C_Mp_MKK
    k₄, C_Mp_MKK → Mpp + MKK
    (h₁,h₋₁), Mpp + MKP ↔ C_Mpp_MKP
    h₂, C_Mpp_MKP → Mp + MKP
    (h₃,h₋₃), Mp + MKP ↔ C_Mp_MKP
    h₄, C_Mp_MKP → M + MKP
end