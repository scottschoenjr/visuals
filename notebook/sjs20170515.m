%% Data generator for signal processing practice

clear all
close all
clc

% Choose some peak frequencies
toneFrequencies = [1000, 2300, 5000, 9000];
% Set their amplitudes
toneAmplitudes = [0.1, 0.8, 0.4, 0.2];
% And phases
tonePhases = rand(1, length(toneFrequencies)).*2.*pi; % [rad]

% Create the signal
Fs = 20E3; % [Hz]
dt = 1./Fs; % [s]
tVector = 0:dt:0.1;

s = 0.*tVector; % Initialize
for fCount = 1:length(toneFrequencies)
   
    % Add in this component
    A = toneAmplitudes( fCount );
    omega = 2.*pi.*toneFrequencies( fCount );
    phi = tonePhases( fCount );
    s = s + A.*sin( omega.*tVector + phi );
    
end

% Add in some white noise
noiseLevel = 0.4;
noise = noiseLevel.*rand( 1, length( tVector ) );
s = s + noise;

% Plot for reference
figure()
plot( 1E3.*tVector, s, 'k' );
xlabel( 'Time [ms]' );
ylabel( 'Normalized Signal [AU]' );

% Get frequency vector
fVector = linspace( 0, Fs, length( tVector ) );

% Get FFT of signal
sTilde = fft( s );

% Plot amplitude and phase
figure()
subplot( 2, 1, 1 )
plot( fVector./1E3, abs(sTilde)./max(abs(sTilde)), 'k' );
ylabel( 'Normalized Amplitude [AU]' );
xlim( [10, (Fs./2)]./1E3 );
ylim([0, 1]);

subplot( 2, 1, 2 )
plot( fVector./1E3, angle(sTilde), 'k' );
xlabel( 'Frequency [kHz]' );
ylabel( 'Phase [rad]' );
xlim( [10, (Fs./2)]./1E3 );
ylim([-pi, pi]);

% Write data
fid = fopen( 'data.txt', 'w' );
fmt = '%10.3d %10.3d\n';
fprintf( fid, fmt, [tVector; s] );
fclose( 'all' );

