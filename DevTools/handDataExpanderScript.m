%Segment A: Frames 1 - 500
%Segment B: Frames 501 - 1000
%Segment C: Frames 1001 - last image

aStart = 1;
aEnd = 500;

bStart = 501;
bEnd = 1000;

%Make sure your last frame of data is 1043 like mine is
%Otherwise, alter the cEnd value accordingly
cStart = 1001;
cEnd = 1043;

%Make sure the time between your frames is 0.03336 like mine is
%Otherwise, alter accordingly. (Round to 5th decimal place)
timeBetweenFrames = 0.03336;
i = startFrame - 1;

%This is just an intermediate variable to shorten the name
time = timeBetweenFrames;

%*** SET THIS variable equal to whatever your hand data array is called
handDataCellArray = Hands4;

for frame = startFrame:1:endFrame
    
    time = i * 0.03336;
    disp("Frame #" + i);
    fprintf("%.4E", time)
    i = i + 1;

    celldisp(handDataCellArray(frame))

end