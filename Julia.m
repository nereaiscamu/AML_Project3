%% Enter your name
close all; clear all; % a bit of cleaning
%======================================================================
% 1)  ASSIGNEMENT 0: SETTINGS
%======================================================================
% Replace by your own information
LAST_NAME1 = 'Bodenmann'; % Last name 1
LAST_NAME2 = 'Heiniger'; % Last name 2
LAST_NAME3 = 'Carbonell'; % Last name 3
GROUP_NAME = 'G'; % your dataset number

% Settings
DATASET1 = ['DM002_TDM_08_1kmh.mat'];
DATASET2 = ['DM002_TDM_08_2kmh.mat'];
DATASET3 = ['DM002_TDM_1kmh_NoEES.mat'];
DATASET4 = ['AML_02_2.mat'];
DATASET5 = ['AML_02_1.mat'];

load(DATASET4); % choose which datastructure to load
Results = [];

%%  ------------- (1) ASSIGNEMENT 1: Varibales Healthy Gait ----------------------

time_EMG = [];
time_Marker = [];
for i = 1 : length(EMG.LGM)
    time_EMG(i) = i* 1/Info.EMGfq ;
end
for i = 1: length(Markers.LANK)
    time_Marker(i) = i* 1/Info.Kinfq;
end

names_EMG = fieldnames(EMG);
names_Markers = fieldnames(Markers);

%%  ------------- (1) ASSIGNEMENT 1: Plot Markerpositions in Healty Gait ----------------------
figure
for i=[1,3,4,5]
    d_left = Markers.(names_Markers{i})(:,3) - mean(Markers.(names_Markers{i})(:,3));
    plot(time_Marker(2000:6000), d_left(2000:6000))
    hold on
end
d_left = Markers.(names_Markers{4})(:,3)-Markers.(names_Markers{3})(:,3) - mean(Markers.(names_Markers{4})(:,3)-Markers.(names_Markers{3})(:,3));   
plot(time_Marker(2000:6000), d_left(2000:6000));
legend(names_Markers{1},names_Markers{3},names_Markers{4},names_Markers{5}, "LKNEE-LANG")
title("LEFT z-coordinates")

figure
for i=[2,6,7,8]
    d_right = Markers.(names_Markers{i})(:,3) - mean(Markers.(names_Markers{i})(:,3));
    plot(time_Marker(2000:6000), d_right(2000:6000));
    hold on
end
d_right = Markers.(names_Markers{7})(:,3)-Markers.(names_Markers{6})(:,3) - mean(Markers.(names_Markers{7})(:,3)-Markers.(names_Markers{6})(:,3));
plot(time_Marker(2000:6000), d_right(2000:6000));
legend(names_Markers{2},names_Markers{6},names_Markers{7},names_Markers{8}, "RKNEE-RANG")
title("RIGHT z-coordinates")

%%  ------------- (1) ASSIGNEMENT 1: Plot EMG signals in Healty Gait ----------------------
figure
for i = 1:length(names_EMG)/2 +4
    signal = EMG.(names_EMG{i});
    linenv = lin_env(signal, Info.EMGfq);
    subplot(length(names_EMG)/2 +4,1,i);
    plot(time_EMG, linenv);
%     hold on
%     plot(time_EMG, signal)
    xlim([10,30])
    title(names_EMG{i})
end
k =(length(names_EMG)/2) +1;
for i=[1,3,4,5]
    d_left = Markers.(names_Markers{i})(:,3) - mean(Markers.(names_Markers{i})(:,3));
    subplot(length(names_EMG)/2 +4,1,k);
    plot(time_Marker, d_left)
    xlim([10,30])
    title(names_Markers{i})
    k = k+1;
end


figure
for i = length(names_EMG)/2+1 : length(names_EMG)
    signal = EMG.(names_EMG{i});
    linenv = lin_env(signal, Info.EMGfq);
    subplot(length(names_EMG)/2 +4,1,i-length(names_EMG)/2);
    plot(time_EMG, linenv);
%     hold on
%     plot(time_EMG, signal)
    xlim([10,30])
    title(names_EMG{i})
end
k =(length(names_EMG)/2) +1;
for i=[2,6,7,8]
    d_left = Markers.(names_Markers{i})(:,3) - mean(Markers.(names_Markers{i})(:,3));
    subplot(length(names_EMG)/2 +4,1,k);
    plot(time_Marker, d_left)
    xlim([10,30])
    title(names_Markers{i})
    k = k+1;
end

%%  ------------- (1) ASSIGNEMENT 1: Healty Gait - Seperation into cycles ----------------------
d_right = Markers.(names_Markers{7})(:,3)-Markers.(names_Markers{6})(:,3) - mean(Markers.(names_Markers{7})(:,3)-Markers.(names_Markers{6})(:,3));
d_left = Markers.(names_Markers{4})(:,3)-Markers.(names_Markers{3})(:,3) - mean(Markers.(names_Markers{4})(:,3)-Markers.(names_Markers{3})(:,3));

[Lpks,Llocs] = findpeaks(d_left, 'MinPeakProminence',50)
figure
plot(time_Marker, d_left)
hold on
plot(Llocs/Info.Kinfq, Lpks, 'o')
xlim([10,30])

[Rpks,Rlocs] = findpeaks(d_right, 'MinPeakProminence',50)
figure
plot(time_Marker, d_right)
hold on
plot(Rlocs/Info.Kinfq, Rpks, 'o')
xlim([10,30])

Results.Lgct = mean(diff(Llocs/Info.Kinfq))
Results.Rgct = mean(diff(Llocs/Info.Kinfq))

for i = 1:length(Llocs)

end
%%  ------------- (1) ASSIGNEMENT 1: Varibales Patient ----------------------

% time_EMG = [];
% time_Marker = [];
% for i = 1 : length(data.CBack)
%     time_EMG(i) = i* 1/data.EMG_sr ;
% end
% for i = 1: length(data.LANK)
%     time_Marker(i) = i* 1/data.marker_sr;
% end
% 
% 
% names = fieldnames(data);
%%  ------------- (1) ASSIGNEMENT 1: Plot Markerpositions in Patient ----------------------
% figure
% for i=19:22
%     d_left = data.(names{i})(:,3) - mean(data.(names{i})(:,3));
%     d_right = data.(names{i+4})(:,3) - mean(data.(names{i+4})(:,3));
% 
%     plot(time_Marker, d_left)
%     hold on
% end
%     legend(names{19},names{20},names{21},names{22})
%     title("LEFT z-coordinates")
% 
% figure
% for i=23:26
%     d_right = data.(names{i})(:,3) - mean(data.(names{i})(:,3));
%     plot(time_Marker, d_right);
%     hold on
% end
% d_right = data.(names{26})(:,3)+data.(names{25})(:,3) - mean(data.(names{26})(:,3)+data.(names{25})(:,3));
% plot(time_Marker, d_right);
% legend(names{23},names{24},names{25},names{26}, "RANG-RKNEE")
% title("RIGHT z-coordinates")
% xlim([10,50])



%%  ------------- Functions ----------------------
function z = lin_env(data, fs)
    Wn = 10/(fs/2); %fc = 10 (15)
    [b,a] = butter(4, Wn);
    z = abs(data - mean(data));
    z = filtfilt(b,a,z);
end


