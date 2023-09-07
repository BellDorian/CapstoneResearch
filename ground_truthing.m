% CAPSTONE GROUND TRUTHING
% Adam Henderson, Avni Patel, Dorian Bell, Kelly Kuhn, Tristan Kolat
% 
% Last Update: 9/7/23 Adam Henderson




net = yolov2;

videoPath = 'path_to_video.mp4'; %replace with video path

%VideoReader object to read the video
videoReader = VideoReader(videoPath);

%VideoWriter object to save the annotated video
outputVideoPath = 'output_video.avi'; % Replace with your desired output path
outputVideo = VideoWriter(outputVideoPath, 'Uncompressed AVI');
open(outputVideo);

customData = cell(1, numFrames); %initialize cell array to store data
frameIndex = 1; %initialize the frame index

%frame by frame interactive YOLO 
%once we have video I'll probably need to actually test and make sure does
%what we want
while hasFrame(videoReader)
    %read the next frame
    frame = readFrame(videoReader);
    
    %perform object detection on the frame
    [bboxes, scores, labels] = detect(net, frame);
    
    %display the frame with detected objects
    frameWithBoxes = insertObjectAnnotation(frame, 'rectangle', bboxes, labels);
    imshow(frameWithBoxes);
    
    %wait for user interaction to draw custom bounding boxes
    title('Click and drag to draw bounding boxes. Press "q" to quit.');
    key = '';
    while isempty(key)
        key = evalin('base','key');
        drawnow;
    end
    
    %check if quit (press "q")
    if strcmp(key, 'q')
        break;
    end
    
    %allow custom bounding boxes with labels (hands, face, mouth, etc.)
    title('Draw custom bounding boxes. Double-click to confirm.');
    
    customBboxes = [];
    customLabels = {};


    %BOX DRAWING
    while true
        %draw a bounding box
        h = drawrectangle;
        if isempty(h.Position)
            break; %stop drawing when the user DOUBLE CLICKS
        end
        
        %ask the user to select the object class for the box
        %MAY NEED TO RELOOK AT THIS PART ONCE WE HAVE VIDEOS - adam
        [selectedClassIdx, isSelected] = listdlg(...
            'PromptString', 'Select the object class:', ...
            'ListString', objectClasses, ...
            'SelectionMode', 'single', ...
            'ListSize', [150, 100] ...
        );
        
        if isSelected
            customBboxes = [customBboxes; h.Position];
            customLabels{end+1} = objectClasses{selectedClassIdx};
        else
            break; %stop drawing if no class is selected
        end
    end

    customData{frameIndex} = struct('Bboxes', customBboxes, 'Labels', customLabels);
    frameIndex = frameIndex + 1;
    
    %write the frame with custom bounding boxes to the output video
    writeVideo(outputVideo, insertObjectAnnotation(frame, 'rectangle', customBboxes, customLabels));
end

%save box positions and labels in excel file
customDataTable = cell2table(customData', 'VariableNames', {'Data'});
excelFileName = 'custom_annotations.xlsx';
writetable(customDataTable, excelFileName);

%close the interactive figure
close(hFig);

%close video file
close(outputVideo);

%tell user when processing is complete
disp('Object detection and annotation in the video is complete.');