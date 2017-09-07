% Simposon's Rule

clear all;
close all;
clc;

% Define function
f = @(x) x.^(3);

% Define interval
xMin = 0;
xMax = 2;
numIntervals = 4;
partialSums = zeros( 1, numIntervals );

% Define evaluation points
xEval = linspace( xMin, xMax, numIntervals + 1 );

for intervalCount = 1:numIntervals
    
   %  Get f at the start, end, and midpoints
   a = xEval( intervalCount );
   b = xEval( intervalCount + 1);
   c = (a + b)./2;
   fa = f(a);
   fb = f(b);
   fc = f(c);
   
   % Compute partial sum
   S = ((b - a)./6).*( fa + 4.*fc + fb );
   partialSums( intervalCount ) = S;
    
end

% Return total over interval
intValue = sum( partialSums )