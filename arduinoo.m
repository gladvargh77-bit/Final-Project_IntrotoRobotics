%% --- Speech to Text and Send to Arduino ---

% Load ASR model
load("asr-wav2vec2-librispeech.mat");

%% --- Record Audio ---
Fs = 44100; nBits = 16; nChannels = 1;
recObj = audiorecorder(Fs, nBits, nChannels);
disp('Start speaking...');
recordblocking(recObj, 5);
disp('Recording finished.');

audioData = getaudiodata(recObj);
audiowrite('speech.wav', audioData, Fs);
disp('Audio saved. Running speech recognition...');

%% --- Speech to Text ---
transcript = speech2text(audioData, Fs);
disp("Recognized text: " + transcript);

clear recObj;  % clean up recorder

%% --- Send Text to Arduino & Receive Confirmation ---

port = "COM3";      % << change if needed
baud = 9600;

% Open serial connection
arduino = serialport(port, baud);

pause(2);   % allow Arduino Nano to reset after connection

if ~isempty(transcript)
    % Send line of text to Arduino
    writeline(arduino, transcript);
    disp("Text sent to Arduino.");
else
    disp("No speech recognized. Nothing sent.");
end

%% --- Read Arduino Echo Response ---

pause(0.1); % small delay to allow Arduino to reply

while arduino.NumBytesAvailable > 0
    reply = readline(arduino);
    disp("Arduino replied: " + reply);
end

%% --- Done ---
disp("MATLAB speech → Arduino communication complete.");
