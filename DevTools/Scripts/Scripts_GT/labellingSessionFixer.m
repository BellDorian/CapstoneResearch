% Load the gTruth object
load('side1_03_new.mat', 'gTruth');

% Extract label data from the gTruth object
labelData = gTruth.ROILabelData;
labelDefs = gTruth.LabelDefinitions;

% Define the current and alternative paths
alternativePath = 'D:\myCode\CAPSTONE\Videos\side1\side1_3.mp4';

% Create a new VideoSource with the updated path
newDataSource = vision.labeler.loading.VideoSource('SourceName', alternativePath);

% Construct a new gTruth object with the new video source and extracted label data
newGTruth = groundTruthMultisignal(newDataSource, labelDefs, labelData);

% Save the updated gTruth object back to the MAT file
save('side1_03_new.mat', 'newGTruth', '-append');

disp('Updated gTruth object with new file path successfully.');




