% Trapezoidal rule

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

   fa = f(a);
   fb = f(b);
   
   % Compute partial sum
   S = ((fa + fb)./2).*( b - a );
   partialSums( intervalCount ) = S;
    
end

% Return total over interval
intValue = sum( partialSums )