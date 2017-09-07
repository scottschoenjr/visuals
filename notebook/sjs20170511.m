syms rhoTot rho0 rho c c0 cPrime

rhoTot = rho0 + rho;
c = c0 + cPrime;

ratio = ( rhoTot*c^(2) - rho0*c0^(2) )/(rho0*c0^(2));
simplify( expand( ratio ) )