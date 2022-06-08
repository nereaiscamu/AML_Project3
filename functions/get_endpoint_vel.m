function[Rmean_endpoint_vel, Lmean_endpoint_vel, Rendpoint_vel, Lendpoint_vel] = get_endpoint_vel(RTOs, LTOs, RANK, LANK, freq)
    Rendpoint_vel = [];
    Lendpoint_vel = [];
    for i = 1:length(RTOs)-1
        vel = diff(RANK(RTOs(i):RTOs(i+1)), 2)/1000*freq;
        Rendpoint_vel = [Rendpoint_vel; max(vel)];
    end
    for i = 1:length(LTOs)-1
        vel = diff(LANK(LTOs(i):LTOs(i+1)), 2)/1000*freq;
        Lendpoint_vel = [Lendpoint_vel; max(vel)];
    end
    Rmean_endpoint_vel = mean(Rendpoint_vel);
    Lmean_endpoint_vel = mean(Lendpoint_vel);
end