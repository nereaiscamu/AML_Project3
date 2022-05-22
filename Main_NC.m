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
DATASET1 = ['DM002_TDM_1kmh_NoEES.mat'];
DATASET2 = ['DM002_TDM_08_1kmh.mat'];
DATASET3 = ['DM002_TDM_08_2kmh.mat'];
DATASET4 = ['AML_02_1.mat'];
DATASET5 = ['AML_02_2.mat'];
DATASET6 = ['AML_02_3.mat'];

load(DATASET4); % choose which datastructure to load
Results = [];

%%  ------------- (1) ASSIGNEMENT 1: DETECT GAIT EVENTS ----------------------
dataset = 4;
if dataset <4
    N_EMG = length(data.LSol);
    SR_ENG = data.EMG_sr ;
    N_Markers = length(data.LHIP);
    SR_Markers = data.marker_sr;
    if dataset <2
        data_EMG = data(1:14);
        data_markers = data(17:24);
    else 
    data_EMG = data(1:16);
    data_markers = data(19:26);
    end 
else 
    N_EMG = length(EMG.LSol);
    SR_ENG = Info.EMGfq ;
    data_EMG = EMG;
    data_markers = Markers;
    N_Markers = length(Markers.LHIP);
    SR_Markers = Info.Kinfq;
end 
   
t_EMG = [];
for i = 1 : N_EMG
    t_EMG(i) = i* 1/SR_ENG;
end 


t_Markers = [];
for i = 1 :N_Markers
    t_Markers(i) = i* 1/SR_Markers ;
end 
%% PLOT EMG FILTERED SIGNAL (RMS) 
% (it reflects the physiological activity during contraction)


EMG_names = fieldnames(data_EMG);
figure
num_muscles = length(EMG_names);

L=ceil(num_muscles^.5);
for i=1:1:num_muscles
    subplot(L,L,i)
    [linenv, RMS] = lin_env(data_EMG.(EMG_names{i}),10, SR_ENG, 88);
    Results.EMG.linenv(:,i) = linenv;
    Results.EMG.RMS(:,i) = RMS;
    plot(t_EMG(35000:39000), data_EMG.(EMG_names{i})((35000:39000)));
    hold on
    plot(t_EMG(35000:39000), Results.EMG.linenv((35000:39000),i), 'color', 'k');
    hold on
    plot(t_EMG(35000:39000), Results.EMG.RMS((35000:39000),i), 'color', 'red');
    legend(EMG_names{i}, 'Butterworth Low', 'RMS')
end


%% Analyse Marker data


figure

Marker_names = fieldnames(data_markers);
num_markers = length(Marker_names);

L=ceil(num_markers^.5);
for i=1:1:num_markers
    subplot(L,L,i)
    d = normal(data_markers.(Marker_names{i})(:,3));
    plot(t_Markers(3500:4000), d(3500:4000))
    hold on
    title(Marker_names{i},' Z coordinate');
end

figure

for i=1:1:num_markers
    subplot(L,L,i)
    d = normal(data_markers.(Marker_names{i})(:,1));
    plot(t_Markers(3500:4000), d(3500:4000))
    hold on
    title(Marker_names{i},' X coordinate');
end

figure

for i=1:1:num_markers
    subplot(L,L,i)
    d = normal(data_markers.(Marker_names{i})(:,1));
    plot(t_Markers(3500:4000), d(3500:4000))
    hold on
    title(Marker_names{i},' Y coordinate');
end


%% Cut gait cycles by using the ankle position
mid_stance = zeros(length(data_markers.RANK(:, 3)), 1);
norm_ank_r = normal(data_markers.RANK(:, 3)) ;
norm_ank_l = normal(data_markers.LANK(:, 3));
ind_list = [];
ind_list(1) = 0;
val_list = [];
for  i=2:length(t_Markers)
    if (abs(norm_ank_r(i) - norm_ank_l(i)) < 1)
        if ((i - ind_list(end))>15)
            mid_stance(i) = 1;
            ind_list = vertcat(ind_list, i);
            val_list = vertcat(val_list, norm_ank_r(i));
    else 
        mid_stance(i) = 0;
        end 
    end 
end

Results.markers.midstance = ind_list(2:end);


figure
scatter(ind_list(2:end), val_list)
hold on 
plot(norm_ank_r )
hold on
plot(norm_ank_l )


function [z, rmsv] = lin_env(data, fco, fs, ts)
    fnyq = fs/2;
    % x = bandpass(data, [fb1 fb2],fs ); not needed as data is already
    % bandpass
    x = data;
    y =abs(x-mean(x));
    [b,a]=butter(4,fco*1.25/fnyq);
    z=filtfilt(b,a,y);
    rmsv = sqrt(movmean(y.^2, ts));   

end

function out = normal(data)
    out = lowpass(data-mean(data), 10, 100);

end




