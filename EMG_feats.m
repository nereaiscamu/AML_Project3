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

% First apply pre-processing as in main
linenv_list = [];
RMS_list = [];
figure
% L=ceil(num_muscles^.5);
for i=1:1:num_muscles
    subplot(2,num_muscles/2,i)
    [linenv, RMS] = lin_env(data_EMG.(EMG_names{i}),10, SR_EMG, 300);
    linenv_list = horzcat(linenv_list, linenv);
    RMS_list = horzcat(RMS_list, RMS);
    plot(t_EMG(35000:39000), data_EMG.(EMG_names{i})((35000:39000)));
    hold on
    plot(t_EMG(35000:39000), linenv_list((35000:39000),i), 'color', 'k');
    hold on
    plot(t_EMG(35000:39000), RMS_list((35000:39000),i), 'color', 'red');
    legend(EMG_names{i}, 'Butterworth Low', 'RMS', 'Location', 'south')
    title(EMG_names{i})
end

%% 1- POWER SPECTRUM
% I only plot until freq 10 as we applied previously a low pass filter with
% 10Hz cutoff

amp_spec_list = [];
pow_spec_list = [];

figure

for i=1:1:num_muscles
    subplot(2,num_muscles/2,i)
    [amp_spec, pow_spec] = spectrum(linenv_list(:,i));
    amp_spec_list = horzcat(amp_spec_list, amp_spec);
    pow_spec_list = horzcat(pow_spec_list, pow_spec);
    fnyq = SR_EMG/2;
    N=length(linenv_list(:,i)); 
    freqs=0:(SR_EMG/N):10; 
    plot(freqs,abs(amp_spec(1:int16(10/(SR_EMG/N)+1))))
    title(strcat(EMG_names{i}, ' amplitude spectrum'))

end


figure
for i=1:1:num_muscles
    subplot(2,num_muscles/2,i)
    [amp_spec, pow_spec] = spectrum(linenv_list(:,i));
    amp_spec_list = horzcat(amp_spec_list, amp_spec);
    pow_spec_list = horzcat(pow_spec_list, pow_spec);
    fnyq = SR_EMG/2;
    N=length(linenv_list(:,i)); 
    freqs=0:(SR_EMG/N):10; 
    plot(freqs,abs(pow_spec(1:int16(10/(SR_EMG/N)+1))))
    title(strcat(EMG_names{i}, ' power spectrum'))

end


%% 2- BURST DURATION

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


bursts_dur_list = [];
onsets_list = [];
offsets_list = [];

for i=1:1:num_muscles
    [onset, offset, thrs, d] = detect_bursts(data_EMG.(EMG_names{i}), 1000);
    dur = compute_duration(onset, offset, SR_EMG);
    bursts_dur_list = horzcat (bursts_dur_list, dur);
    onsets_list = horzcat(onsets_list, onset);
    offsets_list = horzcat(offsets_list, offset);
end


%NO SE PUEDEN CONCATENAR HORIZONTALMENTE YA QUE NO TODOS LOS MUSCULOS SE
%ACTIVAN EL MISMO NUM DE VECES




function bursts_dur = compute_duration(onsets, offsets, SR)
    bursts_dur = [];
    if offsets(1)<onsets(1)
        offsets = offsets(2:end);
    end
    max_length = min(length(onsets), length(offsets));
    for i=1:max_length
        bursts_dur = [bursts_dur; (offsets(i)-onsets(i))/SR];
    end

end



function [onset, offset, thrs, d] = detect_bursts(sig, fs)
    onset = [];
    offset = [];
    %They high-pass filtered the raw EMG before applying the TKE operator
    %("6th order, high pass filter at 20 Hz”) 
    % They low-pass filtered the TKE signal y(n) (“6th order, zero-phase 
    % lowpass filter at 50 Hz”) before threshold detection. 
    % TKE = x(n)^2 - (x(n-1)*x(n+1))
    % Threshold = mean(TKE)+ J*std(TKE)
    % They used J=15.
    fnyq = fs/2;
    x = sig;
    y =abs(x-mean(x));
    [b,a]=butter(6,20/fnyq, "high");
    z=filtfilt(b,a,y);
    [b2, a2] = butter(6,45/fnyq, "low");
    z2 = filtfilt(b2,a2,z);    
    c = [];    
    for i=2:length(z2)-1
        c(i-1) = z2(i)^2 -(z2(i+1)*z2(i-1));
    end
    d= sqrt(movmean(c.^2, 500)); % 500 sample window for the RMS as 
    % it makes it easier to detect the burst    
    rem = median(c) + 1.5*iqr(c); 
    rest = c(c<=rem); % I use the mean only of the rest muscle period
    thrs = mean(rest)+2*std(rest);
    N = length(d);
    for i=2:N
        if d(i-1)<thrs && d(i)>=thrs && i<(N-50) && all(d(i:i+50)>=thrs)
                onset = [onset; i];
        end 
        if d(i-1)>thrs && d(i)<=thrs && i>50 && all(d(i-50:i-1)>=thrs)
                offset = [offset; i];        
        end
    end
end

function [xfft, Pxx] = spectrum(x)
    %Next: compute fft and plot the amplitude spectrum, up to 10Hz. 
    xfft = fft(x-mean(x)); 

    %Next: compute and plot the power spectrum, up to 10Hz.
    Pxx = xfft.*conj(xfft); 

end 


function [z, rmsv] = lin_env(data, fco, fs, ts)
%The cutoff frequency is adjusted upward by 25% because the filter will be 
% applied twice (forward and backward). The adjustment assures that the 
% actual -3dB frequency after two passes will be the desired fco specified
% above. This 25% adjustment factor is correct for a 2nd order Butterworth;
% for a 4th order Butterworth used twice, multiply by 1.116.
    fnyq = fs/2;
    x = data;
    y =abs(x-mean(x));
    [b,a]=butter(4,fco* 1.116/fnyq, "low");
    z=filtfilt(b,a,y);
    rmsv = sqrt(movmean(y.^2, ts));   

end