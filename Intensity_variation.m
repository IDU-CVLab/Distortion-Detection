clear all;
close all;
clc;
%%
vds=dir('*.avi');
files={vds.name}';

% this is for process multiple videos. Doing
% Calculation (Average frame Intensity for detection of blank frame and intensity variation problems..
% for i = 1:1:numel(files) 
for i = 4:1:4
    [intens, stds] = avr_intensity2(files{i},i);
    AFI(i).Name = files{i};
    AFI(i).videos(:) = intens;
end

for i = 4:1:4%numel(files)
    AFI(i).videos(end) = median(AFI(i).videos); % that may not  necessary, already calculated at avr_intens2
    for k = 1:1:length(AFI(i).videos)
        if floor(AFI(i).videos(k)) == 0
            efv(i).video(k) = 1; % efv is equals empty frame vector
        else
            efv(i).video(k) = 0;
        end
    end
    N = length(AFI(i).videos);
    for n=1:1:N
        std(i).Name = files{i};
        std(i).videos(n) = (AFI(i).videos(n)-AFI(i).videos(N))/2.55;
    end
end

a = 0.1;
b = 0.3;
for i = 4:1:4%numel(files)
    median_AFI = AFI(i).videos(end);
    for k = 1:1:length(AFI(i).videos)-1% -2 ???
        %         if (AFI(i).videos(k) < (AFI(i).videos(k+1)*(1-a)) || (AFI(i).videos(k) > AFI(i).videos(k+1)*(1+a))) %% need to functionalize it
        %             int_state(i).value(k) = AFI(i).videos(k);
        %             int_state(i).state(k) = 1;
        %         else
        %             int_state(i).value(k) = 0;
        %             int_state(i).state(k) = 0;
        %         end
        %         else
        %             int_state(i).value(k) = 0;
        %     end
        if (AFI(i).videos(k) < median_AFI*(1-b) || (AFI(i).videos(k) > median_AFI*(1+b)))
            int_median_thrs(i).value(k) = 1;
        else
            int_median_thrs(i).value(k) = 0;
        end
    end
end
%%
v= VideoReader(files{i});
myVideo = VideoWriter('enhanced_version.avi');
depVideoPlayer = vision.DeployableVideoPlayer;
open(myVideo);

k= 1;
while hasFrame(v)
    frame = readFrame(v);
    frame = rgb2gray(frame);
    if efv(i).video(k) == 0
        if int_median_thrs(i).value(k) == 1
            %             if intens(k+1)>=min([intens(k), intens(k+2)])*1.05
            %                 frame2 = floor(frame(:,:,:).*(1-(std(i).videos(k))));
            %                 frame2 = floor(frame(:,:,:).*(1-(std(i).videos(k)/100)));
            %                 frame = frame2;
            frame2 = floor(frame(:,:,:).*((std(i).videos(k))/100));
            frame2 = uint8(double(frame2) + (double(frame(:,:,:)) + ones(size(frame))*((std(i).videos(k))/100)))./2;
            writeVideo(myVideo, frame2);
            pause(1/v.FrameRate  );
        else
            writeVideo(myVideo, frame);
            pause(1/v.FrameRate  );
        end
    end
    corrected_mean(k,i) = mean(mean(frame));
    if k < length(AFI(i).videos)-2
        k = k +1
    end
end
close(myVideo)
%% function avr_intensity2
% 1st input: Name of the video in the same directort,
% 2nd input: current count of the "first loop" (need to display only)
% function [intens, stds, empty_frame] = avr_intensity2(video_name, i)
function [intens, stds] = avr_intensity2(video_name, i)
v= VideoReader(video_name);
k=1;
while hasFrame(v)
    frame = rgb2gray(readFrame(v));
    %         frame = readFrame(v);
    intens(k) = floor(mean(mean(frame)));
    k = k +1;
    sprintf('intensity analysis video: %d, frame: %d',i, k)
end

% intens = [intens, mean(intens)];
intens = [intens, median(intens)];
N = length(intens);
for k=1:1:N-1
    stds(k) = abs(intens(k)-intens(N))/2.55;
    
end

end
