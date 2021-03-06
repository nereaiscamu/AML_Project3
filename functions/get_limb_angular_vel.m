function [Rmean_limb_angular_vel, Lmean_limb_angular_vel, R_limb_ang_vel, L_limb_ang_vel] = get_limb_angular_vel(RHIP, LHIP, RKNE, LKNE, freq, RTOs, LTOs)
    Rlimb_angular_vel = rad2deg(atan((RHIP(:,3)-RKNE(:,3))./(RHIP(:,1)-RKNE(:,1))));
    Llimb_angular_vel = rad2deg(atan((LHIP(:,3)-LKNE(:,3))./(LHIP(:,1)-LKNE(:,1))));
    for i = 1:length(Rlimb_angular_vel)
        if Rlimb_angular_vel(i)<0
            Rlimb_angular_vel(i) = Rlimb_angular_vel(i)+180;
        end
        if Llimb_angular_vel(i)<0
            Llimb_angular_vel(i) = Llimb_angular_vel(i)+180;
        end
    end
    R_limb_angular_vel  = diff(Rlimb_angular_vel)*freq;
    L_limb_angular_vel = diff(Llimb_angular_vel)*freq;
    Rmean_limb_angular_vel = mean(R_limb_angular_vel);
    Lmean_limb_angular_vel = mean(R_limb_angular_vel);
    R_limb_ang_vel = [];
    L_limb_ang_vel = [];
    for i = 1:length(RTOs)-1
        R_limb_angular_vel_i = R_limb_angular_vel(RTOs(i):RTOs(i+1));
        R_limb_ang_vel = [R_limb_ang_vel; mean(R_limb_angular_vel_i)];
    end
    for i = 1:length(LTOs)-1
        L_limb_angular_vel_i = L_limb_angular_vel(LTOs(i):LTOs(i+1));
        L_limb_ang_vel = [L_limb_ang_vel; mean(L_limb_angular_vel_i)];
    end
end