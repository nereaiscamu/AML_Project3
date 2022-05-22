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

load(DATASET1); % choose which datastructure to load
Results = [];

%%  ------------- (1) ASSIGNEMENT 1: DETECT GAIT EVENTS ----------------------

times = [];
for i = 1 : length(data.CBack)
    times(i) = i* 1/data.EMG_sr ;
end 

%% PLOT EMG FILTERED SIGNAL (RMS) 
% (it reflects the physiological activity during contraction)
names = fieldnames(data);
figure

for i=1:8
    plot_ind = 420+i;
    subplot(plot_ind)
    [linenv, RMS] = lin_env(data.(names{i}), 5, 499, 50, 1000, 88);
    Results.EMG.linenv(:,i) = linenv;
    Results.EMG.RMS(:,i) = RMS;
    plot(times(35000:39000), data.(names{i})((35000:39000)));
    hold on
    plot(times(35000:39000), Results.EMG.linenv((35000:39000),i), 'color', 'k');
    hold on
    plot(times(35000:39000), Results.EMG.RMS((35000:39000),i), 'color', 'red');
    legend(names{i})
end


%% Analyse Marker data
t2 = [];
for i = 1 : length(data.LTOE)
    t2(i) = i* 1/data.marker_sr ;
end 

figure


for i=19:22
    plot_ind = 220+(i-18);
    subplot(plot_ind)
    d = normal(data.(names{i})(:,3));
    d2 = normal(data.(names{i+4})(:,3));
    plot(t2(3500:4000), d(3500:4000))
    hold on
    plot(t2(3500:4000), d2(3500:4000));
    hold on
    title(names{i},' Z coordinate');
    legend('left', 'right')
end


%%
figure
for i=19:22
    plot_ind = 420+(i-18);
    subplot(plot_ind)
    d = normal(data.(names{i})(:,1));
    d2 = normal(data.(names{i+4})(:,1));
    plot(t2(3500:4000), d(3500:4000))
    hold on
    plot(t2(3500:4000), d2(3500:4000));
    hold on
    title(names{i},'X coordinate');
    legend('left', 'right')
end


figure
for i=19:22
    plot_ind = 420+(i-18);
    subplot(plot_ind)
    d = normal(data.(names{i})(:,2));
    d2 = normal(data.(names{i+4})(:,2));
    plot(t2(3500:4000), d(3500:4000))
    hold on
    plot(t2(3500:4000), d2(3500:4000));
    hold on
    title(names{i},'Y coordinate');
    legend('left', 'right')
end

%% Cut gait cycles by using the ankle position
mid_stance = zeros(length(data.RANK(:, 3)), 1);
norm_ank_r = normal(data.RANK(:, 3)) ;
norm_ank_l = normal(data.LANK(:, 3));
ind_list = [];
ind_list(1) = 0;
val_list = [];
for  i=2:length(t2)
    if (abs(norm_ank_r(i) - norm_ank_l(i)) < 0.5)
        if ((i - ind_list(end))>30)
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


function [z, rmsv] = lin_env(data, fb1, fb2, fco, fs, ts)
    fnyq = fs/2;
    x = bandpass(data, [fb1 fb2],fs );
    x = bandstop(x, [48 52], fs);
    %x = data;
    %y=abs(x-mean(x));
    y=abs(x);
    [b,a]=butter(2,fco*1.25/fnyq);
    z=filtfilt(b,a,y)*5;
    rmsv = sqrt(movmean(x.^2, ts))*5;   

end

function out = normal(data)
    out = lowpass(data-mean(data), 1, 100);

end



