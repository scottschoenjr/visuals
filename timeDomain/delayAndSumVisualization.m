%**************************************************************************
%
% Delay and Sum Reconconstruction Visualization 
%
%              Scott Schoen Jr | Georgia Tech | 20170111
%
%************************************************************************** 

clear all
close all
clc

% Add necessary paths
addpath( genpath( '../../inc/' ) );

% Define interrogation point
x0 = -1;
y0 = 0;

% Define source point
xS = -1;
yS = 0;

% Define sound speed
c0 = 343;

% Define receiver positions
numReceivers = 7;
yRec = linspace( -1, 1, numReceivers );
xRec = 0.*yRec;

% Get distances to each receiver
rToPoint = sqrt( (xRec - x0).^(2) + (yRec - y0).^(2) );
delays = rToPoint./c0;

% Define source signal
samplingFrequency = 20E3; % [Hz]
tMax = 0.1;
f0 = 2E3;
dt = 1./samplingFrequency;
tVector = 0:dt:tMax;
sourceSignal = pulse(tVector, f0, 0.2, 10E-3, 0);

% Get the signal at each receiver
receivedSignals = zeros( numReceivers, length(tVector) );

for receiverCount = 1 : numReceivers
   
    % Get amplitude corrections
    amp = 1./rToPoint(receiverCount);
    
    % Get number of delay indices associated with that reciver
    shiftIndices = round( delays( receiverCount )./dt );
    
    % Get Shifted Signal
    shiftedSignal = circshift( sourceSignal, shiftIndices, 2 );
    
    % Store to output
    receivedSignals( receiverCount, : ) = amp.*shiftedSignal;
    
end

% Plot each received signal
figure()

timeSeriesAxes = axes();
set( gca, 'Position', [0.52, 0.12, 0.42, 0.8] );
box on;
hold all;
for receiverCount = 1 : numReceivers
   
    % Get scaling
    scale = 0.18;
    plotVector = scale.*receivedSignals(receiverCount, :);
    
    % Get offset
    offset = yRec( receiverCount );
    
    % Set scaling and plot
    plot( 1E3.*tVector, 1E2.*(plotVector + offset), 'k' )
    
end

% Format plot
xlabel( 'Time [ms]' );
xlim([5, 20]);
set( gca, 'XTick', [10, 15, 20] ); % No tick at 0 to avoid clash
% set( gca, 'XDir', 'Reverse' );

ylim( (1 + scale).*1E2.*[min(yRec), max(yRec)] );

sourcePositionAxes = axes();
set( gca, 'Position', [0.1, 0.12, 0.42, 0.8] );
box on;
hold all;

% Plot source position
plot( 1E2.*xS, 1E2.*yS, 'ro' );

% Plot lines to each receiver
for receiverCount = 1 : numReceivers
    
   % Get plotting vectors
   xLine = 1E2.*[ x0, xRec( receiverCount ) ];
   yLine = 1E2.*[ y0, yRec( receiverCount ) ];
   
   % Plot line
   plot( xLine, yLine, '--r' );
    
end

% Set same ylim as time series
ylabel( 'Receiver Position [cm]' );
ylim( (1 + scale).*1E2.*[min(yRec), max(yRec)] );

% Set left limit to receiver position
xlabel( 'Axial Distance [cm]' );
xlim( 1E2.*[1.1.*x0, max(xRec)] );

% Now plot delayed signals
figure()

shiftedTimeSeriesAxes = axes();
set( gca, 'Position', [0.12, 0.4, 0.8, 0.55] );
hold all;
box on;
set( gca, 'XTickLabel', '' );

summation = 0.*sourceSignal;

for receiverCount = 1 : numReceivers
   
    % Get scaling
    scale = 0.18;
    
    % Get amplitude corrections
    amp = 1./rToPoint(receiverCount);
    plotVector = scale.*amp.*sourceSignal;
    
    % Add into summation
    summation = summation + plotVector;
    
    % Get offset
    offset = yRec( receiverCount );
    
    % Set scaling and plot
    plot( 1E3.*tVector, 1E2.*(plotVector + offset), 'k' )
    
end
xlim( [0, 20] );
ylim( (1 + scale).*1E2.*[min(yRec), max(yRec)] );

summationAxes = axes();
set( gca, 'Position', [0.12, 0.1, 0.8, 0.3] );
hold all;
box on;

plot( 1E3.*tVector, summation./max(abs(summation)) );

xlim( [0, 20] );
ylim([-1.12, 1.12]);

xlabel('Time [ms]');
ylabel('Total [AU]' );






