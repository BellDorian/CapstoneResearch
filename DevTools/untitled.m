% Define the video file path and the output directory for the frames
videoFile = 'D:\myCode\CAPSTONE\Videos\side1\side1_5.mp4';
outputDir = 'D:\myCode\CAPSTONE\Videos\side1\frames\S105';

% Check if output directory exists, if not, create it
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

% Setup the VideoReader object
vidObj = VideoReader(videoFile);

% Iterate through the video, one frame at a time
frameNum = 0;
while hasFrame(vidObj)
    frameNum = frameNum + 1;
    frame = readFrame(vidObj);
    
    % Construct the output image filename
    outputFileName = sprintf('%sframe_%04d.jpg', outputDir, frameNum);
    
    % Save the frame as an image
    imwrite(frame, outputFileName);
end

disp('Frame extraction complete!');
