% Script to test image registration for super-resolution techniques
%
%

clear all;
close all;
clc;

imageFile = 'gtLogo512.png';

% Import test image
refImage = imread( imageFile );
% Rotated image
testImage = imrotate( imread( imageFile ), -10, 'bicubic', 'crop' );

% % Quick compare
% figure()
% subplot( 1, 2, 1 );
% image( refImage );
% axis square;
% axis equal;
% axis off;
% subplot( 1, 2, 2 );
% image( testImage );
% colormap gray;
% axis square;
% axis equal;
% axis off;

% Get rotation angle
theta = getRotationAngle( testImage, refImage )




