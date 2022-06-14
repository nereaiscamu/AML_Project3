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
Params_Healthy_cyclesplit = [];
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


    %% Kinematic parameters
    
    %Cycle Duration
    Rcycle_durations = diff(RTOs);
    Lcycle_durations = diff(LTOs);
    Params_Healthy.(name).Rcycle_duration = mean(Rcycle_durations)/freq;
    Params_Healthy.(name).Lcycle_duration = mean(Lcycle_durations)/freq;
%     Params_Healthy_cyclesplit.(name).Rcycle_duration = (Rcycle_durations')/freq;
%     Params_Healthy_cyclesplit.(name).Lcycle_duration = (Lcycle_durations')/freq;
    
    Params_Healthy.(name).RTOs = RTOs;
    Params_Healthy.(name).LTOs = LTOs;
    Params_Healthy.(name).RICs = RICs;
	Params_Healthy.(name).LICs = LICs;


    %Treadmill speed
    Treadmillspeed = get_treadmill(name, RANK, freq);

    %Step length   
    [Rmean_step_length, Lmean_step_length, R_step_length, L_step_length] = get_step_length(RANK, LANK, RICs, LICs, Treadmillspeed, freq);
    Params_Healthy.(name).Rstep_length = Rmean_step_length;
    Params_Healthy.(name).Lstep_length = Lmean_step_length;
%     Params_Healthy_cyclesplit.(name).R_step_length = R_step_length';
%     Params_Healthy_cyclesplit.(name).L_step_length = L_step_length';



    %Stride length
    [Rmean_stride_length, Lmean_stride_length, Rvar_stride_length, Lvar_stride_length,R_stride_length, L_stride_length] = get_stride_length(RANK, LANK, RICs, LICs, Treadmillspeed, freq);
    Params_Healthy.(name).Rmean_stride_length = Rmean_stride_length;
    Params_Healthy.(name).Lmean_stride_length = Lmean_stride_length;
    Params_Healthy.(name).Rvar_stride_length = Rvar_stride_length;
    Params_Healthy.(name).Lvar_stride_length = Lvar_stride_length;
    Params_Healthy_cyclesplit.(name).R_stride_length = R_stride_length';
    Params_Healthy_cyclesplit.(name).L_stride_length = L_stride_length';



    %Step height based on Ankle
    [Rmean_step_height, Lmean_step_height, R_step_height, L_step_height] = get_step_height(RTOs, LTOs, RANK, LANK);
    Params_Healthy.(name).Rstep_height = Rmean_step_height;
    Params_Healthy.(name).Lstep_height = Lmean_step_height;
    Params_Healthy_cyclesplit.(name).R_step_height = R_step_height';
    Params_Healthy_cyclesplit.(name).L_step_height = L_step_height';




    %Max Knee angle
    [Rmax_knee_angle, Lmax_knee_angle, R_max_knee_ankle, L_max_knee_ankle] = get_joint_angle(RTOs, LTOs, RANK, LANK, RKNE, LKNE, RHIP, LHIP);
    Params_Healthy.(name).Rmax_knee_angle = Rmax_knee_angle;
    Params_Healthy.(name).Lmax_knee_angle = Lmax_knee_angle;
    Params_Healthy_cyclesplit.(name).R_max_knee_ankle = R_max_knee_ankle';
    Params_Healthy_cyclesplit.(name).L_max_knee_ankle = L_max_knee_ankle';


    %Correlation of Knee and Ankle oscillation
    [Rmean_corr_KA, Lmean_corr_KA, R_corr_KA, L_corr_KA] = get_correlation_KA(RTOs, LTOs, RKNE, LKNE, RANK, LANK);
    Params_Healthy.(name).Rmean_corr_KA = Rmean_corr_KA;
    Params_Healthy.(name).Lmean_corr_KA = Lmean_corr_KA;
    Params_Healthy_cyclesplit.(name).R_corr_Ka = R_corr_KA;
    Params_Healthy_cyclesplit.(name).L_corr_KA = L_corr_KA;

    %Endpoint velocity
    [Rmean_endpoint_vel, Lmean_endpoint_vel, R_endpoint_vel, L_endpoint_vel] = get_endpoint_vel(RTOs, LTOs, RANK, LANK, freq);
    Params_Healthy.(name).Rmean_endpoint_vel = Rmean_endpoint_vel;
    Params_Healthy.(name).Lmean_endpoint_vel = Lmean_endpoint_vel;
    Params_Healthy_cyclesplit.(name).R_endpoint_vel = R_endpoint_vel;
    Params_Healthy_cyclesplit.(name).L_endpoint_vel = L_endpoint_vel;

    %Ratio between forward and lateral movement
    [Rmean_ratio_fl, Lmean_ratio_fl, R_ratio_fl, L_ratio_fl] = get_ratio_fl(RTOs, LTOs, RANK, LANK);
    Params_Healthy.(name).Rmean_ratio_fl = Rmean_ratio_fl;
    Params_Healthy.(name).Lmean_ratio_fl = Lmean_ratio_fl;
    Params_Healthy_cyclesplit.(name).R_ratio_fl = R_ratio_fl;
    Params_Healthy_cyclesplit.(name).L_ratio_fl = L_ratio_fl;

    %Gait stability
    [Mean_gait_stability, gait_stability] = get_gait_stability(RHIP, LHIP, RTOs, LTOs);
    Params_Healthy.(name).Mean_gait_stability = Mean_gait_stability;
    Params_Healthy_cyclesplit.(name).gait_stability = gait_stability;

    %Interlimb coordination
    [Rmean_interlimb_coord, Lmean_interlimb_coord, R_interlimb_coord, L_interlimb_coord] = get_interlimb_coord(RTOs, LTOs, RICs, LICs, freq);
    Params_Healthy.(name).Rmean_interlimb_coord = Rmean_interlimb_coord;
    Params_Healthy.(name).Lmean_interlimb_coord = Lmean_interlimb_coord;
    Params_Healthy_cyclesplit.(name).R_interlimb_coord = R_interlimb_coord';
    Params_Healthy_cyclesplit.(name).L_interlimb_coord = L_interlimb_coord';


    %Whole-limb angular velocity based on thigh
    [Rmean_limb_angular_vel, Lmean_limb_angular_vel, R_limb_ang_vel, L_limb_ang_vel] = get_limb_angular_vel(RHIP, LHIP, RKNE, LKNE, freq, RTOs, LTOs);
    Params_Healthy.(name).Rmean_limb_angular_vel = Rmean_limb_angular_vel;
    Params_Healthy.(name).Lmean_limb_angular_vel = Lmean_limb_angular_vel;
    Params_Healthy_cyclesplit.(name).R_limb_ang_vel = R_limb_ang_vel;
    Params_Healthy_cyclesplit.(name).L_limb_ang_vel = L_limb_ang_vel;

    %% EMG parameters
    N_EMG = length(EMG.LTA);
    N_Markers = length(Markers.LHIP);

    RTOs_EMG = RTOs * (N_EMG/N_Markers);
    LTOs_EMG = LTOs * (N_EMG/N_Markers);

    SR_EMG = Info.EMGfq ;
    data_EMG = EMG;
    t_EMG = [];
    for i = 1 : N_EMG
        t_EMG(i) = i* 1/SR_EMG;
    end 
    EMG_names = fieldnames(data_EMG);
    num_muscles = length(EMG_names);

    % Pre-processing of the EMG signals

    [R_lowpass_TA, R_RMS_TA, R_env_TA] = EMG_prepross(data_EMG.RTA,10, SR_EMG, 250);
    [L_lowpass_TA, L_RMS_TA, L_env_TA] = EMG_prepross(data_EMG.LTA,10, SR_EMG, 250);
    [R_lowpass_ST, R_RMS_ST, R_env_ST] = EMG_prepross(data_EMG.RST,10, SR_EMG, 250);
    [L_lowpass_ST, L_RMS_ST, L_env_ST] = EMG_prepross(data_EMG.LST,10, SR_EMG, 250);
    [R_lowpass_MG, R_RMS_MG, R_env_MG] = EMG_prepross(data_EMG.RGM,10, SR_EMG, 250);
    [L_lowpass_MG, L_RMS_MG, L_env_MG] = EMG_prepross(data_EMG.LGM,10, SR_EMG, 250);
    [R_lowpass_Sol, R_RMS_Sol, R_env_Sol] = EMG_prepross(data_EMG.RSol,10, SR_EMG, 250);
    [L_lowpass_Sol, L_RMS_Sol, L_env_Sol] = EMG_prepross(data_EMG.LSol,10, SR_EMG, 250);


    % Mean RMS signal for each muscle selected
    Params_Healthy.(name).Rmean_RMS_TA = rms(R_env_TA);
    Params_Healthy.(name).Lmean_RMS_TA = rms(L_env_TA);
    Params_Healthy.(name).Rmean_RMS_ST = rms(R_env_ST);
    Params_Healthy.(name).Lmean_RMS_ST = rms(L_env_ST);
    Params_Healthy.(name).Rmean_RMS_MG = rms(R_env_MG);
    Params_Healthy.(name).Lmean_RMS_MG = rms(L_env_MG);
    Params_Healthy.(name).Rmean_RMS_Sol = rms(R_env_Sol);
    Params_Healthy.(name).Lmean_RMS_Sol = rms(L_env_Sol);

    % Mean RMS signal for each gait cycle and muscle selected

    [R_Mean_TA, L_Mean_TA, R_var_TA, L_var_TA] = Mean_EMG(R_env_TA, L_env_TA, RTOs_EMG, LTOs_EMG);
    [R_Mean_ST, L_Mean_ST, R_var_ST, L_var_ST] = Mean_EMG(R_env_ST, L_env_ST, RTOs_EMG, LTOs_EMG);
    [R_Mean_MG, L_Mean_MG, R_var_MG, L_var_MG] = Mean_EMG(R_env_MG, L_env_MG, RTOs_EMG, LTOs_EMG);
    [R_Mean_Sol, L_Mean_Sol, R_var_Sol, L_var_Sol] = Mean_EMG(R_env_Sol, L_env_Sol, RTOs_EMG, LTOs_EMG);

    [R_split_RMS_TA, L_split_RMS_TA] = RMS_EMG(data_EMG.RTA, data_EMG.LTA, RTOs_EMG, LTOs_EMG);
    [R_split_RMS_ST, L_split_RMS_ST] = RMS_EMG(data_EMG.RST, data_EMG.LST, RTOs_EMG, LTOs_EMG);
    [R_split_RMS_MG, L_split_RMS_MG] = RMS_EMG(data_EMG.RGM, data_EMG.LGM, RTOs_EMG, LTOs_EMG);
    [R_split_RMS_Sol, L_split_RMS_Sol] = RMS_EMG(data_EMG.RSol, data_EMG.LSol, RTOs_EMG, LTOs_EMG);

    Params_Healthy_cyclesplit.(name).R_RMS_TA = R_split_RMS_TA;
    Params_Healthy_cyclesplit.(name).L_RMS_TA = L_split_RMS_TA;
%     Params_Healthy_cyclesplit.(name).R_RMS_ST = R_split_RMS_ST;
%     Params_Healthy_cyclesplit.(name).L_RMS_ST = L_split_RMS_ST;
%     Params_Healthy_cyclesplit.(name).R_RMS_MG = R_split_RMS_MG;
%     Params_Healthy_cyclesplit.(name).L_RMS_MG = L_split_RMS_MG;
    Params_Healthy_cyclesplit.(name).R_RMS_Sol = R_split_RMS_Sol;
    Params_Healthy_cyclesplit.(name).L_RMS_Sol = L_split_RMS_Sol;


%     Params_Healthy_cyclesplit.(name).R_Mean_TA = R_Mean_TA;
%     Params_Healthy_cyclesplit.(name).L_Mean_TA = L_Mean_TA;
% %     Params_Healthy_cyclesplit.(name).R_Mean_ST = R_Mean_ST;
% %     Params_Healthy_cyclesplit.(name).L_Mean_ST = L_Mean_ST;
% %     Params_Healthy_cyclesplit.(name).R_Mean_MG = R_Mean_MG;
% %     Params_Healthy_cyclesplit.(name).L_Mean_MG = L_Mean_MG;
%     Params_Healthy_cyclesplit.(name).R_Mean_Sol = R_Mean_Sol;
%     Params_Healthy_cyclesplit.(name).L_Mean_Sol = L_Mean_Sol;

%     Params_Healthy_cyclesplit.(name).R_var_TA = R_var_TA;
%     Params_Healthy_cyclesplit.(name).L_var_TA = L_var_TA;
% %     Params_Healthy_cyclesplit.(name).R_var_ST = R_var_ST;
% %     Params_Healthy_cyclesplit.(name).L_var_ST = L_var_ST;
% %     Params_Healthy_cyclesplit.(name).R_var_MG = R_var_MG;
% %     Params_Healthy_cyclesplit.(name).L_var_MG = L_var_MG;
%     Params_Healthy_cyclesplit.(name).R_var_Sol = R_var_Sol;
%     Params_Healthy_cyclesplit.(name).L_var_Sol = L_var_Sol;

    % Burst Duration
     [R_burst_dur_TA, L_burst_dur_TA] = burst_duration(R_env_TA, L_env_TA, RTOs_EMG, LTOs_EMG, SR_EMG);
     [R_burst_dur_ST, L_burst_dur_ST] = burst_duration(R_env_ST, L_env_ST, RTOs_EMG, LTOs_EMG, SR_EMG);
     [R_burst_dur_MG, L_burst_dur_MG] = burst_duration(R_env_MG, L_env_MG, RTOs_EMG, LTOs_EMG, SR_EMG);
     [R_burst_dur_Sol, L_burst_dur_Sol] = burst_duration(R_env_Sol, L_env_Sol, RTOs_EMG, LTOs_EMG, SR_EMG);
    
     R_burst_dur_TA(isnan(R_burst_dur_TA))=0;
     L_burst_dur_TA(isnan(L_burst_dur_TA)) = 0;
     R_burst_dur_ST(isnan(R_burst_dur_ST)) = 0;
     L_burst_dur_ST(isnan(L_burst_dur_ST)) = 0;
     R_burst_dur_MG(isnan(R_burst_dur_MG)) = 0;
     L_burst_dur_MG(isnan(L_burst_dur_MG)) = 0;
     R_burst_dur_Sol(isnan(R_burst_dur_Sol)) = 0;
     L_burst_dur_Sol(isnan(L_burst_dur_Sol)) = 0;

    Params_Healthy.(name).R_burst_dur_TA = mean(R_burst_dur_TA);
    Params_Healthy.(name).L_burst_dur_TA = mean(L_burst_dur_TA);
%     Params_Healthy.(name).R_burst_dur_ST = mean(R_burst_dur_ST);
%     Params_Healthy.(name).L_burst_dur_ST = mean(L_burst_dur_ST);
%     Params_Healthy.(name).R_burst_dur_MG = mean(R_burst_dur_MG);
%     Params_Healthy.(name).L_burst_dur_MG = mean(L_burst_dur_MG);
    Params_Healthy.(name).R_burst_dur_Sol = mean(R_burst_dur_Sol);
    Params_Healthy.(name).L_burst_dur_Sol = mean(L_burst_dur_Sol);


    Params_Healthy_cyclesplit.(name).R_burst_dur_TA = R_burst_dur_TA;
    Params_Healthy_cyclesplit.(name).L_burst_dur_TA = L_burst_dur_TA;
%     Params_Healthy_cyclesplit.(name).R_burst_dur_ST = R_burst_dur_ST;
%     Params_Healthy_cyclesplit.(name).L_burst_dur_ST = L_burst_dur_ST;
%     Params_Healthy_cyclesplit.(name).R_burst_dur_MG = R_burst_dur_MG;
%     Params_Healthy_cyclesplit.(name).L_burst_dur_MG = L_burst_dur_MG;
    Params_Healthy_cyclesplit.(name).R_burst_dur_Sol = R_burst_dur_Sol;
    Params_Healthy_cyclesplit.(name).L_burst_dur_Sol = L_burst_dur_Sol;


      % Power spectrum
   [R_lowfreq_pow_TA, L_lowfreq_pow_TA ,R_medfreq_TA, L_medfreq_TA] = spectrum(R_env_TA, L_env_TA, 100, 50, RTOs_EMG, LTOs_EMG);
   [R_lowfreq_pow_ST, L_lowfreq_pow_ST,R_medfreq_ST, L_medfreq_ST] = spectrum(R_env_ST, L_env_ST, 100, 50, RTOs_EMG, LTOs_EMG);
   [R_lowfreq_pow_MG, L_lowfreq_pow_MG,R_medfreq_MG, L_medfreq_MG] = spectrum(R_env_MG, L_env_MG, 100, 50, RTOs_EMG, LTOs_EMG);
   [R_lowfreq_pow_Sol, L_lowfreq_pow_Sol,R_medfreq_Sol, L_medfreq_Sol] = spectrum(R_env_Sol, L_env_Sol, 100, 50, RTOs_EMG, LTOs_EMG);

%     Params_Healthy_cyclesplit.(name).R_lowfreq_pow_TA = R_lowfreq_pow_TA;
%     Params_Healthy_cyclesplit.(name).L_lowfreq_pow_TA = L_lowfreq_pow_TA;
% %     Params_Healthy_cyclesplit.(name).R_lowfreq_pow_ST = R_lowfreq_pow_ST;
% %     Params_Healthy_cyclesplit.(name).L_lowfreq_pow_ST = L_lowfreq_pow_ST;
% %     Params_Healthy_cyclesplit.(name).R_lowfreq_pow_MG = R_lowfreq_pow_MG;
% %     Params_Healthy_cyclesplit.(name).L_lowfreq_pow_MG = L_lowfreq_pow_MG;
%     Params_Healthy_cyclesplit.(name).R_lowfreq_pow_Sol = R_lowfreq_pow_Sol;
%     Params_Healthy_cyclesplit.(name).L_lowfreq_pow_Sol = L_lowfreq_pow_Sol;	

    Params_Healthy_cyclesplit.(name).R_medfreq_TA = R_medfreq_TA;
    Params_Healthy_cyclesplit.(name).L_medfreq_TA = L_medfreq_TA;
%     Params_Healthy_cyclesplit.(name).R_medfreq_ST = R_medfreq_ST;
%     Params_Healthy_cyclesplit.(name).L_medfreq_ST = L_medfreq_ST;
%     Params_Healthy_cyclesplit.(name).R_medfreq_MG = R_medfreq_MG;
%     Params_Healthy_cyclesplit.(name).L_medfreq_MG = L_medfreq_MG;
    Params_Healthy_cyclesplit.(name).R_medfreq_Sol = R_medfreq_Sol;
    Params_Healthy_cyclesplit.(name).L_medfreq_Sol = L_medfreq_Sol;	


    
end

%% Saving results

save('Healthy_data.mat','Params_Healthy_cyclesplit')