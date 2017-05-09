clear all
close all
clc

load( 'totalAvg.mat' );
totalAvgData = centerProfileNorm;
load( 'layered.mat' );
layeredData = centerProfileNorm;
load( 'selective.mat' );
selectiveData = centerProfileNorm;

figure()
hold all;
plot( 1E3.*z, totalAvgData, ':k' );
plot( 1E3.*z, layeredData, '--k' );
plot( 1E3.*z, selectiveData, 'k' );

box on;
xlabel('Distance From Receiver [mm]', 'FontSize', 26 );
ylabel('Normalized Intensity', 'FontSize', 26 );
xlim([45, 75]);
set( gca, 'XDir', 'Reverse' );
legend( ' Total Averaging', ' Layered Averaging', ' Selective Averaging' );

