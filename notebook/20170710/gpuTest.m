% Testing GPU processing

% Define array in workspace
x = rand( 1, 1E6 );

% Time operation with cpu
tic;
y = fft(x);
disp( [ 'CPU computation time: ', num2str(1E3.*toc), ' ms.' ] );

% Time operation with GPU
tic;
xG = gpuArray(x);
yG = fft(xG);
yG = gather( yG );
disp( [ 'GPU computation time: ', num2str(1E3.*toc), ' ms.' ] );