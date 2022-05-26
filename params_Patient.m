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
dataset_list = ['DM002_TDM_08_1kmh.mat'; 'DM002_TDM_08_2kmh.mat'];

%%  ------------- (1) ASSIGNEMENT 1: Varibales Healthy Gait ----------------------

for idx = 1:2
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
    
    %Divid the signal into Cycles using the toe marker position
    Rtoe = data.RTOE(:,3)- mean(data.RTOE(:,3));
    Ltoe = data.LTOE(:,3) - mean(data.LTOE(:,3));
    Rank = data.RANK(:,3)- mean(data.RANK(:,3));
    Lank = data.LANK(:,3)- mean(data.LANK(:,3));
    Rhip = data.RHIP(:,3)- mean(data.RHIP(:,3));
    Lhip = data.LHIP(:,3)- mean(data.LHIP(:,3));
    
    [Lpks,Llocs] = findpeaks(Ltoe);
    Lmean = mean(abs(Lpks))*0.75;
    [Lpks,Llocs] = findpeaks(Ltoe, 'MinPeakProminence',Lmean, 'MinPeakDistance', 20);
    
    [Rpks,Rlocs] = findpeaks(Rtoe);
    Rmean = mean(abs(Rpks))*0.75;
    [Rpks,Rlocs] = findpeaks(Rtoe, 'MinPeakProminence',Rmean, 'MinPeakDistance', 20);

    %Identify in each cycle the initial contact (IC) and the toe off (TO)
    [Rdivision, Ldivision] = gait_cycles(Rpks, Lpks, Rlocs, Llocs);
    [RICs, RTOs] = gait_events(Rdivision, Rtoe, Rank, Rhip);
    [LICs, LTOs] = gait_events(Ldivision, Ltoe, Lank, Lhip);

    %Fill the result structur
    name = erase(dataset_list(idx,:), ".mat");
    Params_Patient.(name).Rdiv = Rdivision;
    Params_Patient.(name).Ldiv = Ldivision;
    Params_Patient.(name).RICs= RICs;
    Params_Patient.(name).LICs = LICs;
    Params_Patient.(name).RTOs= RTOs;
    Params_Patient.(name).LTOs = LTOs;

end

%%  ------------- Save the results ----------------------

save('params_Patient.mat','Params_Patient')

%%  ------------- Functions ----------------------
function [Rdivision, Ldivision] = gait_cycles(Rpks, Lpks, Rlocs, Llocs)
    idx_l = 1;
    idx_r = 1;
    locs = [];
    peaks = [];
    sites = [];
    
    while idx_l <= length(Llocs) && idx_r <= length(Rlocs)
      if Rlocs(idx_r) <= Llocs(idx_l)
          locs = [locs Rlocs(idx_r)];
          sites = [sites 0];
          peaks = [peaks Rpks(idx_r)];
          idx_r = idx_r + 1;
      else
          locs = [locs Llocs(idx_l)];
          sites = [sites 1];
          peaks = [peaks Lpks(idx_l)];
          idx_l = idx_l + 1;
      end
    end
    
    Ldivision = [];
    Rdivision = [];
    i = 1;
    
    
    while i < length(locs)
        site = sites(i);
        tmp_loc = [];
        tmp_peak = [];
        while sites(i) == site && i < length(locs)
            tmp_peak = [tmp_peak peaks(i)];
            tmp_loc = [tmp_loc locs(i)];
            i = i+1;
        end
        if length(tmp_loc) == 1
            if site == 0
                Rdivision = [Rdivision tmp_loc(1)];
                
            else
                Ldivision = [Ldivision tmp_loc(1)];
            end
        elseif length(Ldivision) == 0 | length(Rdivision) == 0
            [M,I] = max(tmp_peak);
            if site == 0
                Rdivision = [Rdivision tmp_loc(I)];
            else
                Ldivision = [Ldivision tmp_loc(I)];
            end
    
        else
            if site == 0
                tmp_time = abs(tmp_loc - (Ldivision(end) + (locs(i) - Ldivision(end))/2));
                [M,I] = min(tmp_time);
                Rdivision = [Rdivision tmp_loc(I)];
            else
                tmp_time = abs(tmp_loc - (Rdivision(end) + (locs(i) - Rdivision(end))/2));
                [M,I] = min(tmp_time);
                Ldivision = [Ldivision tmp_loc(I)];
            end
        end
    end
end

function [ICs, TOs] = gait_events(Events, TOE, ANK, HIP)
    ICs = [];
    TOs = [];
    for i = 1:length(Events)-1
        toe = TOE(Events(i):Events(i+1));
        ank = ANK(Events(i):Events(i+1));
        hip = HIP(Events(i):Events(i+1));
    
        [M, idx1] = min(toe);
        [M, idx2] = max(diff(ank));
        TOs = [TOs int16(Events(i) + mean(idx1,idx2))];

        [pks,locs] = findpeaks(-hip);
        ICs = [ICs int16(Events(i) + locs(1))];
    end

end