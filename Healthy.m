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

Params_Healthy = [];
dataset_list = ['AML_01_1.mat'; 'AML_01_2.mat';'AML_01_3.mat'; 'AML_02_1.mat'; 'AML_02_2.mat';'AML_02_3.mat'];

%% Gait event dedection
for idx = 1:6
    load(dataset_list(idx,:))

    %Time
    time_EMG = [];
    time_Marker = [];
    for i = 1 : length(EMG.LGM)
        time_EMG(i) = i* 1/Info.EMGfq ;
    end
    for i = 1: length(Markers.LANK)
        time_Marker(i) = i* 1/Info.Kinfq;
    end

    name = erase(dataset_list(idx,:), ".mat");
    freq = Info.Kinfq;
    
    RANK = Markers.RANK - mean(Markers.RANK);
    LANK = Markers.LANK - mean(Markers.LANK);
    RHIP = Markers.RHIP - mean(Markers.RHIP);
    LHIP = Markers.LHIP - mean(Markers.LHIP);
    RKNE = Markers.RKNE - mean(Markers.RKNE);
    LKNE = Markers.LKNE - mean(Markers.LKNE);
   
    %Gait cycle events detection (TO and IC)
    [RTOs, LTOs, RICs, LICs] = gait_cycle_events(RANK, LANK, RKNE, LKNE, RHIP, LHIP);
    
    %Cycle Duration
    Rcycle_durations = diff(RTOs);
    Lcycle_durations = diff(LTOs);
    Params_Healthy.(name).Rcycle_duration = mean(Rcycle_durations)/freq;
    Params_Healthy.(name).Lcycle_duration = mean(Lcycle_durations)/freq;
    
    Params_Healthy.(name).RTOs = RTOs;
    Params_Healthy.(name).LTOs = LTOs;
    Params_Healthy.(name).RICs = RICs;
    Params_Healthy.(name).LICs = LICs;

    %Treadmill speed
    Treadmillspeed = get_treadmill(name, RANK, freq);

    %Step length   
    [Rmean_step_length, Lmean_step_length] = get_step_length(RANK, LANK, RICs, LICs, Treadmillspeed, freq);
    Params_Healthy.(name).Rstep_length = Rmean_step_length;
    Params_Healthy.(name).Lstep_length = Lmean_step_length;

    %Stride length
    [Rmean_stride_length, Lmean_stride_length, Rvar_stride_length, Lvar_stride_length] = get_stride_length(RANK, LANK, RICs, LICs, Treadmillspeed, freq);
    Params_Healthy.(name).Rmean_stride_length = Rmean_stride_length;
    Params_Healthy.(name).Lmean_stride_length = Lmean_stride_length;
    Params_Healthy.(name).Rvar_stride_length = Rvar_stride_length;
    Params_Healthy.(name).Lvar_stride_length = Lvar_stride_length;

    %Step height based on Ankle
    [Rmean_step_height, Lmean_step_height] = get_step_height(RTOs, LTOs, RANK, LANK);
    Params_Healthy.(name).Rstep_height = Rmean_step_height;
    Params_Healthy.(name).Lstep_height = Lmean_step_height;

    %Max Knee angle
    [Rmax_knee_angle, Lmax_knee_angle] = get_joint_angle(RTOs, LTOs, RANK, LANK, RKNE, LKNE, RHIP, LHIP);
    Params_Healthy.(name).Rmax_knee_angle = Rmax_knee_angle;
    Params_Healthy.(name).Lmax_knee_angle = Lmax_knee_angle;
end