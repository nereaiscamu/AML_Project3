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
Params_Patient_cyclesplit = [];
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
    

    %Treadmill speed
    Treadmillspeed = get_treadmill(name, RANK, freq);
													

    %Stride length
	[Rmean_stride_length, Lmean_stride_length, Rvar_stride_length, Lvar_stride_length, R_stride_length, L_stride_length] = get_stride_length(RANK, LANK, RICs, LICs, Treadmillspeed, freq);
	Params_Patient_cyclesplit.(name).R_stride_length = R_stride_length';
    Params_Patient_cyclesplit.(name).L_stride_length = L_stride_length';																	

    %Step height based on Ankle
    [Rmean_step_height, Lmean_step_height, R_step_height, L_step_height] = get_step_height(RTOs, LTOs, RANK, LANK);
    Params_Patient_cyclesplit.(name).R_step_height = R_step_height';
    Params_Patient_cyclesplit.(name).L_step_height = L_step_height';																	

    %Max Knee angle
    [Rmax_knee_angle, Lmax_knee_angle, R_max_knee_ankle, L_max_knee_ankle] = get_joint_angle(RTOs, LTOs, RANK, LANK, RKNE, LKNE, RHIP, LHIP);
    Params_Patient_cyclesplit.(name).R_max_knee_ankle = R_max_knee_ankle';
    Params_Patient_cyclesplit.(name).L_max_knee_ankle = L_max_knee_ankle';
    %Correlation of Knee and Ankle oscillation
    [Rmean_corr_KA, Lmean_corr_KA, R_corr_KA, L_corr_KA] = get_correlation_KA(RTOs, LTOs, RKNE, LKNE, RANK, LANK);
    Params_Patient_cyclesplit.(name).R_corr_KA = R_corr_KA;
    Params_Patient_cyclesplit.(name).L_corr_KA = L_corr_KA;														   

    %Endpoint velocity
    [Rmean_endpoint_vel, Lmean_endpoint_vel, R_endpoint_vel, L_endpoint_vel] = get_endpoint_vel(RTOs, LTOs, RANK, LANK, freq);
	Params_Patient_cyclesplit.(name).R_endpoint_vel = R_endpoint_vel;
    Params_Patient_cyclesplit.(name).L_endpoint_vel = L_endpoint_vel;																 

    %Ratio between forward and lateral movement
    [Rmean_ratio_fl, Lmean_ratio_fl,  R_ratio_fl, L_ratio_fl] = get_ratio_fl(RTOs, LTOs, RANK, LANK);
    Params_Patient_cyclesplit.(name).R_ratio_fl = R_ratio_fl;
    Params_Patient_cyclesplit.(name).L_ratio_fl = L_ratio_fl;															 

    %Gait stability
    [Mean_gait_stability, gait_stability] = get_gait_stability(RHIP, LHIP, RTOs, LTOs);
    Params_Patient_cyclesplit.(name).gait_stability = gait_stability;
	
	%Interlimb coordination
	[Rmean_interlimb_coord, Lmean_interlimb_coord, R_interlimb_coord, L_interlimb_coord] = get_interlimb_coord(RTOs, LTOs, RICs, LICs, freq);
	Params_Patient_cyclesplit.(name).R_interlimb_coord = R_interlimb_coord';
    Params_Patient_cyclesplit.(name).L_interlimb_coord = L_interlimb_coord';																		

    %Whole-limb angular velocity based on thigh
    [Rmean_limb_angular_vel, Lmean_limb_angular_vel, R_limb_ang_vel, L_limb_ang_vel] = get_limb_angular_vel(RHIP, LHIP, RKNE, LKNE, freq, RTOs, LTOs);
	Params_Patient_cyclesplit.(name).R_limb_ang_vel = R_limb_ang_vel;
    Params_Patient_cyclesplit.(name).L_limb_ang_vel = L_limb_ang_vel;																 

    %% EMG parameters
    SR_EMG = data.EMG_sr ;
    data_EMG = data;
    N_EMG = length(data_EMG.LTA);
    N_Markers = length(data.LHIP);

    RTOs_EMG = RTOs * (N_EMG/N_Markers);
    LTOs_EMG = LTOs * (N_EMG/N_Markers);


    t_EMG = [];
    for i = 1 : N_EMG
        t_EMG(i) = i* 1/SR_EMG;
    end 

    % Pre-processing of the EMG signals
    if name == "DM002_TDM_1kmh_NoEES"
        if sum(strcmp(fieldnames(data_EMG), 'Lsol')) == 1
            data_EMG.LSol = data.Lsol;
        end
    end

    data_EMG = data_EMG;
    [R_lowpass_TA, R_RMS_TA, R_env_TA] = EMG_prepross(data_EMG.RTA,10, SR_EMG, 250);
    [L_lowpass_TA, L_RMS_TA, L_env_TA] = EMG_prepross(data_EMG.LTA,10, SR_EMG, 250);
    [R_lowpass_Sol, R_RMS_Sol, R_env_Sol] = EMG_prepross(data_EMG.RSol,10, SR_EMG, 250);
    [L_lowpass_Sol, L_RMS_Sol, L_env_Sol] = EMG_prepross(data_EMG.LSol,10, SR_EMG, 250);


    % Mean RMS signal for each muscle selected
    Params_Patient.(name).Rmean_RMS_TA = rms(data_EMG.RTA);
    Params_Patient.(name).Lmean_RMS_TA = rms(data_EMG.LTA);
    Params_Patient.(name).Rmean_RMS_Sol = rms(data_EMG.RSol);
    Params_Patient.(name).Lmean_RMS_Sol = rms(data_EMG.LSol);

    % Mean RMS signal for each gait cycle and muscle selected

    [R_Mean_TA, L_Mean_TA, R_var_TA, L_var_TA] = Mean_EMG(R_env_TA, L_env_TA, RTOs_EMG, LTOs_EMG);
    [R_Mean_Sol, L_Mean_Sol, R_var_Sol, L_var_Sol] = Mean_EMG(R_env_Sol, L_env_Sol, RTOs_EMG, LTOs_EMG);

    [R_split_RMS_TA, L_split_RMS_TA] = RMS_EMG(data_EMG.RTA, data_EMG.LTA, RTOs_EMG, LTOs_EMG);
    [R_split_RMS_Sol, L_split_RMS_Sol] = RMS_EMG(data_EMG.RSol, data_EMG.LSol, RTOs_EMG, LTOs_EMG);

    Params_Patient_cyclesplit.(name).R_RMS_TA = R_split_RMS_TA;
    Params_Patient_cyclesplit.(name).L_RMS_TA = L_split_RMS_TA;
    Params_Patient_cyclesplit.(name).R_RMS_Sol = R_split_RMS_Sol;
    Params_Patient_cyclesplit.(name).L_RMS_Sol = L_split_RMS_Sol;


    % Burst Duration
     [R_burst_dur_TA, L_burst_dur_TA] = burst_duration(R_env_TA, L_env_TA, RTOs_EMG, LTOs_EMG, SR_EMG);
     [R_burst_dur_Sol, L_burst_dur_Sol] = burst_duration(R_env_Sol, L_env_Sol, RTOs_EMG, LTOs_EMG, SR_EMG);
    
     R_burst_dur_TA(isnan(R_burst_dur_TA))=0;
     L_burst_dur_TA(isnan(L_burst_dur_TA)) = 0;
     R_burst_dur_Sol(isnan(R_burst_dur_Sol)) = 0;
     L_burst_dur_Sol(isnan(L_burst_dur_Sol)) = 0;

    Params_Patient.(name).R_burst_dur_TA = mean(R_burst_dur_TA);
    Params_Patient.(name).L_burst_dur_TA = mean(L_burst_dur_TA);
    Params_Patient.(name).R_burst_dur_Sol = mean(R_burst_dur_Sol);
    Params_Patient.(name).L_burst_dur_Sol = mean(L_burst_dur_Sol);


    Params_Patient_cyclesplit.(name).R_burst_dur_TA = R_burst_dur_TA;
    Params_Patient_cyclesplit.(name).L_burst_dur_TA = L_burst_dur_TA;
    Params_Patient_cyclesplit.(name).R_burst_dur_Sol = R_burst_dur_Sol;
    Params_Patient_cyclesplit.(name).L_burst_dur_Sol = L_burst_dur_Sol;	



   % Power spectrum
   [R_lowfreq_pow_TA, L_lowfreq_pow_TA ,R_medfreq_TA, L_medfreq_TA] = spectrum(R_env_TA, L_env_TA, 100, 50, RTOs_EMG, LTOs_EMG);
   [R_lowfreq_pow_Sol, L_lowfreq_pow_Sol,R_medfreq_Sol, L_medfreq_Sol] = spectrum(R_env_Sol, L_env_Sol, 100, 50, RTOs_EMG, LTOs_EMG);



    Params_Patient_cyclesplit.(name).R_medfreq_TA = R_medfreq_TA;
    Params_Patient_cyclesplit.(name).L_medfreq_TA = L_medfreq_TA;
    Params_Patient_cyclesplit.(name).R_medfreq_Sol = R_medfreq_Sol;
    Params_Patient_cyclesplit.(name).L_medfreq_Sol = L_medfreq_Sol;	



end


%% Save the results for patient
save('Patient_data.mat','Params_Patient_cyclesplit')