%**************************************************************************
%
% Sine Wave Summation
%
%   Scipt plots a series of sine waves and their summation
%
%              Scott Schoen Jr | Georgia Tech | 20170413
%
%**************************************************************************

clear all
close all
clc

% Set frequencies
ampVector = [0.2, 0.8, 1, 0.6]; % Normalized amplitudes
fVector = 2.2.*[2.5, 3.1, 4.6, 8.6]; % Normalized frequency
phiVector = [pi./2, pi./5, pi, pi./sqrt(2)]; % Phase [rad]

% Create time vector
t = linspace( -2, 2, 1000 );

% Plot each vector
figure();
hold all;
totalSignal = 0.*t;
bufferDistance = 2.4;
for sineCount = 1:length( ampVector )
    
    % Get this component
    A = ampVector(sineCount);
    omega = 2.*pi.*fVector(sineCount);
    phi = phiVector(sineCount);  
    
    % Get signal and offset
    s = A.*sin( omega.*t + phi );
    offset = bufferDistance.*(sineCount - 1);
    
    % Add into sum and plot
    totalSignal = totalSignal + s;    
    plot( t, s - offset, 'k', 'LineWidth', 1.6 );
    
end

% Plot the sum
offset = 1.1.*bufferDistance.*sineCount;
plot( t, totalSignal - offset, 'LineWidth', 2.5 );

xlim( [0, 1] );
ylim( [-1.25.*offset, 1] );
