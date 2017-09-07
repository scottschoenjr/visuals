% Problem 4

clear all
close all
clc

tau = linspace( 0, 1, 1000 );

tVals = [0.1, 0.11, 0.12];

fc = 50;
omegac = 2.*pi.*fc;

for tCount = 1:length( tVals )
    
    t = tVals( tCount );
    
   % Define delay function
   R = cos( omegac.*(t + tau/2) ).*cos( omegac.*(t - tau/2 ) );
   
   % Define W
   W = fft( R );
   
   % Plot both
   figure(111)
      
   subplot( 2, 1, 1 );
   hold on;
   plot( tau, R );
   
   subplot( 2, 1, 2 );
   hold on;
   plot( abs( W ) );
    
end

subplot( 2, 1, 1 );
xlabel( '$\tau$', 'FontSize', 22 );
ylabel( '$R$', 'FontSize', 16 );

subplot( 2, 1, 2 );
plot( abs( W ) );
xlabel( '$\omega$', 'FontSize', 22 );
ylabel( '$W$', 'FontSize', 16 );


