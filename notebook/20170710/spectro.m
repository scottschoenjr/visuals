% Spectrogram Plot
clear all;
close all;
clc;

[timeSeries, Fs] = audioread( 'alsoSprachtZarathustra.mp3' );
timeSeries = mean( timeSeries, 2 );
spectrogram( timeSeries, 512, 128, 256, Fs, 'yaxis' );
ylabel( 'Frequency [kHz]' );
xlabel( 'Time [min]' );
