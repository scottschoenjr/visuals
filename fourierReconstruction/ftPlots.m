%**************************************************************************
%
% Fourier Transform Reconstruction Plots
%
%   Scipt plots a function and its Fourier transform
%
%              Scott Schoen Jr | Georgia Tech | 20170127
%
%**************************************************************************

clear all
close all
clc

% Create source signal
Fs = 10E3;
tMax = 1;
N = tMax.*Fs;
tVector = linspace( 0, tMax, N ); % [s]
f0 = 1E2;
s = square( 2.*pi.*f0.*tVector );
% s = sawtooth( 2.*pi.*f0.*tVector );
% s = cos( 2.*pi.*f0.*tVector ) + 2.*cos( 3.*2.*pi.*f0.*tVector );

% Set axes title
titleString = '$s(t) = \cos{\omega_{0}t} + 2\cos{3\omega_{0} t}$';

% Get Fourier transform of signal and frequency vector
sTilde = fft(s);
fVector = linspace( 0, Fs, N ); % [Hz]

% Get amplitude and phase vectors
ampVec = 2.*abs( sTilde );
phaseVec = angle( sTilde );

% Plot time series
figure();

plot( tVector, s, 'k' );
xlabel( 'Time [s]' );
ylabel( '$s(t)$', 'FontSize', 22 );

xlim( [0, 0.1] );

% Plot Fourier transform
figure()

plot( fVector./1E3, ampVec./max(ampVec), 'k' );
xlabel( 'Frequency [kHz]' );
ylabel( '$|\tilde{s}(\omega)|$', 'FontSize', 22 );
ylim( [0, 1.02] );
xlim( [0, Fs./2]./1E3 );

zoom xon;

% title( titleString );

