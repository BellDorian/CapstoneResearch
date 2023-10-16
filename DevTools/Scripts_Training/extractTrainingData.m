% ========== Frame Extraction ==========

videoFile = 'D:\myCode\CAPSTONE\Videos\side2\side1_4.mp4';
outputDir = 'D:\myCode\CAPSTONE\Videos\side2\frames\S104\';

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

% ========== Creating Training Data Table ==========

load('Side1_04copy(1).mat', 'gTruth');

labelData = gTruth.ROILabelData.side2_5;

imageFileNames = cell(height(labelData), 1);

for i = 1:height(labelData)
    imageFileNames{i} = sprintf('%sS104frame_%04d.jpg', outputDir, i);
end

trainingData = table(imageFileNames, labelData.Head, labelData.Eyes, labelData.Mouth, labelData.Hands, ...
    'VariableNames', {'imageFilename', 'Face', 'Eyes', 'Mouth', 'Hand'});

for i = 1:height(trainingData)
    trainingData.Face{i} = double(trainingData.Face{i});
    trainingData.Eyes{i} = double(trainingData.Eyes{i});
    trainingData.Mouth{i} = double(trainingData.Mouth{i});
    trainingData.Hand{i} = double(trainingData.Hand{i});
end

disp('Training Data Table created!');