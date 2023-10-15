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

% ========== Detection & Evaluation ==========
%{

% Split the data for Face, Eyes, and Mouth
splitRatio = 0.8;
faceNumImages = height(faceEyesMouthTrainingData);
faceSplitIdx = randperm(faceNumImages, round(splitRatio * faceNumImages));

faceTrainingDataSplit = faceEyesMouthTrainingData(faceSplitIdx, :);
faceValidationDataSplit = faceEyesMouthTrainingData(setdiff(1:end, faceSplitIdx), :); % Corrected indexing

% Detect faces using the trained detector
faceDetectionResults = table();
imageFiles = faceValidationDataSplit.imageFilename;
numImages = numel(imageFiles);
bboxes = cell(numImages, 1);
scores = cell(numImages, 1);
for i = 1:numImages
    [bboxes{i}, scores{i}] = detect(faceEyesMouthDetector, imread(imageFiles{i}));
end
faceDetectionResults.imageFilename = imageFiles;
faceDetectionResults.Face = bboxes;
faceDetectionResults.FaceScore = scores;

% Evaluate the faceEyesMouthDetector on the validation set
averagePrecisionFace = evaluateDetectionPrecision(faceDetectionResults, faceValidationDataSplit(:, {'imageFilename', 'Face'}));

disp('Evaluation Results for Face, Eyes, Mouth Detector:');
disp(averagePrecisionFace);

% Similarly, detect hands and evaluate the handDetector using the same method
% --- Hand Detection & Evaluation ---
handNumImages = height(handTrainingData);
handSplitIdx = randperm(handNumImages, round(splitRatio * handNumImages));
handTrainingDataSplit = handTrainingData(handSplitIdx, :);
handValidationDataSplit = handTrainingData(setdiff(1:end, handSplitIdx), :);

% Detect hands using the trained detector
handDetectionResults = table();
imageFilesHand = handValidationDataSplit.imageFilename;
numImagesHand = numel(imageFilesHand);
bboxesHand = cell(numImagesHand, 1);
scoresHand = cell(numImagesHand, 1);
for i = 1:numImagesHand
    [bboxesHand{i}, scoresHand{i}] = detect(handDetector, imread(imageFilesHand{i}));
end
handDetectionResults.imageFilename = imageFilesHand;
handDetectionResults.Hand = bboxesHand;
handDetectionResults.HandScore = scoresHand;

% Evaluate the handDetector
averagePrecisionHand = evaluateDetectionPrecision(handDetectionResults, handValidationDataSplit(:, {'imageFilename', 'Hand'}));
disp('Evaluation Results for Hand Detector:');
disp(averagePrecisionHand);
%}

% ========== Save the Trained Detectors ==========

save('trainedFaceDetectorS105.mat', 'faceEyesMouthDetector');
save('trainedHandDetectorS105.mat', 'handDetector');

disp('Training and evaluation complete!');
