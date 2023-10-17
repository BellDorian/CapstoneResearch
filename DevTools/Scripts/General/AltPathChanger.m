% Load the gTruth object
load('Side2_03.mat', 'gTruth');

% Define the old (current) and new (alternative) paths
currentPath = 'D:\myCode\CAPSTONE\A2_Videos\Side2\Side2_03.mp4';
alternativePath = 'D:\myCode\CAPSTONE\A2_Videos\Side2\side2_3.mp4';

if exist(alternativePath, 'file')
    disp('File exists.');
else
    disp('File does not exist.');
end

% Create a cell array with the current and alternative paths
pathPairs = {currentPath, alternativePath};

% Use changeFilePaths to update the paths in gTruth
unresolvedPaths = changeFilePaths(gTruth, pathPairs);



% If unresolvedPaths is empty, then the paths were successfully updated
if isempty(unresolvedPaths)
    % Save the updated gTruth object back to the MAT file
    save('Side2_03.mat', 'gTruth', '-append');
    disp('File path updated successfully.');
else
    disp('Some paths could not be updated. Check unresolvedPaths for details.');
end


