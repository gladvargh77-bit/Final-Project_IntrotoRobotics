%a=arduino

%{
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
disp(transcript)
%}



while(1)
  writeDigitalPin(a, 'D13', 1);
  writeDigitalPin(a, 'D12', 0);
  writePWMDutyCycle(a, 'D11', 1);
  pause(2);
  writeDigitalPin(a, 'D13', 0);
  writeDigitalPin(a, 'D12', 1);
  writePWMDutyCycle(a, 'D11', 0);
  pause(2);
end