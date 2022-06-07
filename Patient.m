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

Params_Patient = [];
dataset_list = ["DM002_TDM_08_1kmh.mat"; "DM002_TDM_08_2kmh.mat"; "DM002_TDM_1kmh_NoEES.mat"];

%%  ------------- (1) ASSIGNEMENT 1: Varibales Healthy Gait ----------------------

for idx = 1:3
    load(dataset_list(idx,:))

    %Time
    time_EMG = [];
    time_Marker = [];
    for i = 1 : length(data.LTA)
        time_EMG(i) = i* 1/data.EMG_sr ;
    end
    for i = 1: length(data.LANK)
        time_Marker(i) = i* 1/data.marker_sr;
    end

    name = erase(dataset_list(idx,:), ".mat");
    freq = data.marker_sr;
    
    RTOE = data.RTOE - mean(data.RTOE);
    LTOE = data.LTOE - mean(data.LTOE);
    RANK = data.RANK - mean(data.RANK);
    LANK = data.LANK - mean(data.LANK);
    RHIP = data.RHIP - mean(data.RHIP);
    LHIP = data.LHIP - mean(data.LHIP);
    RKNE = data.RKNE - mean(data.RKNE);
    LKNE = data.LKNE - mean(data.LKNE);

    %Gait cycle events detection (TO and IC)
    [RTOs, LTOs, RICs, LICs] = gait_cycle_events(RANK, LANK, RKNE, LKNE, RHIP, LHIP);
    
    %Cycle Duration
    Rcycle_durations = diff(RTOs);
    Lcycle_durations = diff(LTOs);
    Params_Patient.(name).Rcycle_duration = mean(Rcycle_durations)/freq;
    Params_Patient.(name).Lcycle_duration = mean(Lcycle_durations)/freq;
    
    Params_Patient.(name).RTOs = RTOs;
    Params_Patient.(name).LTOs = LTOs;
    Params_Patient.(name).RICs = RICs;
    Params_Patient.(name).LICs = LICs;

    %Treadmill speed
    Treadmillspeed = get_treadmill(name, RANK, freq);

    %Step length   
    [Rmean_step_length, Lmean_step_length] = get_step_length(RANK, LANK, RICs, LICs, Treadmillspeed, freq);
    Params_Patient.(name).Rstep_length = Rmean_step_length;
    Params_Patient.(name).Lstep_length = Lmean_step_length;

    %Stride length
    [Rmean_stride_length, Lmean_stride_length, Rvar_stride_length, Lvar_stride_length] = get_stride_length(RANK, LANK, RICs, LICs, Treadmillspeed, freq);
    Params_Patient.(name).Rmean_stride_length = Rmean_stride_length;
    Params_Patient.(name).Lmean_stride_length = Lmean_stride_length;
    Params_Patient.(name).Rvar_stride_length = Rvar_stride_length;
    Params_Patient.(name).Lvar_stride_length = Lvar_stride_length;

    %Step height based on Ankle
    [Rmean_step_height, Lmean_step_height] = get_step_height(RTOs, LTOs, RANK, LANK);
    Params_Patient.(name).Rstep_height = Rmean_step_height;
    Params_Patient.(name).Lstep_height = Lmean_step_height;

    %Max Knee angle
    [Rmax_knee_angle, Lmax_knee_angle] = get_joint_angle(RTOs, LTOs, RANK, LANK, RKNE, LKNE, RHIP, LHIP);
    Params_Patient.(name).Rmax_knee_angle = Rmax_knee_angle;
    Params_Patient.(name).Lmax_knee_angle = Lmax_knee_angle;
    

end