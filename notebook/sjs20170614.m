% Jeff's Woodworking

clear all;
close all;
clc

L = 1;
W = 0.5;
d = 0.1;

% Create angle vector
phi = linspace( pi./4, pi./2, 1000 );

% Define characteristic function
f = tan( phi ) - L./( W - d./sin( phi ) );

% Plot!
figure()
hold on;
plot( [phi(1), phi(end)], [0, 0], 'k', 'LineWidth', 1 );
plot( phi, f, 'k', 'LineWidth', 3 );
xlabel( '$\phi$ [rad]', 'FontSize', 26 );
ylabel( '$f(\phi)$', 'FontSize', 28 );
ylim( [-1, 1] );
box on;
xlim( [1, 1.3] );