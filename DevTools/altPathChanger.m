% Define the current and alternative paths in a cell array
currentPath = '/Users/kellykuhn/Library/Mobile Documents/com~apple~CloudDocs/IUPUI Fall 2023/Explorations AppliedComputing/Side1_4/side1_4.mp4';
alternativePath = 'D:\myCode\CAPSTONE\Videos\side1\side1_4.mp4';

% Create a cell array with the current and alternative paths
pathPairs = {currentPath, alternativePath};

% Use the changeFilePaths function with the cell array of path pairs
unresolvedPaths = changeFilePaths(gTruth, pathPairs);

% Save the updated gTruth object back to your MAT file
save('Side_1_4_copy1.mat', 'gTruth', '-append');