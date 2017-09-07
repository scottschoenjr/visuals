% Box and whisker plot of timing data for different reconstruction methods

clear all;
close all;
clc

layerTimes = [ 0.706, 0.697, 0.746, 0.728, 0.734, ...
    0.727, 0.719, 0.740, 0.752, 0.727, 0.721 ];
stratTimes = [ 0.3415, 0.3516, 0.3538, 0.3546, 0.3866, ...
    0.3385, 0.3592, 0.3854, 0.3471, 0.3455, 0.3601 ];
stratSubTimes = [ 0.1297, 0.1302, 0.1248, 0.1238, 0.1261, ...
    0.1305, 0.133, 0.1241, 0.1234, 0.1254, 0.1207 ];


layerX0 = 0.75;
stratX0 = 1.5;
stratSubX0 = 2.25;

layerColor = [116, 0, 83]./255;
stratColor = [249, 94, 16]./255;    

% Plot Bars
hold all;
bar( [layerX0], [mean( layerTimes )], 0.5, ...
    'FaceColor', layerColor, ...
    'EdgeColor', 'none' );
bar( [stratX0], [mean( stratTimes )], 0.5, ...
    'FaceColor', stratColor, ...
    'EdgeColor', 'none' );
bar( [stratSubX0], [mean( stratSubTimes )], 0.5, ...
    'FaceColor', stratColor, ...
    'FaceAlpha', 0.5, ...
    'EdgeColor', stratColor, ...
    'LineWidth', 3.5, ...
    'LineStyle', '--' );
xlim( [0.4, 2.6] );

% Plot caps
capWidth = 0.3;
lineWidth = 3;

layerBarY = [0, max(layerTimes)];
layerBarX = [layerX0, layerX0];
layerCapY = max( layerTimes ).*[1, 1];
layerCapX = [layerX0 - capWidth./2, layerX0 + capWidth./2];
plot( layerBarX, layerBarY, ...
    'Color', layerColor, 'LineWidth', lineWidth );
plot( layerCapX, layerCapY, ...
    'Color', layerColor, 'LineWidth', lineWidth );

stratBarY = [0, max(stratTimes)];
stratBarX = [stratX0, stratX0];
stratCapY = max( stratTimes ).*[1, 1];
stratCapX = [stratX0 - capWidth./2, stratX0 + capWidth./2];
plot( stratBarX, stratBarY, ...
    'Color', stratColor, 'LineWidth', lineWidth );
plot( stratCapX, stratCapY, ...
    'Color', stratColor, 'LineWidth', lineWidth );
    
stratSubBarY = [min( stratSubTimes ), max(stratSubTimes)];
stratSubBarX = [stratSubX0, stratSubX0];
stratSubCapY = max( stratSubTimes ).*[1, 1];
stratSubCapX = [stratSubX0 - 0.5.*capWidth./2, stratSubX0 + 0.5.*capWidth./2];
stratSubCapY_bot = min( stratSubTimes ).*[1, 1];
plot( stratSubBarX, stratSubBarY, ...
    'Color', stratColor, 'LineWidth', lineWidth );
plot( stratSubCapX, stratSubCapY, ...
    'Color', stratColor, 'LineWidth', lineWidth );
plot( stratSubCapX, stratSubCapY_bot, ...
    'Color', stratColor, 'LineWidth', lineWidth );

% Format plot
set( gca, ...
    'XTick', [layerX0, stratX0], ...
    'XTickLabel', '' );
ylabel( 'Computation Time [s]', 'FontSize', 28 );