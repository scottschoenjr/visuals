clear all
close all
clc

% Define the position from the end of the tube
l = 1;
d = linspace( 0, l, 1000 );

% Define tube properties
U0 = 1; % Piston velocity amplitude
rho0 = 1.24;
c0 = 343;
Z0 = rho0.*c0;
Zn = 5.*Z0; % Termination impedance
Zn = 1E10; % Termination impedance

% Define useful quantities
R = (Zn - Z0)./(Zn + Z0); % Reflection Coefficient
P0 = Z0.*U0; % Piston pressure amplitude
lambda = l./1.00;
k = 2.*pi./lambda;

% Define the pressure and particle velocity along the tube
p = Z0.*U0.*( exp(1i.*k.*d) + R.*exp( -1i.*k.*d) )./ ...
    ( exp(1i.*k.*l) - R.*exp( -1i.*k.*l) );
u = U0.*( exp(1i.*k.*d) - R.*exp( -1i.*k.*d) )./ ...
    ( exp(1i.*k.*l) - R.*exp( -1i.*k.*l) );

% Plot!
figure()
hold all;
plot( l - d, abs( u./U0 ), 'k' );
plot( l - d, abs( p./P0 ), '--k' );
xlim( [0, 1] );
% ylim( [0, 2] );