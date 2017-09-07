clear all
close all
clc

c0 = 1500;
cPrimeVec = linspace( -150, 150, 500 );
rho0 = 1000;
rhoPrimeVec = linspace( -100, 100, 500 );

[rhoPrime, cPrime] = meshgrid( rhoPrimeVec, cPrimeVec );

A = 1./(1 + rhoPrime./rho0 );
B = 1./(1 + cPrime./c0 );

factor = abs( A.*B.^(2) - 1 );
factor( factor > 0.1 ) = NaN;

pcolor( rhoPrime./rho0, cPrime./c0, factor );
xlabel( '$\rho''/\rho_{0}$', 'FontSize', 24 );
ylabel( '$c''/c_{0}$', 'FontSize', 24 );
shading flat;