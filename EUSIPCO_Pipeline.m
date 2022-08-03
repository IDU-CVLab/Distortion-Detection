clear all;
close all;
clc;
%%
vds=dir('*.avi');
files={vds.name}';

% for i = 1:1:numel(files) % this is for process multiple videos. Doing
% Calculation (Average frame Intensity for detection of blank frame and intensity variation problems..
for i = 1:1:1
    [intens, stds] = avr_intensity2(files{i},i);
%     [intens, stds, empty_frame] = avr_intensity2(files{i},i);
    black_frame(i) = sum(empty_frame);
    intens1(i).Name = files{i};
    intens1(i).videos(:) = intens;
%     intensity(i).intensity(:) = intens(2:length(intens(1,:))-1);
    intensity(i).intensity(:) = intens(1:length(intens(1,:))-1);
end

for i = 1:1:numel(files)
% for i = 4:1:4
    intens1(i).videos(end) = median(intens1(i).videos);
    for k = 1:1:length(intens1(i).videos)
        if floor(intens1(i).videos(k)) == 0
            efv(i).video(k) = 1;
        else
            efv(i).video(k) = 0;
        end
    end
    N = length(intens1(i).videos);
    for n=1:1:N
        std(i).Name = files{i};
        std(i).videos(n) = (intens1(i).videos(n)-intens1(i).videos(N))/2.55;
    end
end

a = 0.1;
b = 0.3;
for i = 1:1:numel(files)
% for i = 4:1:4
%     avr_frame = median(intens1(i).videos);
    avr_frame = intens1(i).videos(end);
    for k = 1:1:length(intens1(i).videos)-2
       
        if efv(i).video(k) == 0 && efv(i).video(k) == 0
            if (intens1(i).videos(k) < (intens1(i).videos(k+1)*(1-a)) || (intens1(i).videos(k) > intens1(i).videos(k+1)*(1+a))) %% need to functionalize it
                int_state(i).value(k) = intens1(i).videos(k);
                int_state(i).state(k) = 1;
            else
                int_state(i).value(k) = 0;
                int_state(i).state(k) = 0;
            end
        else
            int_state(i).value(k) = 0;
        end
        if (intens1(i).videos(k) < avr_frame*(1-b) || (intens1(i).videos(k) > avr_frame*(1+b)))&&efv(i).video(k) == 0
            int_median_thrs(i).value(k) = 1;
        else
            int_median_thrs(i).value(k) = 0;
        end
    end
    int_change(i).temporal = sum(int_state(i).value);
    int_change(i).global = sum(int_median_thrs(i).value);
    black_frame(i,1) = sum(efv(i).video);
    
    %     figure,subplot(131), stem(intens1(i).videos);title(sprintf('%s'),files{i},'FontSize',15);
    %     xlabel('Frame','FontSize',15,'FontWeight','bold');
    %     ylabel('Average Intensity Value of Frame','FontSize',15,'FontWeight','bold');
    %
    %     subplot(132), stem(int_state(i).value);title('Sequential Frame Analysis','Local Analysis','FontSize',15);
    %     xlabel('Frame','FontSize',15,'FontWeight','bold');
    %     ylabel('Value of High Intensity Varrying Frame  ','FontSize',15,'FontWeight','bold');
    %
    %     subplot(133), stem(int_median_thrs(i).value);title('Frame Analysis with Median Thresholding','Global Analysis','FontSize',15);
    %     xlabel('Frame','FontSize',15,'FontWeight','bold');
    %     ylabel('High Intensity Varrying State','FontSize',15,'FontWeight','bold');
    
end
%%
for i =1:1:numel(files)
    eps = 0.0001;
    TP(i,1) = 0;
    FP(i,1) = 0;
    TN(i,1) = 0;
    FN(i,1) = 0;
    for k = 1:1:length(VBFI_GT(i).Videos)-2
        if (int_median_thrs(i).value(k) == 1) && (VBFI_GT(i).Videos(k) == 1)
            TP(i,1) = TP(i,1)+1;
        elseif (int_median_thrs(i).value(k) == 1) && (VBFI_GT(i).Videos(k) == 0)
            FP(i,1) = FP(i,1)+1;
        elseif (int_median_thrs(i).value(k) == 0) && (VBFI_GT(i).Videos(k) == 0)
            TN(i,1) = TN(i,1)+1;
        elseif (int_median_thrs(i).value(k) == 0) && (VBFI_GT(i).Videos(k) == 1)
            FN(i,1) = FN(i,1)+1;
        end
    end
    Accuracy(i,1) = (sum(TP(i))+sum(TN(i)))/((sum(TP(i))+sum(FP(i))+sum(TN(i))+sum(FN(i))));
    Specificity(i,1) = (sum(TN(i))+eps)/(sum(TN(i))+sum(FP(i))+eps);
    Sensitivity(i,1) = (sum(TP(i))+eps)/(sum(TP(i))+sum(FN(i))+eps);
    Precision(i,1) = (sum(TP(i))+eps)/(sum(TP(i))+sum(FP(i))+eps);
end
VideoName = files;
TFmap_IC_pipeline = table(VideoName, TP, FP, TN, FN, Accuracy, Sensitivity, Specificity, Precision);


%%
i = 6;
v= VideoReader(files{i});
myVideo = VideoWriter('enhanced_nonblack.avi');
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
    if k < length(intens1(i).videos)-2
    k = k +1
    end
end
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
        intens1(k) = floor(mean(mean(frame)));
        k = k +1;
        sprintf('intensity analysis video: %d, frame: %d',i, k)
    end

% intens = [intens, mean(intens)];
intens = [intens, median(intens)];
N = length(intens);
for k=1:1:N-2
   stds(k) = abs(intens(k)-intens(N))/2.55;
%     if intens(k) == 0
%         empty_frame(k) = 1;
%     else
%         empty_frame(k) = 0;
%     end
   
end

end

% %% Creating Video from Images
% clc, clear all, close all;
% %%
% images=dir('*.tif');
% files={images.name}';
% myVideo = VideoWriter('Cell_tracking.avi');
% depVideoPlayer = vision.DeployableVideoPlayer;
% open(myVideo);
% 
% for k = 1:1: numel(files)
% 
%     frame = imread(files{k, 1});
%     writeVideo(myVideo, frame);
%     pause(1/20  );
%     
% end
%  k = m; % to trigger alarm after video writing is complete

%%

% for i = 3:1:4%numel(efv)
%    efv(i).State = sum(efv(i).video(:));
%    int_median_thrs(i).State = sum(int_median_thrs(i).value(:));
%    figure(i),subplot(121),stem(int_median_thrs(i).value, "r"), xlabel("frame number"),ylabel("state of detection"), title(sprintf(files{i,1}));
%    hold on,stem(int_state(i).state,"g");
%    subplot(122),stem(intens1(i).videos),  xlabel("frame number"),ylabel("AFI"),title(sprintf(files{i,1}));
%    hold on,
%    z1 = 0.9.*intens1(i).videos;
%    plot(z1,"g--o", "LineWidth", 1);
%    z2 = 1.1.*intens1(i).videos;
%    plot(z2,"g--o", "LineWidth", 1);
%    y = median(intens1(i).videos).*ones(length(intens1(i).videos));
%    plot(y,"r", "LineWidth", 2);
%    y1 = 1.3*median(intens1(i).videos).*ones(length(intens1(i).videos));
%    plot(y1,"r--", "LineWidth", 2);
%    y2 = 0.7*median(intens1(i).videos).*ones(length(intens1(i).videos));
%    plot(y2,"r--", "LineWidth", 2);
%    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%    
%    saveas(figure(i), sprintf("%s.tif", files{i,1}))
%    close all
% end

% for i = 1:1:14
%     for k = 1:1:length(int_median_thrs(i).value)
%     VBFI_GT(i).Videos(k) = FramebaseGTofIntensity2{i,k+1};
%     end
%     
% end