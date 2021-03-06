%**************************************************************************
%
% Fourier Transform Reconstruction Visualizer - Audio Playback
%
%   Function plays audio. Callback executed on button press in main window.
%
% Inputs
%   audioData - Time series of audio data
%   Fs        - Sampling rate [Hz]
%
% Outputs
%   [none]
%
%              Scott Schoen Jr | Georgia Tech | 20170127
%
%**************************************************************************

function [] = playAudio( src, evt, audioData, Fs )

try
    
    % Get an audioplayer object for the signal
    playerObject = audioplayer(audioData, Fs);
    
    % Playback the signal
    playblocking( playerObject );
    
catch
    
    % Warn user 
    warndlg( ...
        [ 'Couldn''t play audio.' ], ...
        'Acoustic Playback Failed :(' ...
        );
    
end

end
