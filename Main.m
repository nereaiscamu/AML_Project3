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


Results = [];
%dataset_list = [{'DM002_TDM_1kmh_NoEES.mat'};{'DM002_TDM_08_1kmh.mat'}; {'DM002_TDM_08_2kmh.mat'}; {'AML_02_1.mat'}; {'AML_02_2.mat'};{'AML_02_3.mat'}];
dataset_list = [ {'AML_02_1.mat'}];

%%

for i=1:length(dataset_list)
    [linenv_list,RMS_list, ind_list, Llocs, Rlocs,  SR_Markers ] = main(cell2mat(dataset_list(i)), 4);
    %close all;
    if i == 1
        disp('True1')
        Results.Patient_NoEES.EMG.linenv = linenv_list;
        Results.Patient_NoEES.EMG.RMS = RMS_list;
        Results.Patient_NoEES.markers.stance = ind_list(2:end);
        Results.Patient_NoEES.Lgct = mean(diff(Llocs/SR_Markers));
        Results.Patient_NoEES.Rgct = mean(diff(Rlocs/SR_Markers));
    elseif  i == 2
        disp('True2')
        Results.Patient_EES_1km.EMG.linenv = linenv_list;
        Results.Patient_EES_1km.EMG.RMS = RMS_list;
        Results.Patient_EES_1km.markers.stance = ind_list(2:end);
        Results.Patient_EES_1km.Lgct = mean(diff(Llocs/SR_Markers));
        Results.Patient_EES_1km.Rgct = mean(diff(Llocs/SR_Markers));
    elseif i == 3
        disp('True3')
        Results.Patient_EES_gradient.EMG.linenv = linenv_list;
        Results.Patient_EES_gradient.EMG.RMS = RMS_list;
        Results.Patient_EES_gradient.markers.stance = ind_list(2:end);
        Results.Patient_EES_gradient.Lgct = mean(diff(Llocs/SR_Markers));
        Results.Patient_EES_gradient.Rgct = mean(diff(Llocs/SR_Markers));
    elseif i == 4
        disp('True4')
        Results.Healthy1.EMG.linenv = linenv_list;
        Results.Healthy1.EMG.RMS = RMS_list;
        Results.Healthy1.markers.stance = ind_list(2:end);
        Results.Healthy1.Lgct = mean(diff(Llocs/SR_Markers));
        Results.Healthy1.Rgct = mean(diff(Llocs/SR_Markers));
    elseif i == 5
        disp('True5')
        Results.Healthy2.EMG.linenv = linenv_list;
        Results.Healthy2.EMG.RMS = RMS_list;
        Results.Healthy2.markers.stance = ind_list(2:end);
        Results.Healthy2.Lgct = mean(diff(Llocs/SR_Markers));
        Results.Healthy2.Rgct = mean(diff(Llocs/SR_Markers));
    elseif i == 6
        disp('True6')
        Results.Healthy3.EMG.linenv = linenv_list;
        Results.Healthy3.EMG.RMS = RMS_list;
        Results.Healthy3.markers.stance = ind_list(2:end);
        Results.Healthy3.Lgct = mean(diff(Llocs/SR_Markers));
        Results.Healthy3.Rgct = mean(diff(Llocs/SR_Markers));
    end
end

