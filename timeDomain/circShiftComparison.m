%**************************************************************************
%
% Plot of MATLAB's Shift Function vs. Frequency Domain Multiplication 
%
%              Scott Schoen Jr | Georgia Tech | 20170113
%
%************************************************************************** 

clear all
close all
clc

% Set range of vector sizes
M = logspace( 2, 6, 100 );

% Get order of number of computations
tdComputations = M.^(2);
fdComputations = M.*log10( M );

% Get approximate rate of calculations
numComputations = 1E6;
startTime = cputime;
for calcCount = 1 : numComputations
    x = pi.*exp(1);
end
elapsedTime = cputime - startTime;
calcsPerSecond = numComputations./elapsedTime;

% Create vectors with each number of entries. Then use circshift vs.
% Fourier transform

% Get computations times
tdTime = tdComputations./calcsPerSecond;
fdTime = fdComputations./calcsPerSecond;

% Plot
figure()
hold all;
box on;

tdPlot = plot( M, tdTime./fdTime, '--k' );
fdPlot = plot( M, fdTime, 'k' );

xlabel( 'Number of Pixels' );
ylabel( 'Computation Time [s]' );

set( gca, 'XScale', 'log' );
set( gca, 'YScale', 'log' );

legend( [tdPlot, fdPlot], ' Time Domain', ' Frequency Domain' )

% Compute and plot convolution vs. multiplication
numSteps = 31;
numVectorPoints = round( logspace( 3.6, 5.4, numSteps) );

% Vectors to store multiplication and convolution time steps
multTimes = zeros( 1, numSteps );
convTimes = zeros( 1, numSteps );
for stepCount = 1 : numSteps
    
   v1 = rand( 1, numVectorPoints( stepCount ) );
   v2 = rand( 1, numVectorPoints( stepCount ) );
   
   % Time multiplication and convolution
   tic;
   x = conv( v1, v2 );
   convTimes( stepCount ) = toc;
   tic;
   x = v1.*v2;
   multTimes( stepCount ) = toc;
       
end

%% Plotting 

figure()
hold all;
box on;

multPlot = plot( numVectorPoints, multTimes.*1E3, 'k' );
convPlot = plot( numVectorPoints, convTimes.*1E3, '--k' );

xlim( [6E3, 2E5] );

xlabel( 'Number of Points' );
ylabel( 'Computation Time [ms]' );

set( gca, 'XScale', 'log', ...
    'XTick', [1E4, 5E4, 1E5, 2E5], ...
    'XTickLabel', {'10,000'; '50,000';'100,000';'200,000'} );
set( gca, 'YScale', 'log', ...
    'YTick', [0.01, 0.1, 1, 10, 100, 1000, 10000], ...
    'YTickLabel', {'0.01'; '0.1';'1';'10';'100';'1 s';'10 s' } );

legHandle = legend( [multPlot, convPlot], '\,\,$f \cdot g$', '\,\,$f * g$' );
set( legHandle, 'Interpreter', 'LaTeX', 'FontSize', 22 );





