%**************************************************************************
%
% Spherical Harmonic Plotter
%
% Adaoted from spharmPlot.m by Mengliu Zhao, last updated 20141203
%
%**************************************************************************

clear all
close all
clc

% Define theta and phi vectors
nPoints = 1000;
phiVec = linspace( 0, 2.*pi, nPoints );
thetaVec = linspace( 0, pi, round( nPoints./2 ) ); % Elevation [rad]
[ phi, theta ] = meshgrid( phiVec, thetaVec );

% Define indices to work with
n = 0;
m = 0; % |m| <= n

% set figure background to white
figure()
% Legendre polynomials
Pn_array = legendre( n, cos(theta(:,1)) );
Pn = Pn_array( abs(m)+1, :)';
Pn = repmat(Pn, [1, size(theta, 1)]);

% normalization constant
normFactor = sqrt( ...
    ( (2*n+1)/(4.*pi) ) .* (factorial(n-abs(m))/factorial(n+abs(m)) ) ...
    );

% base spherical harmonic function
Ymn = normFactor*Pn*exp( 1i.*m.*phi );

% map to sphere surface
r = ones( size(Ymn) );
x = abs(r).*sin(theta).*cos(phi);
y = abs(r).*sin(theta).*sin(phi);
z = abs(r).*cos(theta);

% visualization
harmonicPlot = surf(x, y, z, double(real(Ymn)));

% adjust camera view
view(40,30)
camlight left
camlight right
lighting none
axis equal

axis([-1, 1, -1, 1, -1, 1])

% map positive regions to red, negative regions to green
colormap(parula)

% hide edges
set(harmonicPlot, 'LineStyle','none')

grid off

% Labels
xlabel( '$x$', 'FontSize', 24 );
ylabel( '$y$', 'FontSize', 24 );
zlabel( '$z$', 'FontSize', 24 );
title( ['$m = ', num2str(m), '$, $n = ', num2str(n), '$' ], ...
    'FontSize', 28);
