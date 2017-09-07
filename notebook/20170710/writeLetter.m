% Attempt to make letters in spectrogram

clear all
close all
clc

% Define tone frequencies
numVerticalSteps = 7;
fSteps = 1000.*linspace( 1, 4, numVerticalSteps );
Fs = 20E3;
dt = 1./Fs;

% Define letters

% Define normalized time over each letter
letterWidth = 0.5; % [s]
timePointsPerLetter = round(letterWidth.*Fs);
tau = linspace(0, 1, timePointsPerLetter );

% Define all frequcncy grid
allFreqs = zeros( numVerticalSteps, timePointsPerLetter );
for fCount = 1:numVerticalSteps;
    
    % Create sine wave at that frequency
    allFreqs( fCount, : ) = sin( 2.*pi.*fSteps(fCount)*tau );
    
end

% Now deine an on-off grid for each letter
hGrid = 0.*allFreqs;
hGrid( 1, ( tau < 0.15 | tau > 0.85 ) ) = 1;
hGrid( 2, ( tau < 0.15 | tau > 0.85 ) ) = 1;
hGrid( 3, ( tau < 0.15 | tau > 0.85 ) ) = 1;
hGrid( 4, : ) = 1;
hGrid( 5, ( tau < 0.15 | tau > 0.85 ) ) = 1;
hGrid( 6, ( tau < 0.15 | tau > 0.85 ) ) = 1;
hGrid( 7, ( tau < 0.15 | tau > 0.85 ) ) = 1;

eGrid = 0.*allFreqs;
eGrid( 1, : ) = 1;
eGrid( 2, ( tau < 0.15 ) ) = 1;
eGrid( 3, ( tau < 0.15 ) ) = 1;
eGrid( 4, : ) = 1;
eGrid( 5, ( tau < 0.15 ) ) = 1;
eGrid( 6, ( tau < 0.15 ) ) = 1;
eGrid( 7, : ) = 1;

lGrid = 0.*allFreqs;
lGrid( 1, : ) = 1;
lGrid( 2, ( tau < 0.15 ) ) = 1;
lGrid( 3, ( tau < 0.15 ) ) = 1;
lGrid( 4, ( tau < 0.15 ) ) = 1;
lGrid( 5, ( tau < 0.15 ) ) = 1;
lGrid( 6, ( tau < 0.15 ) ) = 1;
lGrid( 7, ( tau < 0.15 ) ) = 1;

oGrid = 0.*allFreqs;
oGrid( 1, : ) = 1;
oGrid( 2, ( tau < 0.15 | tau > 0.85 ) ) = 1;
oGrid( 3, ( tau < 0.15 | tau > 0.85 ) ) = 1;
oGrid( 4, ( tau < 0.15 | tau > 0.85 ) ) = 1;
oGrid( 5, ( tau < 0.15 | tau > 0.85 ) ) = 1;
oGrid( 6, ( tau < 0.15 | tau > 0.85 ) ) = 1;
oGrid( 7, : ) = 1;

% Define letters
h = hGrid.*allFreqs;
e = eGrid.*allFreqs;
l = lGrid.*allFreqs;
o = oGrid.*allFreqs;
space = zeros( numVerticalSteps, round(Fs.*letterWidth./6) );

% Get total audio signal
signal = [space, h, space, e, space, l, space, l, space, o, space];
signal = sum( signal );
audiowrite( 'helloAudio.wav', signal./max(abs(signal(:))), round( Fs./3 ) );

% Plot spectrum
spectrogram( signal, 512, 128, 256, Fs, 'yaxis' );
xlabel( 'Time [s]' );
ylabel( 'Frequency [kHz]' );
