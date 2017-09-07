clear all
close all
clc

addpath( './sht' );
addpath( 'C:/MATLAB/inc/sjs' );

% Helper function to convert directions from Matlab's azimuth-elevation to
% azimuth-inclination
aziElev2aziIncl = @(dirs) [dirs(:,1) pi/2-dirs(:,2)];

% Set order
N = 22;

% Set initial and final radii
r0 = 0.05;
r = 2;

% Set source frequency and sound speed
c0 = 1500; % [m/s]
f = 1E6; % [Hz]
omega = 2.*pi.*f;
k = omega./c0;

% Define coordinate space
thetaRes = 6; % [deg]
phiRes = 6;
angleGrid = grid2dirs( thetaRes, phiRes ); % Rectangular grid

% Create function on sphere
phi = angleGrid( :, 1 );
theta = angleGrid( :, 2 );

% orientation of mainlobe
theta0 = pi/2;
phi0 = pi/4;
F0 = (1/2).^(N).*( 1 + ...
    cos(theta).*cos(theta0) + sin(theta).*sin(phi0).*cos(phi - phi0) ...
    ).^(N);
F0 = sin( theta ).*cos( 4.*phi );

% Plot for reference
[thetaPlot, phiPlot] = meshgrid( theta, phi );
% FPlot = (1/2).^(N).*( 1 + ...
%     cos(thetaPlot).*cos(theta0) + sin(thetaPlot).*sin(phi0).*cos(phiPlot - phi0) ...
%     ).^(N);
FPlot = sin( thetaPlot ).*cos( 4.*phiPlot );
rPlot = r0 + zeros( size(FPlot) );
x = abs(rPlot).*sin(thetaPlot).*cos(phiPlot);
y = abs(rPlot).*sin(thetaPlot).*sin(phiPlot);
z = abs(rPlot).*cos(thetaPlot);

% Plot original function
figure()
harmonicPlot = surf(x, y, z, double(real(FPlot)));
shading interp;
colorbar;
view(40,30); % adjust camera view
camlight left;
camlight right;
lighting none;
axis equal;

% Get integration weights, since areas will not have equal sizes
tic;
weights = getVoronoiWeights(aziElev2aziIncl(angleGrid));
disp( ['Weight Computations took ', num2str(toc), ' s.'] );

% Check regularity
cond_N_reg = checkCondNumberSHT( N, angleGrid, 'complex', weights );

% Perform SHT for the regular grid using weighted least-squares and complex SHs
tic;
S_F0 = leastSquaresSHT(N, F0, angleGrid, 'complex', weights);
S_F = 0.*S_F0;
disp( ['Forward transform took ', num2str(toc), ' s.'] );

% Multiply by the trasnfer function to propagate to the desired radius
nIndex = 1;
Hvec = zeros( 1, N );
for nCount = 1:N
    
    n = nCount - 1;
    
    % Compute transfer function
    [jn, yn] = sphBessel( k.*r, n );
    hn = jn + 1i.*yn;
    [jn0, yn0] = sphBessel( k.*r0, n );
    hn0 = jn0 + 1i.*yn0;
    H = hn./hn0;
    
    Hvec( nCount ) = H;
    
    % Multiply corresponding m's by transfer function
    m = -n : n;
    mStartIndex = nIndex;
    mEndIndex = nIndex + length(m) - 1;
    mIndices = (mStartIndex : mEndIndex);
    S_F( mIndices ) = H.*S_F0( mIndices );
    
    % Increment index
    nIndex = mEndIndex + 1;
    
end


% Transform back
tic;
F_Recon = inverseSHT( S_F, angleGrid, 'complex' );
disp( ['Inverse transform took ', num2str(toc), ' s.'] );

plotShReconstruction( S_F, 'complex', phiRes, thetaRes, r );
% caxis( [-1, 1] );

% % % Plot reconstructed function
% figure()
% reconPlot = surf(x, y, z, double(real(F0_Recon)));
% shading flat;
%
% % adjust camera view
% view(40,30);
% camlight left;
% camlight right;
% lighting none;
% axis equal;

