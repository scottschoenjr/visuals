% Script to fit Gaussian distribution to image
%
%

clear all;
close all;
clc;

imageFile = 'testImages/test.png';

% Import test image and convert to intensity
image = imread( imageFile );
grayscaleImage = double( convertToGrayscale( image ) );

% Find maximum intenstity
[maxValue, maxIndex] = max( grayscaleImage(:) );

% Get indices of that max value
[ imgWidth, imgHeight ] = size( grayscaleImage );
[maxRow, maxCol] = ind2sub( size( grayscaleImage ), maxIndex );

% Get FWHM in each direction
axialSlice = grayscaleImage( maxRow, : );
transverseSlice = grayscaleImage( :, maxCol );

axialSigma = fwhm( axialSlice, 1 );
transverseSigma = fwhm( transverseSlice, 1 );

sigma = min( [ axialSigma, transverseSigma ] );

% Create 2D gaussian function
[x, y] = meshgrid( 1:imgHeight, 1:imgWidth );
fit = exp( -( ...
    ( (x - maxCol).^(2) )./( 2.*sigma.^(2) ) + ...
    ( (y - maxRow).^(2) )./( 2.*sigma.^(2) ) ...
    ) );


% Create guassian fit there
figure();

subplot( 1, 2, 1 );
pcolor( grayscaleImage );
shading flat;

subplot( 1, 2, 2 );
pcolor( fit );
shading flat;







