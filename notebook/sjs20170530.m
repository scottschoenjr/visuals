clear all
close all
clc

nPoints = 1024;
thetaVec = linspace( 0, 2.*pi, nPoints );
thetaWidth = pi./4;
thetaCenter = pi;
oneIndices = find( ...
    (thetaVec > thetaCenter - thetaWidth./2) & ...
    (thetaVec < thetaCenter + thetaWidth./2)   ...
    );

% Create f for non-zero indices
x = oneIndices - oneIndices(1) - floor(length( oneIndices )./2);
x = x./length(x);
f = 0 + 2;
% f = sin(20.*x);

p = 0.*thetaVec;
p( oneIndices ) = f;

% Take fft
S = fft( p );
m = 0:nPoints - 1;

% Plot
figure()
subplot( 2, 1, 1 );
plot( thetaVec, abs(p) );
xlim( [0, 2.*pi] );
xlabel( '$\theta$', 'FontSize', 24);
set( gca, ...
    'XTick', [0, pi./2, pi, 3.*pi./2, 2.*pi], ...
    'XTickLabel', ...
        {'$0$';'$\pi/2$';'$\pi$';'$3\pi/2$';'$2\pi$'} );
ylabel('$|\tilde{p}(\theta)|$', 'FontSize', 22 );

subplot( 2, 1, 2 );
plot( m, abs( S ) );
xlim( [0, max(m)./2] );
xlabel( '$m$', 'FontSize', 24 );
ylabel('$|\mathcal{S}_{\tilde{p}}(m)|$', 'FontSize', 22 );