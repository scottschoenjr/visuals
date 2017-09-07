% Function to determine the angle at which an image has been rotated
function [ rotationAngle ] = getRotationAngle( image, refImage, anglesToCheck )

% If not specified, use a range of angles with tolerance of 1 degree
deg2rad = pi./180;
if nargin < 3
    anglesToCheck = deg2rad.*( linspace( -30, 30, 200 ) );
end

% Convert images to grayscale
if length( size(image) ) == 3
    image = convertToGrayscale( image );
end
if length( size(refImage) ) == 3
    refImage = convertToGrayscale( refImage );
end

% Convert to doubles to allow maniputation
image = double( image );
refImage = double( refImage );

% Get dimensions of windows
[H0, W0] = size( refImage );
[H, W] = size( image );

% Make images square
image = makeImageSquare( image );
refImage = makeImageSquare( refImage );

% Get dimensions of windows
[D0, H0] = size( refImage );
[D, H] = size( image );

% Resample the reference image to the grid the size of the
% Sample grid of reference image
[h0Grid, w0Grid] = meshgrid( 1:D0, 1:H0 );
% Sample grid we want the reference image on
numHPoints = H;
numWPoints = W;
hPoints = linspace( 1, H0, numHPoints );
wPoints = linspace( 1, W0, numWPoints );
[ hPoints, wPoints ] = meshgrid( hPoints, wPoints );
refImageDownsampled = interp2( ...
    h0Grid, w0Grid, refImage, hPoints, wPoints );

% Step 1 - Apply window
horizontalWindow = tukeywin(H, 0.15); % Default parameter is alpha = 0.5
verticalWindow = tukeywin(W, 0.15);
windowMask = horizontalWindow*verticalWindow';
refImageWindowed = refImageDownsampled.*windowMask;
imageWindowed = image.*windowMask;

%%%%%%%% DEBUG %%%%%%%%%%%
% Plot original and rotated image
figure(999)
subplot( 1, 2, 1 );
pcolor( flipud( refImageWindowed ) );
colormap gray;
shading flat;
axis square;
axis equal;
axis off;
title( 'Reference' );
subplot( 1, 2, 2 );
pcolor( flipud( imageWindowed ) );
colormap gray;
shading flat;
axis square;
axis equal;
axis off;
title( 'Test Image' );
%%%%%%%%%%%%%%%%%%%%%%%

% Step 2 - Compute normalized FFT of each image
imageTransform = fft2( imageWindowed );
% imageTransform = abs( imageTransform )./max( imageTransform(:) );
refTransform = fft2( refImageWindowed );
% refTransform = abs( refTransform )./max( refTransform(:) );

% Step 3a - Get the polar coordinates of the image samples
[hGrid, wGrid] = meshgrid( 1:D, 1:H );
x = hGrid - H./2;
y = wGrid - W./2;
rho = sqrt( x.^(2) + y.^(2) );
rho = rho./max( rho(:) ); % Normalize to 1
theta = atan2( y, x );

% Step 3b - Find the average Fourier coefficients at each angle

% Set radial part of image to correlate over
rho0 = 0.1;
rho1 = 1./sqrt(2);

% Use only ranges in part of image of interest
rhoIndices = find( ...
    ( rho > rho0 ) & ( rho <= rho1 ) ...
    );

% Create zero mask for plotting
zeroMask = 0.*refTransform;
zeroMask( rhoIndices ) = 1;

%%%%%%%% DEBUG %%%%%%%%%%%
% Plot transforms of each image
figure(998)
subplot( 1, 2, 1 );
refT = zeroMask.*refTransform; 
pcolor( 20.*log10(abs(refT)./max(abs(refT(:)))) );
shading flat;
axis square;
axis equal;
axis off;
title( 'Reference' );
% caxis( [-90, -40] );
subplot( 1, 2, 2 );
imgT = zeroMask.*imageTransform; 
pcolor( 20.*log10(abs(imgT)./max(abs(imgT(:)))) );
shading flat;
axis square;
axis equal;
axis off;
title( 'Test Image' );
% caxis( [-90, -40] );
%%%%%%%%%%%%%%%%%%%%%%%

