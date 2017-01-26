%**************************************************************************
%
% ASA Reconstruction Visualizer
%
%   Function plots shows a visualization of angular spectrum
%   reconstruction.
%
%              Scott Schoen Jr | Georgia Tech | 20170110
%
%**************************************************************************

clear all
close all
clc

% Set frequency of source
f0 = 6E3; % [Hz]
omega = 2.*pi.*f0;
c0 = 343; % [m/s]
k0 = omega./c0;
lambda0 = c0./f0;

% Set dimensions
sourcePlaneWidth = 0.5; % [m]
Nx = 2^(10);
reconstructionDepth = 0.5; % [m]

% Create spatial distribution at source location
xVector = linspace( -sourcePlaneWidth./2, sourcePlaneWidth./2, Nx );
sigma = 0.05;
A = exp( -(xVector - 0.05).^(2)./sigma.^(2) ) ...
    + sin( 3.*pi.*xVector./sourcePlaneWidth ) ...
    + sin( 7.9.*pi.*xVector./sourcePlaneWidth );
A = abs(A)./max(abs(A));

% Get angular spectrum at source plane
AS0 = fftshift( fft(A) );

% Now create wavenumber vector
dx = xVector(2) - xVector(1);
dkx = 2.*pi./dx;
lengthIndex = floor( length(xVector)./2 );
kxVector = (1./Nx).*(-lengthIndex : lengthIndex ).*dkx;

% Create vector for plotting 
% xPlot = linspace( -1E3.*sourcePlaneWidth, 1E3.*sourcePlaneWidth, 2E3.*Nx );
xPlot = linspace( -sourcePlaneWidth, sourcePlaneWidth, Nx );
zPlot = linspace( -reconstructionDepth, 0, Nx );
[xP, zP] = meshgrid( xPlot, zPlot );

% Create vector to hold sum of contributions at each frequency
sumOfContributions = 0.*xPlot;

% Store to output vectors
thetaVec = acos( kxVector(1:end-1)./k0 );
thetaVec( imag(thetaVec) ~= 0 ) = NaN; % For plotting
ampVec = abs( AS0 );
phaseVec = angle( AS0 );

% Variable to hold movie
M = [];

% Create figure
figure(1)
set( gcf, 'Position', [50, 75, 1800, 900] );

needToCreateAxes = 1;

% Create axes to plot summation of components at z = 0
summationAxes = axes();
set( summationAxes, 'Position', [0.12, 0.72, 0.5, 0.2] );
ylim( [-0.2, 1.05] );
xlim( [min(xVector), max(xVector)] );
set( gca, 'YTick', 0:0.5:1, 'XTick', [] );
hold all;
box on;
% Plot source signal
plot( xVector, A, '--b', 'LineWidth', 1.6 );

% Create axes for amplitude and phase of the angular spectrum
asMagnitudeAxes = axes();
set( asMagnitudeAxes, 'Position', [0.7, 0.5, 0.25, 0.3], ...
    'XTickLabel', '');
hold all;
box on;
% Plot amplitude
plot( asMagnitudeAxes, thetaVec.*180./pi, ampVec./Nx, 'k' );
ylabel( 'Amplitude [AU]' );
ylim( [-0.02, 0.2] );
xlim([0, 180]);
set( gca, 'XTick', [0, 45, 90, 135, 180] );
title( '$\mathcal{A}_{\tilde{p}}$', 'FontSize', 26 );

asPhaseAxes = axes();
set( asPhaseAxes, 'Position', [0.7, 0.2, 0.25, 0.3] );
hold all;
box on;

% Plot Phase
plot( asPhaseAxes, thetaVec.*180./pi, phaseVec, 'k' );

xlim([0, 180]);
ylabel('Phase [rad]');
ylim( 1.05.*[-pi, pi] );
ax = gca;
ax.YTick = [-pi, -pi/2, 0, pi/2, pi];
ax.YTickLabel = ...
    {'$-\pi$';'$-\frac{\pi}{2}$';'$0$';'$\frac{\pi}{2}$';'$\pi$'};
