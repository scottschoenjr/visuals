clear all;
close all;
clc;

T = 1;
t = linspace( - 2.*T, 2.*T, 5000);

f = 0.*t;
testVec = mod( t, T );
f( testVec < 0.25.*T |  testVec > 0.75.*T ) = 1;
f( testVec > 0.25.*T &  testVec < 0.75.*T ) = -1;

% Plot 
figure();
hold on;

% Plot function
plot( t, f, 'k' );
xlim( [-1.1, 1.1].*T );
ylim( [-1.2, 1.2] );
xlabel( '$t$', 'FontSize', 26 );
ylabel( '$f(t)$', 'FontSize', 24 );
set( gca, ...
    'XTick', [-T, -T/2, 0, T/2, T], ...
    'XTickLabel', {'$-T$';'$-T/2$';'0';'$T/2$';'$T$'} ...
    );

% Plot Fourier series
sum = 0.*t;
N = 5;
for n = 1:N
    sum = sum + 3./(n.*pi).*(-1).^(n).*cos( 2.*n.*pi.*t./T );
end
plot( t, sum, '--k' );
