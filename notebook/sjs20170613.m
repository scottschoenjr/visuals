clear all
close all
clc

% Phase delay graphic

factor1 = 1.05;
factor2 = 0.95;
tMax = 1;

nPoints = 1024;
t = linspace( 0, tMax, nPoints );
t1 = linspace( 0, factor1, nPoints );
t2 = linspace( 0, factor2, nPoints );
omega = 3.*pi;

% Create signal
s = sin( omega.*t );
s1 = sin( factor1.*omega.*t1 );
s2 = sin( factor2.*omega.*t2 );

% Plot
figure()
hold on;
plot( t, s, 'k' );
plot( t, s1, '--k' );
plot( t, s2, ':k' );
xlim( [0, 0.75 ] )

axis off

% Computation time for number of layers
numLayers1 = [1, 1, 1, 1, 1];
timeLayers1 = [0.37, 0.37, 0.38, 0.30, 0.27];
mean1 = mean( timeLayers1 );

numLayers5 = 5.*[1, 1, 1, 1, 1];
timeLayers5 = [0.61, 0.61, 0.62, 0.49, 0.44];
mean5 = mean( timeLayers5 );

numLayers10 = 10.*[1, 1, 1, 1, 1];
timeLayers10 = [0.77, 0.77, 0.78, 0.61, 0.54];
mean10 = mean( timeLayers10 );

numLayers20 = 20.*[1, 1, 1, 1, 1];
timeLayers20 = [0.94, 0.96, 0.97, 0.78, 0.69];
mean20 = mean( timeLayers20 );

numLayers40 = 40.*[1, 1, 1, 1, 1];
timeLayers40 = [1.39, 1.40, 1.42, 1.15, 1.01];
mean40 = mean( timeLayers40 );

% All vectors
allLayers = ...
    [numLayers1, numLayers5, numLayers10, numLayers20, numLayers40];
allTimes = ...
    [timeLayers1, timeLayers5, timeLayers10, timeLayers20, timeLayers40];

figure();
hold on;
plot( allLayers, allTimes, 'ko', ...
    'MarkerSize', 3, ...
    'MarkerFaceColor', 'k');
plot( [1, 5, 10, 20, 40], [mean1, mean5, mean10, mean20, mean40], '--k' );
xlabel( 'Number of Layers', 'FontSize', 26 );
ylabel( 'Computation Time [s]', 'FontSize', 26 );
box on;

