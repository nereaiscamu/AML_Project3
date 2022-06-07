%%  ------------- Functions for Gait Cycle Events Dedection ----------------------

function [RTOs, LTOs, RICs, LICs] = gait_cycle_events(RANK, LANK, RKNE, LKNE, RHIP, LHIP)

    %Find minimums in z-cooridnates of KNEE-ANKLE (= max of ANKLE-KNEE)

    [Lpks,Llocs] = findpeaks(LANK(:,3)-LKNE(:,3));
    Lmean = mean(abs(Lpks))*0.75;
    [Lpks,Llocs] = findpeaks(LANK(:,3)-LKNE(:,3), 'MinPeakProminence',Lmean, 'MinPeakDistance', 30);
    
    [Rpks,Rlocs] = findpeaks(RANK(:,3)-RKNE(:,3));
    Rmean = mean(abs(Rpks))*0.75;
    [Rpks,Rlocs] = findpeaks(RANK(:,3)-RKNE(:,3), 'MinPeakProminence',Rmean, 'MinPeakDistance', 30);
 

    %Make a list of all found peaks, in correct order of time 
    %Peak of left side must be at least 0.3s away from last right peak
    %Peak of right side must be at least 0.3s away from last left peak 

    idx_l = 1;
    idx_r = 1;
    locs = [];
    peaks = [];
    sites = [];
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

    while idx_l <= length(Llocs) && idx_r <= length(Rlocs)
      if Rlocs(idx_r) <= Llocs(idx_l)
          if Rlocs(idx_r) > locs(end)+ 20
              locs = [locs Rlocs(idx_r)];
              sites = [sites 0];
              peaks = [peaks Rpks(idx_r)];
          end
          idx_r = idx_r + 1;
      else
          if Llocs(idx_l) > locs(end) +20
              locs = [locs Llocs(idx_l)];
              sites = [sites 1];
              peaks = [peaks Lpks(idx_l)];
          end
          idx_l = idx_l + 1;
      end
    end
    
    %Dedected peak locations define the Toe off (TO)
    %If more than one peak of one side is between two peaks of the other side, then: 
    % 1. if the difference between the peaks is bigger than 25mm, then the location of the max. peak is selected as TO. 
    % 2. if not, then the mean value of the locations is selected as TO.

    LTOs = [];
    RTOs = [];
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
                RTOs = [RTOs tmp_loc(1)];
            else
                LTOs = [LTOs tmp_loc(1)];
            end
        else 
            if abs(diff(tmp_peak)) < 25
                val = round(mean(tmp_loc));
            else
                [M,I] = max(tmp_peak);
                val = tmp_loc(I);
            end
            if site == 0
                RTOs = [RTOs val];
            else
                LTOs = [LTOs val];
            end
        end
    end

    %Detection of initial contact (IC): First min. of hip z-coordinate after TO
    [RICs, LICs] = inital_contacts(RTOs, LTOs, RHIP, LHIP); 
end

function [RICs, LICs] = inital_contacts(RTOs, LTOs, RHIP, LHIP)
    RICs = [];
    LICs = [];
    len = min(length(RTOs), length(LTOs));
    if RTOs(1)<LTOs(1)
        for i = 1:len-1
            Rhip = RHIP(RTOs(i)+10:LTOs(i)-10, 3);
            Lhip = LHIP(LTOs(i)+10:RTOs(i+1)-10, 3);

            Rmin = min(Rhip);
            Lmin = min(Lhip);
            Rthresh = find(Rhip < Rmin + abs(Rmin*0.1));
            Lthresh = find(Lhip < Lmin + abs(Lmin*0.1));
            RICs =  [RICs RTOs(i)+10+round(0.5*(Rthresh(1) + Rthresh(end)))];
            LICs =  [LICs LTOs(i)+10+round(0.5*(Lthresh(1) + Lthresh(end)))];
        end
    else
        for i = 1:len-1
            Lhip = RHIP(LTOs(i)+10:RTOs(i)-10, 3);
            Rhip = LHIP(RTOs(i)+10:LTOs(i+1)-10, 3);
            
            Rmin = min(Rhip);
            Lmin = min(Lhip);
            Rthresh = find(Rhip < Rmin + abs(Rmin*0.1));
            Lthresh = find(Lhip < Lmin + abs(Lmin*0.1));
            RICs =  [RICs RTOs(i)+10+ round(0.5*(Rthresh(1) + Rthresh(end)))];
            LICs =  [LICs LTOs(i)+10+ round(0.5*(Lthresh(1) + Lthresh(end)))];
        end
    end
end