clear all;
close all;
clc;
%%
vds=dir('*.avi');
files={vds.name}';
for i = 3:1:3%numel(files)
    [intens, efv] = find_blank_frame(files{i},i);
end

%%
v= VideoReader(files{i});
myVideo = VideoWriter('nonblank_version.avi');
depVideoPlayer = vision.DeployableVideoPlayer;
open(myVideo);

k= 1;
while hasFrame(v)
    frame = readFrame(v);
    frame = rgb2gray(frame);
    if efv(k) == 0
            frame2 = frame;
            writeVideo(myVideo, frame2);
            pause(1/v.FrameRate  );
    end
    corrected_mean(k,i) = mean(mean(frame));
    if k < length(intens)-2
        k = k +1
    end
end
close(myVideo)
sprintf('# of blank frame: %d',sum(efv))
%% function avr_intensity2
% 1st input: Name of the video in the same directort,
% 2nd input: current count of the "first loop" (need to display only)

% function [intens, stds, empty_frame] = avr_intensity2(video_name, i)
function [intens, blank_frame] = find_blank_frame(video_name, i)
v= VideoReader(video_name);
k=1;
while hasFrame(v)
    frame = rgb2gray(readFrame(v));
    intens(k) = floor(mean(mean(frame)));
    k = k +1;
    sprintf('intensity analysis video: %d, frame: %d',i, k)
end
N = length(intens);
for k=1:1:N
    if intens(k) == 0
        blank_frame(k) = 1;
    else
        blank_frame(k) = 0;
    end
end

end

