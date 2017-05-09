%**************************************************************************
%
% Fourier Transform Reconstruction Visualizer
%
%   Scirpt shows an animated visualization of Fourier transform
%   reconstuction for an arbitrary signal.
%
%              Scott Schoen Jr | Georgia Tech | 20170127
%
%**************************************************************************

clear all
close all
clc

% Add path for callback functions
addpath( './callbacks' );

% Create source signal
Fs = 500;
tMax = 1;
N = tMax.*Fs;
tVector = linspace( 0, tMax, N ); % [s]
f0 = 5;
s = sawtooth( 2.*pi.*f0.*tVector );
s = square( 2.*pi.*f0.*tVector );
percentile = 0.01; % Plot only this contributions above this

% Read in audio file
useAudioFile = 0;
audioFile = './audio/horned_owl-Mike_Koenig-1945374932.wav';
if useAudioFile
    % Read in audio and reset sampling frequency/time vector
    [s, Fs] = audioread( audioFile );
    if ~iscolumn(s)
        s = mean(s, 2); % If stereo, reduce to one channel
    end
    N = length(s);
    tMax = N./Fs;
    tVector = linspace( 0, tMax, N ); % [s]
end

% Get Fourier transform of signal and frequency vector
sTilde = fft(s);
fVector = linspace( 0, Fs, N ); % [Hz]

% Get amplitude and phase vectors
ampVec = 2.*abs( sTilde );
phaseVec = angle( sTilde );

% Variable to hold movie
M = [];

% Create figure
figure(1)
set( gcf, 'Position', [50, 75, 1600, 800] );

% Initializations
needToCreateAxes = 1;
sumOfContributions = 0.*tVector;

% Create axes to plot summation of components at z = 0
summationAxes = axes();
set( summationAxes, 'Position', [0.1, 0.4, 0.5, 0.5] );
ylim( 1.13.*[-1, 1] );
xlim( [min(tVector), max(tVector)] );
set( gca, 'YTick', -1:0.5:1, 'XTick', [] );
hold all;
box on;

% Plot source signal for reference
plot( tVector, s, '--b', 'LineWidth', 1.6 );

% Axes to plot individual contributions
contributionAxes = axes();
set( contributionAxes, 'Position', [0.1, 0.2, 0.5, 0.2] );
hold all;
box on;

yMaxValue = 1.02.*max(ampVec./N);
ylim( 1.05.*[-yMaxValue, yMaxValue] );
ylabel( 'Amplitude', 'FontSize', 18 );

xlim( [min(tVector), max(tVector)] );
xlabel( 'Time [s]', 'FontSize', 22 );

% Create axes for amplitude of the spectrum
ftMagnitudeAxes = axes();
set( ftMagnitudeAxes, 'Position', [0.7, 0.5, 0.25, 0.3], ...
    'XTickLabel', '');
hold all;
box on;
% Plot amplitude
plot( ftMagnitudeAxes, fVector./1E3, ampVec./N, 'k' );
% Format
ylabel( 'Amplitude [AU]' );
ylim( [-0.02, yMaxValue] );
xlim([0, Fs./2]./1E3);
title( '$\mathcal{F}[f(t)]$', 'FontSize', 26 );
zoom xon;

% Create axes for phase of the spectrum
ftPhaseAxes = axes();
set( ftPhaseAxes, 'Position', [0.7, 0.2, 0.25, 0.3] );
hold all;
box on;
% Plot Phase
plot( ftPhaseAxes, fVector./1E3, phaseVec, 'k' );
% Format
xlim([0, Fs./2]./1E3);
ylabel('Phase [rad]');
ylim( 1.1.*[-pi, pi] );
ax = gca;
ax.YTick = [-pi, -pi/2, 0, pi/2, pi];
ax.YTickLabel = ...
    {'$-\pi$';'$-\frac{\pi}{2}$';'$0$';'$\frac{\pi}{2}$';'$\pi$'};
xlabel( 'Frequency [kHz]' );
zoom xon;

% Link x-axes in case we zoom
linkaxes( [ftMagnitudeAxes, ftPhaseAxes], 'x' );

