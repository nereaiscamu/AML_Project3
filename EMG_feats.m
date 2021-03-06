%% FEATURE EXTRACTION FOR EMG SIGNAL, USED FOR NOW FOR HEALTHY PATIENTS

close all; clear all; % a bit of cleaning
%===============================================

DATASET1 = ['DM002_TDM_1kmh_NoEES.mat'];
DATASET2 = ['DM002_TDM_08_1kmh.mat'];
DATASET3 = ['DM002_TDM_08_2kmh.mat'];
DATASET4 = ['AML_02_1.mat'];
DATASET5 = ['AML_02_2.mat'];
DATASET6 = ['AML_02_3.mat'];


dataset_name = DATASET4;
dataset = 4;
load(dataset_name); % choose which datastructure to load
if dataset <4
    N_EMG = length(data.LTA);
    SR_EMG = data.EMG_sr ;
    N_Markers = length(data.LHIP);
    SR_Markers = data.marker_sr;
    if dataset <2
        mask2 = [1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,0,0,0,0,0,0,0,0];
        mask1 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1];
        names = fieldnames(data);
        D = struct2cell(data);
        keep1 = ~mask1;  % As in your example
        keep2 = ~mask2;  % As in your example
        data_EMG = cell2struct(D(keep1), names(keep1));
        data_markers = cell2struct(D(keep2), names(keep2));
    else 
        mask2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0];
        mask1 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1];
        names = fieldnames(data);
        D = struct2cell(data);
        keep1 = ~mask1;  % As in your example
        keep2 = ~mask2;  % As in your example
        data_EMG = cell2struct(D(keep1), names(keep1));
        data_markers = cell2struct(D(keep2), names(keep2));
    end 
else 
    N_EMG = length(EMG.LTA);
    SR_EMG = Info.EMGfq ;
    data_EMG = EMG;
    names = fieldnames(Markers);
    data_markers = Markers;
    mask = [0,0,0,0,0,0,0,0,1, 1, 1, 1, 1, 1];
    names = fieldnames(Markers);
    data_markers = Markers;
    D = struct2cell(Markers);
    keep = ~mask;  % As in your example
    data_markers = cell2struct(D(keep), names(keep));
    N_Markers = length(Markers.LHIP);
    SR_Markers = Info.Kinfq;
end 

   
t_EMG = [];
for i = 1 : N_EMG
    t_EMG(i) = i* 1/SR_EMG;
end 


t_Markers = [];
for i = 1 :N_Markers
    t_Markers(i) = i* 1/SR_Markers ;
end 


Marker_names = fieldnames(data_markers);
num_markers = length(Marker_names);
EMG_names = fieldnames(data_EMG);
num_muscles = length(EMG_names);

% First apply pre-processing 
lowpass_list = [];
RMS_list = [];
env_list = [];
figure
% L=ceil(num_muscles^.5);
for i=1:1:num_muscles
    subplot(2,num_muscles/2,i)
    [low, RMS, env] = EMG_prepross(data_EMG.(EMG_names{i}),10, SR_EMG, 250);
    lowpass_list = horzcat(lowpass_list, low);
    RMS_list = horzcat(RMS_list, RMS);
    env_list = horzcat(env_list, env);
    plot(t_EMG(30000:45000), data_EMG.(EMG_names{i})((30000:45000)));
    hold on
    plot(t_EMG(30000:45000), env_list((30000:45000),i), 'color', 'g');
    hold on
    plot(t_EMG(30000:45000), lowpass_list((30000:45000),i), 'color', 'k');
    hold on
    plot(t_EMG(30000:45000), RMS_list((30000:45000),i), 'color', 'red');
    legend(EMG_names{i}, 'Envelope', 'Butterworth Low', 'RMS', 'Location', 'south')
    title(EMG_names{i})
end


%% 1- POWER SPECTRUM
% I only plot until freq 10 as we applied previously a low pass filter with
% 10Hz cutoff
close all;

amp_spec_list = [];
pow_spec_list = [];

figure

for i=1:1:num_muscles
    subplot(2,num_muscles/2,i)
    [amp_spec, pow_spec] = spectrum1(env_list(:,i), SR_EMG);
    amp_spec_list = horzcat(amp_spec_list, amp_spec);
    pow_spec_list = horzcat(pow_spec_list, pow_spec);
    fnyq = SR_EMG/2;
    N=length(env_list(:,i)); 
    freqs=0:(SR_EMG/N):10; 
    plot(freqs,abs(amp_spec(1:int16(10/(SR_EMG/N)+1))))
    title(strcat(EMG_names{i}, ' amplitude spectrum'))

end


figure
for i=1:1:num_muscles
    subplot(2,num_muscles/2,i)
    [amp_spec, pow_spec] = spectrum1(env_list(:,i), SR_EMG);
    amp_spec_list = horzcat(amp_spec_list, amp_spec);
    pow_spec_list = horzcat(pow_spec_list, pow_spec);
    fnyq = SR_EMG/2;
    N=length(env_list(:,i)); 
    freqs=0:(SR_EMG/N):10; 
    plot(freqs,abs(pow_spec(1:int16(10/(SR_EMG/N)+1))))
    title(strcat(EMG_names{i}, ' power spectrum'))

end





%% 2- BURST DURATION --> needs to be adapted when dividing data into gait cycles

close all;

[onset, offset, thrs, d] = detect_bursts(EMG.LSol, 1000);
figure
plot(d, 'color', 'k')
hold on
yline(thrs, 'color', 'b')
hold on
scatter(onset, d(onset), 'marker', '*')
hold on
scatter(offset, d(offset), 'color', 'yellow')
xlim([30000,50000])
xlabel('Time (ms)')
ylabel('Preprocessed EMG signal')
title('Onset and offset detection for the left Soleus muscle EMG of a healthy patient')
legend('Preprocessed signal', 'Activation threshold', 'Onset', 'Offset')

%%

bursts_dur_list = [];


for i=1:1:num_muscles
    [onset, offset, thrs, d] = detect_bursts(data_EMG.(EMG_names{i}), 1000);
    dur = compute_duration(onset, offset, SR_EMG);
    bursts_dur_list(i) = mean(dur);

end

function [xfft, Pxx] = spectrum1(x, SR)
    fnyq = SR/2;
    N=length(x); 
    freqs=0:(SR/N):10; 
    %Next: compute fft and plot the amplitude spectrum, up to 10Hz. 
    xfft = fft(x-mean(x)); 
    %Next: compute and plot the power spectrum, up to 10Hz.
    Pxx = xfft.*conj(xfft); 
   
end 







