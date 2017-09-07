clear all
close all
clc

x = linspace(0, 4, 500 );

y = ( cos(x) ).^(2);

% Intersection point
x0 = 2.9751;
m = -2.*sin( x0 ).*cos( x0 );
tangentLine = m.*x;

figure();
hold on;
plot( x, -2.*sin(x).*cos(x) );
xlabel( '$x$', 'FontSize', 26 );
ylabel( '$y''$', 'FontSize', 26 );

figure();
hold on;
plot( x, y, 'k', 'LineWidth', 3 );
plot( x, tangentLine, '--k' );
xlabel( '$x$', 'FontSize', 26 );
ylabel( '$y$', 'FontSize', 26 );
xlim( [0, 4] );
ylim( [0, 1.2] );
box on;
