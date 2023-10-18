splitRatio = 0.8;

% --- Face Detection & Evaluation ---
disp('Gathering Face, Eyes, Mouth detection data');
processDetection(faceEyesMouthTrainingData, faceEyesMouthDetector, 'faceDetectionResults_S104.xlsx', splitRatio);

% --- Hand Detection & Evaluation ---
disp('Gathering Hand detection data');
processDetection(handTrainingData, handDetector, 'handDetectionResults_S104.xlsx', splitRatio);

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



