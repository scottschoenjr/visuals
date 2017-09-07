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

