function [Rmax_angle, Lmax_angle, R_max_angles, L_max_angles] = get_joint_angle(RTOs, LTOs, RMarkersDistal, LMarkersDistal, RMarkersCenter, LMarkersCenter, RMarkersProximal, LMarkersProximal)
    Rmax_angles = [];
    Lmax_angles = [];
    Rprox_part = RMarkersCenter(:,1)-RMarkersProximal(:,1);
    Rdis_part = RMarkersCenter(:,1)-RMarkersDistal(:,1);
    Lprox_part = LMarkersCenter(:,1)-LMarkersProximal(:,1);
    Ldis_part = LMarkersCenter(:,1)-LMarkersDistal(:,1);
    for i = 1:length(RTOs)-1
        angleright = tan(Rprox_part(RTOs(i):RTOs(i+1))./Rdis_part(RTOs(i):RTOs(i+1)))*2*pi/360;
        Rmax_angles = [Rmax_angles max(angleright)];
    end
    for i = 1:length(LTOs)-1
        angleleft = tan(Lprox_part(LTOs(i):LTOs(i+1))./Ldis_part(LTOs(i):LTOs(i+1)))*2*pi/360;
        Lmax_angles = [Rmax_angles max(angleleft)];
    end
    R_max_angles = 180 - Rmax_angles;
    L_max_angles = 180 - Lmax_angles;
    Rmax_angle = mean(R_max_angles);
    Lmax_angle = mean(L_max_angles);
end