load('Side1_04.mat', 'gTruth');

labelData = gTruth.ROILabelData.side1_4;

imageFileNames = cell(height(labelData), 1);

for i = 1:height(labelData)
    imageFileNames{i} = sprintf('%sS104frame_%04d.jpg', outputDir, i);
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
    FaceBB{i} = labelData.Head{i};
    MouthBB{i} = labelData.Mouth{i};
end

trainingData = table(imageFileNames, HandsBB, EyesBB, FaceBB, MouthBB, ...
    'VariableNames', {'imageFilename', 'Hand', 'Eyes', 'Face', 'Mouth'});

disp('Training Data Table created!');


% ========== Creating Training Data Table ==========
%{

load('Side2_03.mat', 'gTruth');

labelData = gTruth.ROILabelData.side2_3;

imageFileNames = cell(height(labelData), 1);

for i = 1:height(labelData)
    imageFileNames{i} = sprintf('%sS203frame_%04d.jpg', outputDir, i);
end

trainingData = table(imageFileNames, labelData.Face, labelData.Eyes, labelData.Mouth, labelData.Hands, ...
    'VariableNames', {'imageFilename', 'Face', 'Eyes', 'Mouth', 'Hand'});

for i = 1:height(trainingData)
    trainingData.Face{i} = double(trainingData.Face{i});
    trainingData.Eyes{i} = double(trainingData.Eyes{i});
    trainingData.Mouth{i} = double(trainingData.Mouth{i});
    trainingData.Hand{i} = double(trainingData.Hand{i});
end

disp('Training Data Table created!');
%}