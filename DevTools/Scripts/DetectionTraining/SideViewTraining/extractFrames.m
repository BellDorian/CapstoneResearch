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

%=========== extract table data============
load('Side1_01.mat', 'side1_1var');

labelData = side1_1var.ROILabelData.side1_1;

imageFileNames = cell(height(labelData), 1);

for i = 1:height(labelData)
    imageFileNames{i} = sprintf('%sS101frame_%04d.jpg', outputDir, i);
end

% Initialize empty cell arrays for storing bounding boxes
HandsBB = cell(height(labelData), 1);
EyesBB = cell(height(labelData), 1);
FaceBB = cell(height(labelData), 1);
MouthBB = cell(height(labelData), 1);

% Extract the bounding boxes from labelData
for i = 1:height(labelData)
    HandsBB{i} = labelData.Hands{i};
    EyesBB{i} = labelData.Eyes{i};
    FaceBB{i} = labelData.Face{i};
    MouthBB{i} = labelData.Mouth{i};
end

trainingData = table(imageFileNames, HandsBB, EyesBB, FaceBB, MouthBB, ...
    'VariableNames', {'imageFilename', 'Hand', 'Eyes', 'Face', 'Mouth'});

disp('Training Data Table created!');

% ========== Training the R-CNN Object Detectors ==========

% Specify the pretrained CNN model
pretrainedCNN = 'resnet50';

% Define training options with GPU usage
options = trainingOptions('sgdm', ...
    'ExecutionEnvironment', 'gpu', ...
    'MiniBatchSize', 64, ...
    'InitialLearnRate', 1e-3, ... 
    'MaxEpochs', 2, ...
    'Verbose', true);

% Train R-CNN object detector for Face, Eyes, and Mouth
faceEyesMouthTrainingData = trainingData(:, {'imageFilename', 'Face', 'Eyes', 'Mouth'});
faceEyesMouthDetector = trainRCNNObjectDetector(faceEyesMouthTrainingData, pretrainedCNN, options, ...
    'NegativeOverlapRange', [0 0.3], 'PositiveOverlapRange', [0.5 1]);

% Train R-CNN object detector for Hand
handTrainingData = trainingData(:, {'imageFilename', 'Hand'});
handDetector = trainRCNNObjectDetector(handTrainingData, pretrainedCNN, options, ...
    'NegativeOverlapRange', [0 0.3], 'PositiveOverlapRange', [0.5 1]);

% ========== Save the Trained Detectors ==========

save('trainedFaceDetector_S101.mat', 'faceEyesMouthDetector');
save('trainedHandDetector_S101.mat', 'handDetector');

disp('Training and evaluation complete!');

%=========== Gather data and write to excel file ==========
splitRatio = 0.8;

% --- Face Detection & Evaluation ---
disp('Gathering Face, Eyes, Mouth detection data');
processDetection(faceEyesMouthTrainingData, faceEyesMouthDetector, 'faceDetectionResults_S101.xlsx', splitRatio);

% --- Hand Detection & Evaluation ---
disp('Gathering Hand detection data');
processDetection(handTrainingData, handDetector, 'handDetectionResults_S101.xlsx', splitRatio);

function processDetection(trainingData, detector, outputFile, splitRatio)
    numImages = height(trainingData);
    splitIdx = randperm(numImages, round(splitRatio * numImages));

    validationDataSplit = trainingData(setdiff(1:end, splitIdx), :);

    imageFiles = validationDataSplit.imageFilename;
    numImages = numel(imageFiles);
    
    filenames = cell(numImages, 1);
    bboxes = cell(numImages, 1);
    scores = cell(numImages, 1);

    for i = 1:numImages
        img = imread(imageFiles{i});
        [bboxes{i}, scores{i}] = detect(detector, img);
        
        filenames{i} = imageFiles{i};
        bboxes{i} = mat2str(bboxes{i});
        scores{i} = mat2str(scores{i});
    end
    
    T = table(filenames, bboxes, scores, ...
        'VariableNames', {'Filename', 'BoundingBox', 'ConfidenceScore'});
    
    writetable(T, outputFile);
    disp(['Excel file created and stored with results for ', outputFile]);
end