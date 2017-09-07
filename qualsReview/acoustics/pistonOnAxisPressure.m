% On-axis field for circular piston

clear all
close all
clc

% Piezo element
rho0 = 1000; % [kg/m^3]
c0 = 1482; % [m/s]
u0 = 20E-6; % [m] 
f0 = 3.5E6; % [Hz]
R = 5E-3; % [m]

% Define variables
z = linspace( 25E-3, 500E-3, 10000);
k = 2.*pi.*f0./c0;

% Define pressure amplitude
z1 = sqrt( R.^(2) + z.^(2) );
p = rho0.*c0.*u0.*( exp(1i.*k.*z) - exp( 1i.*k.*z1 ) );

% Plot as a function of z
plot( z.*1E3, abs(p)./max(abs(p)), 'k' );
xlabel( '$z$-Position [mm]', 'FontSize', 22 );
xlim( [25, 500] );
ylabel( 'Normalized $|p(z)|$', 'FontSize', 22 );