% Speech-to-Text and Serial Send
load("asr-wav2vec2-librispeech.mat");
%load("C:\Users\Owner\Documents\MATLAB\enhanceSpeech\metricgan-okd.mat");

Fs = 44100; nBits = 16; nChannels = 1;
recObj = audiorecorder(Fs, nBits, nChannels);
disp('Start speaking...');
recordblocking(recObj, 5);
disp('Recording finished.');
audioData = getaudiodata(recObj);
audiowrite('speech.wav', audioData, Fs);
% Prepare for audio processing
disp('Audio data recorded and saved. Preparing to send for recognition...');

transcript = speech2text(audioData,Fs);
disp(transcript);

% Clean up the audio recorder object
clear recObj;
if isempty(transcript)
      % handle empty result, e.g. return empty transcript or retry
end

% Arduino Setup
arduinosetup