clear all
close all
clc

% Read in audio and reset sampling frequency/time vector
[s, Fs] = audioread( 'raven.wav' );
if ~iscolumn(s)
    s = mean(s, 2); % If stereo, reduce to one channel
end
N = length(s);
tMax = N./Fs;
tVector = linspace( 0, tMax, N ); % [s]

% Take FFT and create frequency vector
sTilde = fft( s );
fVector = linspace( 0, Fs, length( tVector ) );

% Create band-limited signal
f0 = 2000;
BW = [2, 1, 0.5, 0.25];

fMinVec = [0, 500, 1E3, 1.5E3];
fMaxVec = [20E3, 10E3, 5E3, 4E3];

% Create vector containing audio with various bandwidths
totalSignal = [];
for bwCount = 1:length( BW )
    
   % Get current bandwidth
   bw = BW( bwCount );
   
   % Determine frequency range
   if exist( 'fMinVec', 'var' );
       
       fMax = fMaxVec( bwCount );
       fMin = fMinVec( bwCount );
   else
       
       fMax = f0 + (f0./2).*bw;
       fMin = f0 - (f0./2).*bw;
   end
   
   % Reconstruct audio signal with those frequencies
   fIndicesToDiscard = find( ...
       ( fVector <= fMin ) | ( fVector >= fMax ) );
   currentSTilde = sTilde; % Keep original vector
   currentSTilde( fIndicesToDiscard ) = 0;
   currentS = ifft( currentSTilde );
   
   % Normalize so they're all the same volume
   currentS = currentS./max(abs(currentS));
   totalSignal = [totalSignal; currentS];
   
   % Add a 1 s pause between
   
   silence = zeros( 1, Fs./2 );
   totalSignal = [totalSignal; silence'];
   
end

% Write result to audio file
audiowrite( 'test.wav', totalSignal, Fs );

