% Define the current and alternative paths in a cell array
currentPath = 'D:\myCode\CAPSTONE\side1\side1_5.mp4';
alternativePath = 'D:\myCode\CAPSTONE\Videos\side1\side1_3.mp4';

% Create a cell array with the current and alternative paths
pathPairs = {currentPath, alternativePath};

% Use the changeFilePaths function with the cell array of path pairs
unresolvedPaths = changeFilePaths(groundTruth, pathPairs);

% Save the updated groundTruth object back to your MAT file
save('Side1_03.mat', 'groundTruth', '-append');