% It would be too slow to plot for every single frequency. Instead set a
% percentile, and only plot contributions above a certain percentile
sortedAmplitudes = sort( ampVec );
thresholdIndex = round( (percentile./100).*length(ampVec) );
thresholdIndex = max( thresholdIndex, 1 );
thresholdValue = sortedAmplitudes( thresholdIndex );

% Loop over all frequencies
for fCount = 1:round(N./2)
    
    % Check if we want to display this frequency
    if ampVec(fCount) < thresholdValue
        continue;
    end
    
    % Delete old current contribution line (whther or not we'll plot a new
    % one)
    existingContributionLine = ...
        findobj( 'Tag', 'currentContribtutionLine' );
    contributionLineExists = ~isempty( existingContributionLine );
    if contributionLineExists
        delete(currentContribution);
    end
    
    % Get magnitude and phase of this contribution (multiply by 2 since 
    % we're only plotting half the spectrum, so the total energy would also
    % be halved).
    amplitude = 2.*abs( sTilde( fCount ) )./N;  % 
    phi = mod( angle( sTilde( fCount ) ), 2.*pi );
    
    % Define contribution vector
    omega = 2.*pi.*fVector( fCount );
    contribution = amplitude.*cos( omega.*tVector + phi );
    
    % Delete any previous contribution lines
    lastContributionLine = findobj( 'Tag', 'contributionLine' );
    if ~isempty( lastContributionLine )
        delete( lastContributionLine );
    end
    
    % First plot in gray to remain on plot
    previousContributions = plot( summationAxes, ...
        tVector, contribution, ...
        'Color', 0.6.*[1, 1, 1], ...
        'LineWidth', 1 );
        
    % Plot current contribution in black 
    plot( contributionAxes, tVector, contribution, 'k', ...
        'LineWidth', 2.5, 'Tag', 'contributionLine');   
    
    % Add into summation and plot that on the summation axes
    sumOfContributions = sumOfContributions + contribution;
    prevSummationLine = findobj( 'Tag', 'summationLine' );
    if ~isempty( prevSummationLine )
        delete(prevSummationLine); % Delete old one
    end
    sumLine = plot( summationAxes, ...
        tVector, sumOfContributions, 'b', ...
        'LineWidth', 1.2, 'Tag', 'summationLine' ); % Plot new one
    
    % Plot contribution on summation axes
    currentContribution = plot( summationAxes, ...
        tVector, contribution, 'k', 'Tag', 'contributionLine' );
    
    % Display the current angle
    titleString = sprintf( ...
        '$f = %4d$~Hz', round(fVector(fCount)) );
    title( summationAxes, titleString );
    
    % Plot indicator on spectrum plots
    currentIndicators = findobj( 'Tag', 'FTIndicator' );
    if ~isempty( currentIndicators );
        delete( currentIndicators );
    end
    plot( ftMagnitudeAxes, ...
        fVector(fCount)./1E3, ampVec(fCount)./N, ...
        'ro', 'Tag', 'FTIndicator' );
    plot( ftPhaseAxes, ...
        fVector(fCount)./1E3, phaseVec(fCount), ...
        'ro', 'Tag', 'FTIndicator' );
    
    % Save the frame
    drawnow;
    M = [M, getframe(gcf)];
    
end

% Once we're done, display playback buttons (if the signal is long enough)
if tMax > 0.3
    playOriginalSignal = uicontrol( ...
        'Style', 'pushbutton', ...
        'String', ...
        '<HTML><FONT color="EEB211">Play Original</font></HTML>', ...
        'BackgroundColor', [0 37 76]./255, ...
        'ForegroundColor', [1, 1, 1], ...
        'Units', 'Normalized', ...
        'FontSize', 16, ...
        'Position', [0.32, 0.02, 0.15, 0.08], ...
        'Callback', {@playAudio, s, Fs} ...
        );
    playReconSignal = uicontrol( ...
        'Style', 'pushbutton', ...
        'String', ...
        '<HTML><FONT color="EEB211">Play Synthesized</font></HTML>', ...
        'BackgroundColor', [0 37 76]./255, ...
        'ForegroundColor', [1, 1, 1], ...
        'Units', 'Normalized', ...
        'FontSize', 16, ...
        'Position', [0.53, 0.02, 0.15, 0.08], ...
        'Callback', {@playAudio, sumOfContributions, Fs} ...
        );
end
