% Problem 5 Spring 2010

clear all
close all
clc

% Define ODE
yPrime = @(t, y) -1000.*y + 3000 - 2000.*exp( -t );
y0 = 0; % Initial condition
tRange = [0, 0.4];
% Solve with MATLAB
[tRef, yRef] = ode45( yPrime, tRange, y0 );

% Solve with Euler's method
tStart = min(tRange);

% Set uniform region
uniformRegion = 1;
deltaT = 0.0001;
currentT = tStart;
currentY = y0;
currentPoint = 1;

% Or manually specify points
tPoints = [ 0:0.0001:0.02, 0.02:0.01:0.2];

if uniformRegion
    while currentT < 1.1.*max(tRange)
        
        % Store current point
        tSol( currentPoint ) = currentT;
        ySol( currentPoint ) = currentY;
        currentPoint = currentPoint + 1;
        
        % Get derivative at that point
        dydt = yPrime( currentT, currentY );
        
        % Get next point
        currentY = currentY + dydt.*deltaT;
        currentT = currentT + deltaT;
    end
    
else
    
    tSol = tPoints;
    
    for tCount = 1:length( tPoints )
        
        % Define time interval
        if tCount == 1
            deltaT = tPoints(2) - tPoints(1);
        else
            deltaT = tPoints( tCount ) - tPoints( tCount - 1 );
        end
        
        % Store current point
        ySol(tCount) = currentY;
        
        % Get derivative at that point
        dydt = yPrime( currentT, currentY );
        
        % Get next point
        currentY = currentY + dydt.*deltaT;
        
    end
    
end

% Plot the results for comparison
figure()
hold all;
[euler] = plot( tSol, ySol, '-ok' );
[reference] = plot( tRef, yRef, '--k' );

xlabel( '$t$', 'FontSize', 24 );
ylabel( '$y$', 'FontSize', 24 );
xlim([0, 0.4])
ylim([0,4.4]);
box on;
lh = legend( ' Euler''s Method', ' Reference Solution' );
set( lh, 'FontSize', 22 );
