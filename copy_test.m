clear all
a=arduino;
mc= motorCarrier(a);
m1=dcmotor(mc,"M1");
m2=dcmotor(mc,"M2");

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

% Read WAV file
%{

% Enable Python
pyenv('Version','C:\Users\You\AppData\Local\Programs\Python\Python39\python.exe','ExecutionMode','OutOfProcess')
python -V
python -c "import platform"; 
print(platform.architecture())


% Load Whisper model
whisper = py.importlib.import_module('whisper');
model = whisper.load_model('medium'); % 'small', 'medium', 'large' available

% Transcribe
result = model.transcribe('speech.wav','temperature',0.2);
transcript = string(result.get('text'));
%}


transcript = speech2text(audioData,Fs);
disp(transcript);

% Commenting out all API Stuff 
%{
% reads as chars
audioBase64 = char(matlab.net.base64encode(audioBytes));
disp(audioBase64);

% Build request struct
request = struct( ...
    'config', struct('encoding','LINEAR16','sampleRateHertz',16000,'languageCode','en-US'), ...
    'audio', struct('content', audioBase64) );

% JSON encode
jsonData = jsonencode(request);

% Web options
options = weboptions( ...
    'MediaType', 'application/json', ...
    'ContentType', 'json', ...
    'Timeout', 60 ...
);

% Set API key for authentication
apiKey = 'AIzaSyDZFbkb9L13MWateJ12fbVOaX8FURO9s78';

url = ['https://speech.googleapis.com/v1/speech:recognize?key=' apiKey];

% Send POST request
try
   response = webwrite(url, jsonData, options);   % send JSON string, not struct
   disp(response)
catch ME
    disp(ME.message)
    if isfield(ME,'stack'); disp(ME.stack(1)); end
    try
        body = webread(url, jsonData, options);
        disp(body)
    catch innerME
        disp('webread also failed:'); disp(innerME.message)
    end
end


if isfield(response, 'results')
    recognizedText = response.results{1}.alternatives{1}.transcript;
    disp(['Recognized Text: ' recognizedText]);
else
    recognizedText = '';
    disp('No speech recognized.');
end

% --- Send to OWI Arm (Arduino) ---
port = 'COM3'; baud = 9600;
arduino = serialport(port, baud);

if ~isempty(recognizedText)
    write(arduino, recognizedText, "string");
    disp('Text sent to microcontroller.');
else
    disp('No text to send.');
end
%}

% Clean up the audio recorder object
clear recObj;
if isempty(transcript)
      % handle empty result, e.g. return empty transcript or retry
end

% Arduino Setup


while(1)
    baseLeft(m1)
    pause(3);
    baseRight(m1)
    pause(3);

    shoulderUp(m2);
    pause(3);
    shoulderDown(m2);
    pause(3);
end