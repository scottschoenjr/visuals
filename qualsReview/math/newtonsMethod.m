% Visual example of Newton's method for root finding

clear all
close all
clc

% Define parameter
xMin = 1.2;
xMax = 2.2;
Nx = 100000;
x = linspace( xMin, xMax, Nx );

% Define function and its derivative
f = @(x) x.^(4) - 5;
fPrime = @(x) 4*x.^(3);

% Set initial guess
x0 = 2;

% Set pause duration
pauseLength = 0.2;

% Set up figure
figure()
box on;
hold all;

% Plot function
functionPlot = plot( x, f(x) );

% Plot axes
xAxisLine = plot( [-1E6, 1E6], [0, 0], 'k', 'LineWidth', 1.5 );
yAxisLine = plot( [0, 0], [-1E6, 1E6], 'k', 'LineWidth', 1.5 );

xlim( [xMin, xMax] );
ylim( 3.*[-1, 1] );

xlabel('$x$', 'FontSize', 22 );
ylabel( '$f(x)$', 'FontSize', 22 );

% Loop through and plot tangents
numSteps = 8;
for stepCount = 1:numSteps
    
    % Get current point's y-value
    y0 = f(x0);
    
    if stepCount == 1
        disp( [ 'Initial Guess = ', num2str( x0 ), '. ' ...
            'f(x_i) = ', num2str(y0), '.'] );
    end   
        
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
    
    % Display successive roots
    disp( [ 'Next x_i = ', num2str( x0 ), '. ' ...
            'f(x_i) = ', num2str(f(x0)), '.' ] );
    
end