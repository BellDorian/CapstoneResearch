% ========== Frame Extraction ==========

videoFile = 'D:\myCode\CAPSTONE\A2_Videos\Side2\side2_3.mp4';
outputDir = 'D:\myCode\CAPSTONE\A2_Videos\Side2\frames\S203\';

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

vidObj = VideoReader(videoFile);

frameNum = 0;
while hasFrame(vidObj)
    frameNum = frameNum + 1;
    frame = readFrame(vidObj);
    
    outputFileName = sprintf('%sS203frame_%04d.jpg', outputDir, frameNum);
    imwrite(frame, outputFileName);
end

disp('Frame extraction complete!');