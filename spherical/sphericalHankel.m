%**************************************************************************
%
% Spherical Hankel Function Plotter
% 
%**************************************************************************

clear all
close all
clc

% Define kr vector
kr = linspace( 1, 30, 1000 );
% kr = logspace( 0, 2, 1000 );
kr0 = 1;

% Define Hankel functions
nMax = 4;
normFactor = sqrt( pi./(2.*kr) );
figure();
hold all;
box on;

for nCount = 0:nMax
    
   % Define outgoing spherical Bessel functions
   h = normFactor.*( ...
       besselj( nCount + 1/2, kr ) + 1i.*bessely( nCount + 1/2, kr ) );
   h0 = normFactor.*( ...
       besselj( nCount + 1/2, kr0 ) + 1i.*bessely( nCount + 1/2, kr0 ) );
   jPlot( nCount + 1 ) = plot( kr, real(h./h0) );
   
   legendStrings{nCount + 1} = ['$n = ', num2str(nCount), '$'];
    
end

% % Set axis to log
% set( gca, 'XScale', 'log' );

% Format
xlabel( '$kr/kr_{0}$', 'FontSize', 18 );
ylabel( '$h_{n}(kr)/h_{n}(kr_{0})$', 'FontSize', 18 );
legend( legendStrings );