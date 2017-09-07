clear all
close all
clc

% Read in audio and reset sampling frequency/time vector
img = imread( 'raven.jpg' );
img = rgb2gray( img );

imgWidth = length( img(:, 1, 1) );
imgHeight = length( img( 1, :, 1 ) );

% Normalize to length 1;
Lx = 1;
Ly = (imgHeight./imgWidth);

% Sampling frequencies
dfx = Lx./imgWidth;
dfy = Ly./imgHeight;

% Get spatial sampling vectors
kx = 2.*pi.*dfx.*( -(imgWidth - 1)./2 : 1 : (imgWidth - 1)./2 );
ky = 2.*pi.*dfy.*( -(imgHeight - 1)./2 : 1 : (imgHeight - 1)./2 );
[ky, kx ] = meshgrid( ky, kx );

% Create band-limited signal
k = sqrt( kx.^(2) + ky.^(2) );
kMax = 0.95*max( k(:) );

% Take spatial transform
imgTildePlot = fftshift( fft2( img ) );

% Reconstruct iamge signal with those frequencies
fIndicesToDiscard = find( k >= kMax );
imgTilde = fft2(img);
imgTilde( fIndicesToDiscard ) = 0;
imgRecon = real( ifft2( imgTilde ) );

% Plot image and transform
figure()
set( gcf, 'Position', [50, 50, 1000, 800] );

subplot( 3, 2, 1 );
imagesc( img );
axis equal;
colormap('bone');
axis off;

subplot( 3, 2, 2 );
imagesc( imgRecon );
axis equal;
colormap('bone');
axis off;

subplot( 3, 2, 3:6);
hold all;
pcolor(  kx, ky, 20.*log10(abs(imgTildePlot)) );
xlabel( '$k_{x}$ [m$^{-1}$]', 'FontSize', 22 );
ylabel( '$k_{y}$ [m$^{-1}$]', 'FontSize', 22 );
colormap('parula');
shading flat;

% Plot limit circle
t = linspace( 0, 2.*pi, 100 );
xVec = 0.5.*cos( t );
yVec = 0.5.*sin( t );
plot( xVec, yVec, 'w--' );

xlim( [min(min(kx)), max(max(kx))] );
ylim( [min(min(ky)), max(max(ky))] );

%
%    % Normalize so they're all the same volume
%    currentS = currentS./max(abs(currentS));
%    totalSignal = [totalSignal; currentS];
%    
%    % Add a 1 s pause between
%    
%    silence = zeros( 1, Fs./2 );
%    totalSignal = [totalSignal; silence'];
%    
% end
% 
% % Write result to audio file
% audiowrite( 'test.wav', totalSignal, Fs );
% 
