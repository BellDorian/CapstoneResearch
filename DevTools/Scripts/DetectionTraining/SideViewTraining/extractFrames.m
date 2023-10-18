% ========== Frame Extraction ==========

videoFile = 'D:\myCode\CAPSTONE\A2_Videos\Side1\Side1_01.mp4';
outputDir = 'D:\myCode\CAPSTONE\A2_Videos\Side1\frames\S101\';

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

vidObj = VideoReader(videoFile);

frameNum = 0;
while hasFrame(vidObj)
    frameNum = frameNum + 1;
    frame = readFrame(vidObj);
    
    outputFileName = sprintf('%sS101frame_%04d.jpg', outputDir, frameNum);
    imwrite(frame, outputFileName);
end

disp('Frame extraction complete!');

