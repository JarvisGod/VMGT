function [Mx, My, Mz] = cal_dipo_sensorV1_0(Dipo_matrix, Fly_matrix, sensor_matrix)

%计算机体坐标系上k个布点磁偶极子在磁力仪位置处产生的磁场在机体坐标系三分量上的大小
%输入变量：Dipo_matrix,布点的磁偶极矩矩阵；Fly_matrix，布点到探头的距离矩阵；
%输出变量：Mx, My, Mz， k个布点在磁力仪坐标处产生磁场强度的分量和，延三个轴向
BT = 4*pi*1.032*0.1*0.005^2*0.012/4*10^9;
% BT  = 1;
%Induce_dipo_matrix 3*N
%Fly_matrix 3*N
% sensor_matrix 3*N
% Dipo_matrix 2*N
%Mx, scalar
%My, scalar
%Mz, scalar
%sensor_matrix 表示传感器的位置坐标。3*1
%uf，vf，wf 三个方向上的布点到三轴的距离；
uf = sensor_matrix(1,1:end)-Fly_matrix(1,1:end);   %xl-aq.1行m列，m为磁源个数
vf = sensor_matrix(2,1:end)-Fly_matrix(2,1:end);   %yl-bq
wf = sensor_matrix(3,1:end)-Fly_matrix(3,1:end);   %zl-cq
%p_x, p_y, p_z 三个方向上的磁偶极矩；
a = Dipo_matrix(1,1:end)./180.*pi;
b = Dipo_matrix(2,1:end)./180.*pi;
MT = Dipo_matrix(3,1:end);

mq = MT.*cos(a).*cos(b);
nq = MT.*cos(a).*sin(b);
pq = MT.*sin(a);

R = sqrt(uf.^2 + vf.^2 + wf.^2);
Br = 3*(mq.*uf+nq.*vf+pq.*wf);

Bx = BT*((Br.*uf)./R.^5-mq./R.^3);
By = BT*((Br.*vf)./R.^5-nq./R.^3);
Bz = BT*((Br.*wf)./R.^5-pq./R.^3);


Mx = sum(Bx,2);
My = sum(By,2);
Mz = sum(Bz,2);
end