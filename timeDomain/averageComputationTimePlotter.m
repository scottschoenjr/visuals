% Plotter for timed computation data

clear all
close all
clc

% Initialize total vectors
totalConvTimes = 1;
totalMultTimes = 1;

% File parameters
numFiles = 10;
baseFilename = 'test';

for fileCount = 1:numFiles
    
    % Load current data
    load( [baseFilename, num2str( fileCount ), '.mat' ] );
    if fileCount == 1
        totalConvTimes = convTimes;
        totalMultTimes = multTimes;
    else
        % Add in next 
        totalConvTimes = totalConvTimes + convTimes;
        totalMultTimes = totalMultTimes + multTimes;
        
    end
    
end

% Compute average time
avgConvTimes = totalConvTimes./numFiles;
avgMultTimes = totalMultTimes./numFiles;

% Plot!
figure()
hold all;
box on;

multPlot = plot( numVectorPoints, avgMultTimes.*1E3, 'k' );
convPlot = plot( numVectorPoints, avgConvTimes.*1E3, '--k' );

xlim( [6E3, 2E5] );

xlabel( 'Number of Points', 'FontSize', 24 );
ylabel( 'Computation Time [ms]', 'FontSize', 24 );

set( gca, 'XScale', 'log', ...
    'XTick', [1E4, 5E4, 1E5, 2E5], ...
    'XTickLabel', {'10,000'; '50,000';'100,000';'200,000'} );
set( gca, 'YScale', 'log', ...
    'YTick', [0.01, 0.1, 1, 10, 100, 1000, 10000], ...
    'YTickLabel', {'0.01'; '0.1';'1';'10';'100';'1 s';'10 s' } );

legHandle = legend( [convPlot, multPlot,], ...
    '\,\,$f * g$', ...
    '\,\,$\mathcal{F}^{-1}[ \tilde{f} \cdot \tilde{g} ]$' );
set( legHandle, 'Interpreter', 'LaTeX', 'FontSize', 24 );