function [linenv_list,RMS_list, ind_list, Llocs, Rlocs,  SR_Markers ] = main(dataset_name, dataset_number)
    %%  ------------- (1) ASSIGNEMENT 1: Varibales Healthy Gait ----------------------
    dataset = dataset_number;
    load(dataset_name); % choose which datastructure to load
    if dataset <4
        N_EMG = length(data.LTA);
        SR_ENG = data.EMG_sr ;
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
        SR_ENG = Info.EMGfq ;
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
        t_EMG(i) = i* 1/SR_ENG;
    end 
    
    
    t_Markers = [];
    for i = 1 :N_Markers
        t_Markers(i) = i* 1/SR_Markers ;
    end 
    
    
    Marker_names = fieldnames(data_markers);
    num_markers = length(Marker_names);
    EMG_names = fieldnames(data_EMG);
    num_muscles = length(EMG_names);
    
    %% PLOT EMG SIGNAL AFTER PREPROCESSING (LINEAR ENVELOPE)
    % (RMS and linear envelope reflects the physiological activity during 
    % contraction)
    linenv_list = [];
    RMS_list = [];
    figure
    % L=ceil(num_muscles^.5);
    for i=1:1:num_muscles
        subplot(2,num_muscles/2,i)
        [linenv, RMS] = lin_env(data_EMG.(EMG_names{i}),10, SR_ENG, 300);
        linenv_list = horzcat(linenv_list, linenv);
        RMS_list = horzcat(RMS_list, RMS);
        plot(t_EMG(35000:39000), data_EMG.(EMG_names{i})((35000:39000)));
        hold on
        plot(t_EMG(35000:39000), linenv_list((35000:39000),i), 'color', 'k');
        hold on
        plot(t_EMG(35000:39000), RMS_list((35000:39000),i), 'color', 'red');
        legend(EMG_names{i}, 'Butterworth Low', 'RMS', 'Location', 'south')
        title(EMG_names{i})
    %     if i < num_muscles
    %       set(gca,'XTick',[]);
    %     end   
    end
    
    
    %% Analyse Marker data
    figure
    
    for i=1:1:num_markers
        subplot(num_markers/2,2,i)
        d = normal(data_markers.(Marker_names{i})(:,3));
        plot(t_Markers(3500:4000), d(3500:4000))
        hold on
        title(Marker_names{i},' Z coordinate');
    end
    
    figure
    
    for i=1:1:num_markers
        subplot(num_markers/2,2,i)
        d = normal(data_markers.(Marker_names{i})(:,1));
        plot(t_Markers(3500:4000), d(3500:4000))
        hold on
        title(Marker_names{i},' X coordinate');
    end
    
    figure
    
    for i=1:1:num_markers
        subplot(num_markers/2,2,i)
        d = normal(data_markers.(Marker_names{i})(:,1));
        plot(t_Markers(3500:4000), d(3500:4000))
        hold on
        title(Marker_names{i},' Y coordinate');
    end
    
    
    %% Cut gait cycles by using the ankle position
    stance = zeros(length(data_markers.RANK(:, 3)), 1);
    norm_ank_r = normal(data_markers.RANK(:, 3)) ;
    norm_ank_l = normal(data_markers.LANK(:, 3));
    ind_list = [];
    ind_list(1) = 0;
    val_list = [];
    for  i=2:length(t_Markers)
        if (abs(norm_ank_r(i) - norm_ank_l(i)) < 1)
            if ((i - ind_list(end))>15)
                stance(i) = 1;
                ind_list = vertcat(ind_list, i);
                val_list = vertcat(val_list, norm_ank_r(i));
        else 
            stance(i) = 0;
            end 
        end 
    end
    figure
    plot(norm_ank_l)
    hold on
    plot(norm_ank_r)
    hold on
    scatter(ind_list(2:end), val_list, '*', 'color', 'red')
    
    
    %%  ------------- (1) ASSIGNEMENT 1: Healty Gait - Seperation into cycles ----------------------
    
    d_right = data_markers.RANK(:,3)-data_markers.RKNE(:,3) - mean(data_markers.RANK(:,3)- data_markers.RKNE(:,3));
    d_left = data_markers.LANK(:,3)-data_markers.LKNE(:,3) - mean(data_markers.LANK(:,3)- data_markers.LKNE(:,3));
    
    [Lpks,Llocs] = findpeaks(d_left, 'MinPeakProminence',50);
    figure
    plot(t_Markers, d_left)
    hold on
    plot(Llocs/SR_Markers, Lpks, 'o')
    xlim([10,30])
    
    [Rpks,Rlocs] = findpeaks(d_right, 'MinPeakProminence',50);
    figure
    plot(t_Markers, d_right)
    hold on
    plot(Rlocs/SR_Markers, Rpks, 'o')
    xlim([10,30])
    
    %% COMPARISON BETWEEN 2 METHODS TO CUT THE GAIT CYCLES 
    % It seems the two methods are comparable and can be used for the task
    
    figure
    plot(t_Markers, d_left)
    hold on
    plot(Llocs/SR_Markers, Lpks, 'o', 'color', 'k')
    hold on
    plot(t_Markers, d_right)
    hold on
    plot(Rlocs/SR_Markers, Rpks, 'o', 'color', 'red')
    hold on
    scatter(ind_list(2:end)/SR_Markers, val_list, '*')
    xlim([10,30])
    legend('Left foot', 'Peaks left', 'Right foot', 'Peaks Right', 'Gait cycle division method 1')
    title('Data separation into gait cycles')

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

function out = normal(data)
    out = (data-mean(data)) ;

end

function out = normal2(data)
    out = (data-min(data)) / (max(data)-min(data));

end


function [xfft, Pxx] = spectrum(x, SR)
    fnyq = SR/2;
    N=length(x); 
    freqs=0:(SR/N):10; 
    %Next: compute fft and plot the amplitude spectrum, up to 10Hz. 
    xfft = fft(x-mean(x)); 
    figure; 
    plot(freqs,abs(xfft(1:2559))); 
    %Next: compute and plot the power spectrum, up to 10Hz.
    Pxx = xfft.*conj(xfft); 
    figure; 
    plot(freqs,abs(Pxx(1:2559))); 
end 

