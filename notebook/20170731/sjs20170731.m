% Reflection Coefficient for the Channel

clear all;
close all;
clc;

% Load data of interest
d1 = 0.05 - 0.02;
load( 'data/AirChannelPulseEcho_V100_z0.00.mat' );
clc;

t = tVector;
V = voltageTrace;

% Plot
title( 'Select Initial Pulse' );
plot( t, V, 'k');

% Get start and end points of initial pulse
SelectNewPoints = 1;
keepZoom = 0;
while SelectNewPoints == 1;
    
    % Zoom to selected point
    if ~keepZoom
        plot( t, V, 'k');
        %     set( gca, 'XLim', [min(t), max(t)]);
        [tSelected, ~ ] = ginput(1);
        tSpan = max(t) - min(t);
        tStart = tSelected - 0.05.*tSpan;
        tEnd = tSelected + 0.05.*tSpan;
        set( gca, 'XLim', [tStart, tEnd] );
    end
    
    % Now get start and end points
    title( 'Select Start and End Points' );
    drawnow;
    [tSelected, ~ ] = ginput(2);
    tStart = tSelected(1);
    tStartIndex = find( t > tStart, 1 );
    tEnd = tSelected(2);
    tEndIndex = find( t > tEnd, 1 );
    
    % Cut out time series for initial pulse
    tInitialPulse = t( tStartIndex : tEndIndex );
    vInitialPulse = V( tStartIndex : tEndIndex );
    
    % Update plot to show pulse
    title( 'Selected Pulse' );
    plot( tInitialPulse, vInitialPulse, 'k' );
    
    % Prompt to plot again
    reply = questdlg('Look Good?','Does it?', ...
        'Yes', 'No - Keep Zoom', 'No - Start Again', 'Yes');
    if strcmp( reply, 'Yes' )
        SelectNewPoints = 0;
        close( gcf );
    elseif strcmp( reply, 'No - Keep Zoom' )
        keepZoom = 1;
    else
        keepZoom = 0;
    end
    
end

% Plot fft of signal
dt = t(2) - t(1);
Fs = 1./dt;
fVector = linspace( 0, Fs, length(tInitialPulse) ); % [Hz]
vTilde = fft( vInitialPulse );
vTildeNormMag = abs(vTilde)./max(abs(vTilde(10:end)));
plot( fVector./1E6, vTildeNormMag, 'k' );
xlabel( 'Frequency [MHz]' );
ylabel( 'Normalized Amplitude' );
xlim( [0.2, 15] );
title( 'Initial Pulse' );

% Get start and end points of channel reflection
% Plot
figure();
title( 'Select Reflection of Interest' );
plot( t, V, 'k');

% Zoom to selected point
SelectNewPoints = 1;
keepZoom = 0;
while SelectNewPoints == 1;
    
    % Zoom to selected point
    if ~keepZoom
        plot( t, V, 'k');
        %     set( gca, 'XLim', [min(t), max(t)]);
        [tSelected, ~ ] = ginput(1);
        tSpan = max(t) - min(t);
        tStart = tSelected - 0.05.*tSpan;
        tEnd = tSelected + 0.05.*tSpan;
        set( gca, 'XLim', [tStart, tEnd] );
    end
    
    % Now get start and end points
    title( 'Select Start and End Points' );
    drawnow;
    [tSelected, ~ ] = ginput(2);
    tStart = tSelected(1);
    tStartIndex = find( t > tStart, 1 );
    tEnd = tSelected(2);
    tEndIndex = find( t > tEnd, 1 );
    
    % Cut out time series for initial pulse
    tReflection = t( tStartIndex : tEndIndex );
    vReflection = V( tStartIndex : tEndIndex );
    
    % Update plot to show pulse
    title( 'Selected Pulse' );
    plot( tReflection, vReflection, 'k' );
    
    % Prompt to plot again
    reply = questdlg('Look Good?','Does it?', ...
        'Yes', 'No - Keep Zoom', 'No - Start Again', 'Yes');
    if strcmp( reply, 'Yes' )
        SelectNewPoints = 0;
    elseif strcmp( reply, 'No - Keep Zoom' )
        keepZoom = 1;
    else
        keepZoom = 0;
    end
    
end


% Estimate broadband reflection coefficient
meanVoltage = mean( voltageTrace );
totalEnergy = sum( (vInitialPulse - meanVoltage).^(2) );
reflectedEnergy = sum( (vReflection - meanVoltage).^(2) );
tau = abs( reflectedEnergy./totalEnergy );


% Plot fft of reflection
dt = t(2) - t(1);
Fs = 1./dt;
fVectorRef = linspace( 0, Fs, length(tReflection) ); % [Hz]
vTildeRef = fft( vReflection );
vTildeRefNormMag = abs(vTildeRef)./max(abs(vTildeRef(10:end)));
plot( fVectorRef./1E6, vTildeRefNormMag, 'k' );
xlabel( 'Frequency [MHz]' );
ylabel( 'Normalized Amplitude' );
xlim( [0.2, 15] );
title( 'Reflected Spectrum' );

% Interpolate to have values at same frequencies
refLength = length( vTildeRef );
pulseLength = length( vTilde );
if refLength >= pulseLength
    vTildeRef = interp1( fVectorRef, vTildeRef,  fVector );
    f = fVector;
elseif refLength < pulseLength
    vTilde = interp1( fVector, vTilde,  fVectorRef );
    f = fVectorRef;
end

% Plot magnitude and phase of reflection coefficient
rDimension = 0;
spreadingFactor = (2.*d1).^(rDimension);
R = (spreadingFactor).*vTildeRef./vTilde;
figure()
subplot( 2, 1, 1 )
plot( f./1E6, abs( R ) );
ylabel( '$|\mathcal{R}|$' );
subplot( 2, 1, 2 )
plot( f./1E6, 180.*angle( R )./pi );
ylabel( '$\angle \mathcal{R}$ [deg]' );
xlabel( 'Frequency [MHz]' );