ax.XTick = [0, 45, 90, 135, 180];
xlabel( '$\theta_{x}$ [deg]' );

% Loop from end so we're increasing theta
for kxCount = Nx:-1:1
    
    % Get angle of propagation for this spatial frequency
    kx = kxVector( kxCount );
    kz = sqrt( k0.^(2) - kx.^(2) );
    
    % Delete old current contribution line (whther or not we'll plot a new
    % one)
    existingContributionLine = ...
        findobj( 'Tag', 'currentContribtutionLine' );
    contributionLineExists = ~isempty( existingContributionLine );
    if contributionLineExists
        delete(currentContribution); 
    end
    
    if isreal( kz )
        
        % Get propagation angle
        theta = acos( kx./k0 );
        
        % Get magnitude and phase of this contribution
        amplitude = abs( AS0( kxCount ) )./Nx;
        phi = mod( angle( AS0( kxCount ) ), 2.*pi );
        
        % Get component of phase in x
        xPhase = phi./cos(theta);
        
        % Create the wavefront axes
        % For some reason doing this outside the loop caused the colorplot
        % to be all black until you clicked on it, and then it would start
        % updating.
        if needToCreateAxes
            
            waveFrontAxes = axes();
            set( waveFrontAxes, 'Position', [0.12, 0.12, 0.5, 0.6] );
            hold all;
            box on;
            
            ylim( [-reconstructionDepth, 0] );
            ylabel( '$z$-Position [m]', 'FontSize', 22 );
            
            xlim( [min(xVector), max(xVector)] );
            xlabel( '$x$-Position [m]', 'FontSize', 22 );
            
            % Set flag so we only do this once
            needToCreateAxes = 0;
            
        end
        
        % Plot wavefield for this frequency kz
        pField = amplitude.*exp( 1j.*(kx.*xP + kz.*zP + phi ) );
        pcolor( waveFrontAxes, xP, zP, real( pField ) );
        shading flat;
        normValue = 0.2;
        caxis( [-normValue, normValue] );
        
        % Get contribution of this spatial frequency
        yPlot = amplitude.*real( exp( 1j.*(kx.*(xPlot - sourcePlaneWidth./2) + phi) ) );

        
        % Also plot in gray to remain on plot
        previousContributions = plot( summationAxes, ...
            xPlot, yPlot, ...
            'Color', 0.6.*[1, 1, 1], ...
            'LineWidth', 1 );
        
        % Add into summation and plot that
        sumOfContributions = sumOfContributions + yPlot;
        if exist('sumLine', 'var')
            delete(sumLine); % Delete old one
        end
        sumLine = plot( summationAxes, ...
            xPlot, sumOfContributions, 'b', ...
            'LineWidth', 1.2 ); % Plot new one
        
        % Plot spatial contribution on summation axes
        currentContribution = plot( summationAxes, ...
            xPlot, yPlot, 'k', 'Tag', 'currentContribtutionLine' );
        
        % Display the current angle
        titleString = sprintf( ...
            '$\\theta_{x} = %3d^{\\circ}$', round(180.*theta./pi) );
        title( summationAxes, titleString );
        
        % Plot indicator on angluar spectrum plots
        currentIndicators = findobj( 'Tag', 'ASIndicator' );
        if ~isempty( currentIndicators );
            delete( currentIndicators );
        end
        plot( asMagnitudeAxes, ...
            thetaVec(kxCount).*180./pi, ampVec(kxCount)./Nx, ...
            'ro', 'Tag', 'ASIndicator' );
        plot( asPhaseAxes, ...
            thetaVec(kxCount).*180./pi, phaseVec(kxCount), ...
            'ro', 'Tag', 'ASIndicator' );
        
        % Save the frame
        drawnow;
        M = [M, getframe(gcf)];
        
    end
    
end