% Create vectors to store average coefficient values
numAngles = length( anglesToCheck );
referenceValues = zeros( 1, numAngles );
rotatedValues = zeros( 1, numAngles );

% Compute average at each angle
for thetaCount = 1:numAngles - 1;
    
    % Find angles in range
    theta0 = anglesToCheck( thetaCount );
    theta1 = anglesToCheck( thetaCount + 1 );
    thetaIndices = find( ...
        ( theta > theta0 ) & ( theta <= theta1 ) ...
        );
    
    % Get subset of points to use
    currentIndices = intersect( thetaIndices, rhoIndices );
    
    % Get the average value of the Fourier coefficients in each the
    % reference and test images
    rotatedValues(thetaCount) = mean( abs( ...
        imageTransform( currentIndices ) ) );
    referenceValues(thetaCount) = mean( abs( ...
        refTransform( currentIndices ) ) );
    
end

% Now, correlate the rotated and referenced values to find the most
% probably rotation angle

%%%%%%% DEBUG %%%%%%%
% Plot for reference
figure(997);
subplot( 2, 1, 1 );
hold all;
plot( anglesToCheck./deg2rad, rotatedValues./max(rotatedValues), 'k' );
plot( anglesToCheck./deg2rad, referenceValues./max(referenceValues), '--k' );
xlim( [min( anglesToCheck ), max( anglesToCheck )]./deg2rad );
ylabel( 'Coefficient Magnitude' );
%%%%%%%%%%%%%%%%%%

% Get correlation
[correlation, delays] = xcorr( rotatedValues, referenceValues );
dTheta = anglesToCheck(2) - anglesToCheck(1);
thetaDelays = delays;
[~, thetaRotIndex] = max( correlation );
rotationAngle = thetaDelays( thetaRotIndex );

%%%%%%% DEBUG %%%%%%%
% Plot for reference
figure(997);
subplot( 2, 1, 2 );
hold all;
plot( delays, correlation./max( abs( correlation ) ),'k' );
xlabel( 'Angle [deg]' );
ylabel( 'Correlation' );
% xlim( [min( anglesToCheck ), max( anglesToCheck )]./deg2rad );
%%%%%%%%%%%%%%%%%%


end

% Subroutine to make image grayscale
function [ grayscaleImage ] = convertToGrayscale( imageToConvert )

% Define colorweights
redWeight = 0.3;
greenWeight = 0.6;
blueWeight = 0.11;

% Convert Image
grayscaleImage = squeeze( (...
    redWeight.*imageToConvert( :, :, 1 ) + ...
    greenWeight.*imageToConvert( :, :, 2 ) + ...
    blueWeight.*imageToConvert( :, :, 3 ) ...
    )./3  );

end

% Function to make image square
function [ croppedImage ] = makeImageSquare( imageToCrop )

% Get dimensions of windows
[height, width, ~] = size( imageToCrop );

% Make sure the image is square
if width > height
    
    % If wider than tall, crop out the sides
    startIndex = ceil( width - height./2 );
    endIndex = floor( width + height./2 );
    
    % Make sure result is in bounds
    startIndex = max( startIndex, 1 );
    endIndex = min( endIndex, width );
    
    % Crop image
    croppedImage = imageToCrop( :, startIndex : endIndex, : );
    
elseif height > width
    
    % If taller than wide, crop out the top and bottom
    startIndex = ceil( height - width./2 );
    endIndex = floor( height + width./2 );
    
    % Make sure result is in bounds
    startIndex = max( startIndex, 1 );
    endIndex = min( endIndex, height );
    
    % Crop image
    croppedImage = imageToCrop( startIndex : endIndex, :, : );
    
else
    % Image is already square
    croppedImage = imageToCrop;
end


end

% References
%   [1] Vandewalle et al. "A Frequency Domain Approach to Registration of
%       Aliased Images with Application to Super-resolution" EURASIP J.
%       Appl. Signal Proc. (2006)