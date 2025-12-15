% Speech-to-Text and Serial Send
load("asr-wav2vec2-librispeech.mat");

Fs = 44100; nBits = 16; nChannels = 1;
recObj = audiorecorder(Fs, nBits, nChannels);

disp('Start speaking...');
recordblocking(recObj, 5);
disp('Recording finished.');

audioData = getaudiodata(recObj);
audiowrite('speech.wav', audioData, Fs);

disp('Audio data recorded and saved.');

% Speech Recognition
transcript = speech2text(audioData, Fs);
disp("Recognized text:");
disp(transcript);

clear recObj;

if isempty(transcript)
    disp("No speech detected");
    return;
end

%% Arduino Serial Control with Confirmation

command = lower(strtrim(transcript));

disp("--------------------------------------------------");
disp("Recognized word:");
disp(command);

% Connect to Arduino
a = serialport("COM7", 9600);
pause(2);   % Allow Arduino to reset

% Read READY message
if a.NumBytesAvailable > 0
    disp("Arduino says:");
    disp(readline(a));
end

% Send command
writeline(a, command);
disp("✔ Command sent to Arduino");

pause(0.5); % Give Arduino time to respond

% Read all Arduino responses
while a.NumBytesAvailable > 0
    disp("Arduino response:");
    disp(readline(a));
end

disp("--------------------------------------------------");

clear a

