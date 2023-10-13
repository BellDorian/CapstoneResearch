

%========== Frame Extraction ==========

% Define the video file path and the output directory for the frames
videoFile = 'D:\myCode\CAPSTONE\Videos\side1\side1_5.mp4';
outputDir = 'D:\myCode\CAPSTONE\Videos\side1\frames\S105\';
%{


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
    outputFileName = sprintf('%sS105frame_%04d.jpg', outputDir, frameNum);
    
    % Save the frame as an image
    imwrite(frame, outputFileName);
end

disp('Frame extraction complete!');
%}



% ========== Creating Training Data Table ==========

% Load the ground truth data
load('Side1_05.mat', 'gTruth');

% Extract the timetable from ROILabelData
labelData = gTruth.ROILabelData.side1_5;

% Initialize an empty cell array for images
imageFileNames = cell(height(labelData), 1);

% Fill the cell array with the path to the extracted video frames
for i = 1:height(labelData)
    % Construct image filename based on frame number
    imageFileNames{i} = sprintf('%sS105frame_%04d.jpg', outputDir, i);
end

% Convert timetable to table format
trainingData = table(imageFileNames, labelData.Face, labelData.Eyes, labelData.Mouth, labelData.Hand, ...
    'VariableNames', {'imageFilename', 'Face', 'Eyes', 'Mouth', 'Hand'});

% ========== Faster R-CNN Code ==========

% Load your pre-trained network and create the layer graph
net = resnet50();
lgraph = layerGraph(net);

% Define RPN layers
numFilters = 512;  % typical for RPN
numAnchors = 9;   % typical number of anchor boxes

% RPN classification layers
rpnClsLayers = [
    convolution2dLayer(3, numFilters, 'Padding', 'same', 'Name', 'rpn_conv1')
    reluLayer('Name', 'rpn_relu1')
    convolution2dLayer(1, numAnchors*2, 'Name', 'rpn_cls')   % 2 classes: object, no-object
    softmaxLayer('Name', 'rpnSoftmax')
    classificationLayer('Name', 'rpnClassification')
];

% RPN regression layers
rpnRegLayers = [
    convolution2dLayer(3, numFilters, 'Padding', 'same', 'Name', 'rpn_conv2')
    reluLayer('Name', 'rpn_relu2')
    convolution2dLayer(1, numAnchors*4, 'Name', 'rpn_reg')  % 4 values per anchor: [dx, dy, log(dw), log(dh)]
    regressionLayer('Name', 'rpnRegression')
];

% ROI Max pooling layer
roiPool = roiMaxPooling2dLayer([2,2], 'Name', 'roiMaxPooling2d');

% Define anchor boxes in [height, width] format
anchorBoxes = [
    16 16;
    32 32;
    64 64;
    128 128;
    256 256;
    16 32;
    32 64;
    64 128;
    128 256;
];

% Add the region proposal layer with anchor boxes
proposalLayer = regionProposalLayer(anchorBoxes, 'Name', 'regionProposal');

% Final classification and regression layers
numClasses = 4; % number of classes (Face, Eyes, Mouth, Hand)
finalClsLayer = [
    fullyConnectedLayer(numClasses, 'Name', 'rcnnFC')
    softmaxLayer('Name', 'rcnnSoftmax')
    classificationLayer('Name', 'rcnnClassification')
];

finalRegLayer = [
    fullyConnectedLayer(4 * numAnchors, 'Name', 'rcnnBoxFC')
    regressionLayer('Name', 'rcnnBoxRegression')
];

% Assemble the layers sequentially
layers = [
    lgraph.Layers(1:end-1)
    rpnClsLayers
    rpnRegLayers
    roiPool
    proposalLayer
    finalClsLayer
    finalRegLayer
];

% Create a new layer graph
lgraph = layerGraph(layers);

% Connect layers appropriately
lgraph = connectLayers(lgraph, 'activation_49_relu', 'rpn_conv1');
lgraph = connectLayers(lgraph, 'activation_49_relu', 'rpn_conv2');
lgraph = connectLayers(lgraph, 'rpnSoftmax', 'regionProposal/scores');
lgraph = connectLayers(lgraph, 'rpn_reg', 'regionProposal/boxDeltas');
lgraph = connectLayers(lgraph, 'regionProposal', 'roiMaxPooling2d/in');
lgraph = connectLayers(lgraph, 'roiMaxPooling2d', 'rcnnFC');

% Training options
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 1, ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 10, ...
    'Verbose', true, ...
    'VerboseFrequency', 10);  % Display training progress every 10 iterations

% Train the detector (assuming you've defined 'trainingData' elsewhere)
detector = trainFastRCNNObjectDetector(trainingData, lgraph, options);

% Save the trained detector and cleaned graph
save('trained_detector.mat', 'detector');
save('cleaned_graph.mat', 'lgraph');



% Function to clean up the layer graph by removing unused layers
function cleanedGraph = removeUnusedLayers(lgraph)
    % Get the layers and connections from the layer graph
    layers = lgraph.Layers;
    connections = lgraph.Connections;
    
    % Get the names of the layers
    layerNames = {layers.Name};
    
    % Initialize unusedLayers as an empty cell array
    unusedLayers = {};
    
    for i = 1:numel(layerNames)
        currentLayerName = layerNames{i};
        isConnected = any(strcmp(connections.Source, currentLayerName) | ...
                         strcmp(connections.Destination, currentLayerName));
        if ~isConnected
            unusedLayers{end+1} = currentLayerName; % This will keep it as a cell array
        end
    end
    
    % Check if unusedLayers is not empty before trying to remove
    if ~isempty(unusedLayers)
        cleanedGraph = removeLayers(lgraph, unusedLayers);
    else
        cleanedGraph = lgraph; % Return the original graph if there are no unused layers
    end
end











