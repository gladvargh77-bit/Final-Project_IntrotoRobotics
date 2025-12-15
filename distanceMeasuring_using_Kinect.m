% Kinect Distance Measurer - Calibrated for your setup
% Based on: 960 raw = 90cm actual

% Calibration ratio from your test
CALIBRATION_RATIO = 90 / 960; % cm per raw unit

% Initialize Kinect v2
kinectObj = videoinput('kinect', 1, 'BGR_1920x1080');
kinectDepth = videoinput('kinect', 2, 'Depth_512x424');

% Start cameras
start(kinectObj);
start(kinectDepth);
pause(2);

% Capture frames
colorImage = getsnapshot(kinectObj);
depthImage = getsnapshot(kinectDepth);

% Stop cameras
stop(kinectObj);
stop(kinectDepth);

% Display
figure;
subplot(1,2,1);
imshow(colorImage);
title('Click on object to measure distance');

subplot(1,2,2);
imshow(depthImage, []);
title('Depth Image');
colorbar;

% Get click
disp('Click on the object you want to measure...');
subplot(1,2,1);
[x, y] = ginput(1);
x = round(x);
y = round(y);

% Convert to depth coordinates
depthX = round(x * 512 / 1920);
depthY = round(y * 424 / 1080);
depthX = max(1, min(depthX, 512));
depthY = max(1, min(depthY, 424));

% Get region around click
regionSize = 5;
xStart = max(1, depthX - regionSize);
xEnd = min(512, depthX + regionSize);
yStart = max(1, depthY - regionSize);
yEnd = min(424, depthY + regionSize);

depthRegion = depthImage(yStart:yEnd, xStart:xEnd);
validDepth = depthRegion(depthRegion > 0);

if ~isempty(validDepth)
    rawValue = mean(validDepth);
    
    % Apply calibration
    distanceCM = rawValue * CALIBRATION_RATIO;
    
    % Mark point
    subplot(1,2,1);
    hold on;
    plot(x, y, 'r+', 'MarkerSize', 20, 'LineWidth', 3);
    hold off;
    
    subplot(1,2,2);
    hold on;
    plot(depthX, depthY, 'r+', 'MarkerSize', 20, 'LineWidth', 3);
    hold off;
    
    % Display results
    fprintf('\n========== DISTANCE MEASUREMENT ==========\n');
    fprintf('Raw Kinect value: %.1f\n', rawValue);
    fprintf('Calculated distance: %.1f cm\n', distanceCM);
    fprintf('==========================================\n\n');
    
    % Show if too close
    if rawValue < 500
        fprintf('WARNING: Object might be too close (< 50cm minimum)\n');
    end
else
    disp('ERROR: No valid depth data at that location.');
    disp('Object might be too close (< 50cm) or depth not detected.');
end

% Cleanup
delete(kinectObj);
delete(kinectDepth);
clear kinectObj kinectDepth;
