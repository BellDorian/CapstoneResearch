%{
numImages = numel(faceDetectionResults.imageFilename);

% Convert bounding boxes and scores to strings for Excel export
bboxStr = cell(numImages, 1);
scoreStr = cell(numImages, 1);

for i = 1:numImages
    bboxStr{i} = mat2str(faceDetectionResults.Face{i});
    scoreStr{i} = mat2str(faceDetectionResults.FaceScore{i});
end

% Convert to table
T = table(faceDetectionResults.imageFilename, bboxStr, scoreStr, ...
    'VariableNames', {'Filename', 'BoundingBox', 'ConfidenceScore'});

writetable(T, 'faceDetectionResults.xlsx');
%}

% Similarly, detect hands and evaluate the handDetector using the same method
% --- Hand Detection & Evaluation ---
handNumImages = height(handTrainingData);
handSplitIdx = randperm(handNumImages, round(splitRatio * handNumImages));
handTrainingDataSplit = handTrainingData(handSplitIdx, :);
handValidationDataSplit = handTrainingData(setdiff(1:end, handSplitIdx), :);

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

numImages = numel(handDetectionResults.imageFilename);

% Convert bounding boxes and scores to strings for Excel export
bboxStr = cell(numImages, 1);
scoreStr = cell(numImages, 1);

for i = 1:numImages
    bboxStr{i} = mat2str(handDetectionResults.Hand{i});
    scoreStr{i} = mat2str(handDetectionResults.HandScore{i});
end

% Convert to table
T = table(handDetectionResults.imageFilename, bboxStr, scoreStr, ...
    'VariableNames', {'Filename', 'BoundingBox', 'ConfidenceScore'});

writetable(T, 'handDetectionResults.xlsx');



