% Visual example of Newton's method for root finding

clear all
close all
clc

% Define parameter
xMin = 0 - 0.1;
xMax = 2.*pi + 0.1;
Nx = 1000;
x = linspace( xMin, xMax, 1000 );

% Define function and its derivative
factor = 5;
f = @(x) sin(factor.*x);
fPrime = @(x) factor.*cos(factor.*x);

% Set initial guess
x0 = pi - 0.8;

% Set pause duration
pauseLength = 1;

% Set up figure
figure()
box on;
hold all;

% Plot function
functionPlot = plot( x, f(x) );

% Plot axes
xAxisLine = plot( [-1E6, 1E6], [0, 0], 'k', 'LineWidth', 1.5 );
yAxisLine = plot( [0, 0], [-1E6, 1E6], 'k', 'LineWidth', 1.5 );

xlim( [2, 4] );
ylim( 1.1.*[-1, 1] );

xlabel('$x$', 'FontSize', 22 );
ylabel( '$f(x)$', 'FontSize', 22 );

% Loop through and plot tangents
numSteps = 6;
for stepCount = 1:numSteps
    
    % Get current point's y-value
    y0 = f(x0);
   
    % Plot point of intial guess
    plot( x0, f(x0), 'ro' );
    plot( [x0, x0], [0, y0], '--k', 'LineWidth', 1 );
    pause( pauseLength );
    
    % Get the slope of the tangent
    slope = fPrime(x0);
    
    % Get the line associated with that slope and point
    line = y0 + slope.*( x - x0 );
    plot( x, line, '--r', 'LineWidth', 1 );
    pause( pauseLength );
    
    % Find when the line crosses 0 and update
    newIndex = find( abs( line ) == min( abs( line ) ) );
    x0 = x( newIndex );
    
end