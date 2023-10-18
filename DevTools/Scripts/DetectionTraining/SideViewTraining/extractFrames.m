% ========== Frame Extraction ==========

videoFile = 'D:\myCode\CAPSTONE\A2_Videos\Side1\side1_4.mp4';
outputDir = 'D:\myCode\CAPSTONE\A2_Videos\Side1\frames\S104\';

if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

vidObj = VideoReader(videoFile);

frameNum = 0;
while hasFrame(vidObj)
    frameNum = frameNum + 1;
    frame = readFrame(vidObj);
    
    outputFileName = sprintf('%sS104frame_%04d.jpg', outputDir, frameNum);
    imwrite(frame, outputFileName);
end

disp('Frame extraction complete!');