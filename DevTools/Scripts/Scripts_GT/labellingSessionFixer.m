% Load the MAT file
data = load('Side1_04.mat');
gTruth = data.groundTruthLabelingSession; % Extracting the correct object from MAT file

% Define the current and alternative paths in a cell array
currentPath = '/Users/kellykuhn/Library/Mobile Documents/com~apple~CloudDocs/IUPUI Fall 2023/Explorations Applied Computing/Side1_4/side1_4.mp4';
alternativePath = 'D:\myCode\CAPSTONE\GroundTruth\GT_Side1\MAT';

% Create a cell array with the current and alternative paths
pathPairs = {currentPath, alternativePath};

% Try the changeFilePaths function with the cell array of path pairs
try
    unresolvedPaths = changeFilePaths(gTruth, pathPairs);
catch ME
    disp(['Error: ', ME.message]);
    return;
end

% Save the updated gTruth object back to your MAT file
save('Side1_04.mat', 'groundTruthLabelingSession', '-append');
