% Problem 1

clear all
close all
clc

x = linspace( -1, 1, 500 );
t = linspace( 0, 1, 100 );

[x, t] = meshgrid( x, t );

phi = exp( -x./sqrt(t) );
pcolor( x, t, phi );
shading flat;
xlabel( '$x$' );
ylabel( '$t$' );