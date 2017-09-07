% Compare number of channels

clear all;
close all;
clc;

% define number of channels
% files = {'el32.mat'; 'el64.mat'; 'el128.mat'; 'el256.mat'; 'el320.mat' };
% numChannels = [32, 64, 128, 356, 320];
files = {'el32.mat'; 'el64.mat'; 'el128.mat'; };
numChannels = [32, 64, 128];

% Plot each
figure()
hold all;
for channelCount = 1:length( numChannels );
    
    load( files{channelCount} );
    xVec_mm = linspace( 0, 80, length( axialProfileNorm ) );
    plot(  xVec_mm, axialProfileNorm, 'k' );
    
end

xlabel( 'Distance from Receiver [mm]', 'FontSize', 22 );
set( gca, 'XDir', 'Reverse' );
ylabel( 'Normalized Intensity', 'FontSize', 22 );