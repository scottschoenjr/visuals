clear all;
close all;
clc;

% Power delivery to transducer
% Since manual recommends max 125 mW, use this to compute appropriate
% parameters for CW excitation.

% Set parameter ranges
appliedVoltage = logspace( -3, 2, 500 ); % [V] Peak-to-Peak

% Known transducer properties
f0 = 3.5E6; % [Hz]
maxPower = 125E-3; % [W]
repetitionRate = 1/0.01; % [Hz]

% Assumed transducer properties. These could be found on the impedance
% plot, but I don't think we have one.
phaseAngle = 0; % [rad]
impedance = 50;     % [ohm]

% Calculate RMS voltage
Vrms = (sqrt(2)./2).*appliedVoltage; % Eqn. 18
dutyCycle = impedance.*maxPower./ ( Vrms.^(2).*cos(phaseAngle) ); % Eqn. 19
maxCycles = f0.*dutyCycle./repetitionRate;

figure()
loglog( appliedVoltage, maxCycles, 'k' );
xlabel( 'Voltage [V]' );
ylabel( 'Max Cycles per Burst' );




