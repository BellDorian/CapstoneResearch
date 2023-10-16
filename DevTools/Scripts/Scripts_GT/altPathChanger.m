% Define the current and alternative paths in a cell array
currentPath = 'D:\myCode\CAPSTONE\side2\side2_5.mp4';
alternativePath = 'D:\myCode\CAPSTONE\Videos\side2\side2_5.mp4';

% Create a cell array with the current and alternative paths
pathPairs = {currentPath, alternativePath};

% Use the changeFilePaths function with the cell array of path pairs
unresolvedPaths = changeFilePaths(gTruth, pathPairs);

% Save the updated gTruth object back to your MAT file
save('Side2_05.mat', 'gTruth', '-append');