function [Bxx,Bxy,Bxz,Byy,Byz] = calculate_G(poplocation,popdipo,sensor_matrix)
%CALCULATE_G 此处显示有关此函数的摘要
%   计算磁场梯度张量
%   输入：
%       偶极子坐标矩阵（x,y,z)->poplocation(3,n),n表示偶极子个数；
%       偶极子磁矩矩阵（Mx,My,Mz)->popdipo(3,n)
%   输出：互不相关的五个梯度张量Bxx,Bxy,Bxz,Byy,Byz

pop_x = sensor_matrix(1,:) - poplocation(1,:);
pop_y = sensor_matrix(2,:) - poplocation(2,:);
pop_z = sensor_matrix(3,:) - poplocation(3,:);

M_x = popdipo(3,:).*cos(popdipo(1,:)./180.*pi).*cos(popdipo(2,:)./180.*pi);
M_y = popdipo(3,:).*cos(popdipo(1,:)./180.*pi).*sin(popdipo(2,:)./180.*pi);
M_z = popdipo(3,:).*sin(popdipo(1,:)./180.*pi);


pop_r = sqrt(pop_x.^2+pop_y.^2+pop_z.^2);
BT = 4*pi*1.032*0.1*0.005^2*0.012/4*10^9;  %nT

Bxx = BT./pop_r.^7.*((9.*pop_x.*pop_r.^2-15.*pop_x.^3).* M_x + (3.*pop_y.*pop_r.^2-15.*pop_x.^2.*pop_y).*M_y + ...
    (3.*pop_z.*pop_r.^2-15.*pop_x.^2.*pop_z).*M_z);
Bxy = BT./pop_r.^7.*((3.*pop_y.*pop_r.^2-15.*pop_x.^2.*pop_y).*M_x + (3.*pop_x.*pop_r.^2-15.*pop_x.*pop_y.^2).*M_y +...
    (-15.*pop_x.*pop_y.*pop_z).*M_z);
Bxz = BT./pop_r.^7.*((3.*pop_z.*pop_r.^2-15.*pop_x.^2.*pop_z).*M_x + (-15.*pop_x.*pop_y.*pop_z).*M_y +...
    (3.*pop_x.*pop_r.^2-15.*pop_x.*pop_z.^2).*M_z);
Byy = BT./pop_r.^7.*((3.*pop_x.*pop_r.^2-15.*pop_x.*pop_y.^2).*M_x + (9.*pop_y.*pop_r.^2-15.*pop_y.^3).*M_y +...
    (3.*pop_z.*pop_r.^2-15.*pop_y.^2.*pop_z).*M_z);
Byz = BT./pop_r.^7.*((-15.*pop_x.*pop_y.*pop_z).*M_x + (3.*pop_z.*pop_r.^2-15.*pop_y.^2.*pop_z).*M_y +...
    (3.*pop_y.*pop_r.^2-15.*pop_y.*pop_z.^2).*M_z);
end

% poplocation = [0;0;0];
% popdipo  = [pi/4;pi/4;3096];
% sensor_matrix = [0.1;0.1;0.1];
% pop_x = poplocation(1,:);
% pop_y = poplocation(2,:);
% pop_z = poplocation(3,:);