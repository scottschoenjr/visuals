% Plot transmission through shell

clear all;
close all;
clc;

dB2Np = 20./log(10);

% Set shell parameters
r1 = 20E-3; % [m]
r2 = 24E-3;
cb = 6000;
rhob = 1000;

% Set source parameters
fVector = linspace( 100E3, 5E6, 1E4 );

% Set inside and outside parameters
ca = 1500; % Water
rhoa = 1000;
cc = 1500; % Water
rhoc = 1000;

% Compute Impedance Ratio
Za = rhoa.*ca;
Zb = rhob.*cb;
Zc = rhoc.*cc;

% Compute transmission coefficient for each frequency
tCoeffs = 0.*fVector;
tCoeffsThin = 0.*fVector;
for fCount = 1:length( fVector )
    
   omega = 2.*pi.*fVector(fCount);
   tCoeffs( fCount ) = ...
       shellTransmission( ca, rhoa, cb, rhob, cc, rhoc, r1, r2, omega );
   
      tCoeffsThin( fCount ) = ...
       shellTransmission( ca, rhoa, cb, rhob, cc, rhoc, r1, r2 - 2E-3, omega );
    
end

% Plot result
d = r2 - r1;
kd = (2.*pi*fVector./cb).*d; % In layer

figure();
hold all;
plot( fVector./1E6, abs(tCoeffs), 'k' );
plot( fVector./1E6, abs(tCoeffsThin), '--k' );
xlabel('$f$ [MHz]', 'FontSize', 24);
ylabel('$|\mathcal{T}|$', 'FontSize', 28 );
% xlim([0, 10]);
ylim( [0, 1.05]);
impedanceRatio = abs( Za./Zb );
title( sprintf( '$|Z_{a}/Z_{b}|$ = %3.1f', impedanceRatio ) );
legH = legend( ' $d = 4~{\rm mm}$', ' $d = 2~{\rm mm}$' );
set( legH, 'FontSize', 22 );
box on;

figure()
plot( real(kd), angle(tCoeffs), 'k' );
xlabel('$k_{\rm shell}d$', 'FontSize', 24);
ylabel('$\angle\mathcal{T}$', 'FontSize', 28 );
ylim( [-pi, pi]);


