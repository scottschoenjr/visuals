clear all
close all
clc

rad2deg = 180./pi;

% Define vectors
theta = linspace( 0, pi, 100 );
phi = linspace( 0, 2.*pi, 200 );

% Get resolution
thetaRes = rad2deg.*( ( max(theta) - min(theta) )./length(theta) );
phiRes = rad2deg.*( ( max(phi) - min(phi) )./length(phi) );

[theta, phi ] = meshgrid(theta, phi);

% Define function
A = sin(theta).*cos( 2.*pi.*5.*phi );

plotSphFunctionCoeffs(A, 'complex', phiRes, thetaRes, 'complex')
%PLOTSPHFUNCTIONGRID Plots a spherical function defined on a grid
%
%   F_N:  (N+1)^2 vector of SH coefficients
%   basisType:  {'real','complex'} SH basis type for the coefficients
%   aziRes: grid resolution at azimuth (degrees)
%   polarRes: grid resolution in elevation (degrees)
%   realComplex: {'real','complex'} if the function is real then it is
%                plotted with blue for its positive part and red for
%                its negative part. If it is complex, the magnitude
%                function is plotted, with its phase mapped on the colormap
%   h_ax: optional argument to define an axis handle for the plot,
%         otherwise the new axis handle is returned
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Archontis Politis, 20/02/2015   
%   archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%