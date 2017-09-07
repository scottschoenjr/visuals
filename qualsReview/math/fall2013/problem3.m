clear all
close all
clc

x = linspace(0, 1, 10000 );

g = -8.7 + sin( (x - 2)/5 ) - exp( 3 - x).*sin( (x - 3)./5 );

plot( x, g )
