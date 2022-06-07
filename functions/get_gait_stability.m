function [Mean_gait_stability] = get_gait_stability(RHIP, LHIP, RTOs, LTOs)
    centre_of_mass = (RHIP(:,1) + LHIP(:,1))/2000;
    gait_stability = [];
    for i = 1:length(RTOs)-1
        values = centre_of_mass(RTOs(i):RTOs(i+1));
        gait_stability = [gait_stability; trapz(values-mean(values))];
    end
    Mean_gait_stability = mean(gait_stability);
end