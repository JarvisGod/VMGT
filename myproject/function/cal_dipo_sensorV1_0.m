function [Mx, My, Mz] = cal_dipo_sensorV1_0(Dipo_matrix, Fly_matrix, sensor_matrix)

%�����������ϵ��k�������ż�����ڴ�����λ�ô������Ĵų��ڻ�������ϵ�������ϵĴ�С
%���������Dipo_matrix,����Ĵ�ż���ؾ���Fly_matrix�����㵽̽ͷ�ľ������
%���������Mx, My, Mz�� k�������ڴ��������괦�����ų�ǿ�ȵķ����ͣ�����������
BT = 4*pi*1.032*0.1*0.005^2*0.012/4*10^9;
% BT  = 1;
%Induce_dipo_matrix 3*N
%Fly_matrix 3*N
% sensor_matrix 3*N
% Dipo_matrix 2*N
%Mx, scalar
%My, scalar
%Mz, scalar
%sensor_matrix ��ʾ��������λ�����ꡣ3*1
%uf��vf��wf ���������ϵĲ��㵽����ľ��룻
uf = sensor_matrix(1,1:end)-Fly_matrix(1,1:end);   %xl-aq.1��m�У�mΪ��Դ����
vf = sensor_matrix(2,1:end)-Fly_matrix(2,1:end);   %yl-bq
wf = sensor_matrix(3,1:end)-Fly_matrix(3,1:end);   %zl-cq
%p_x, p_y, p_z ���������ϵĴ�ż���أ�
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