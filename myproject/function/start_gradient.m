function [Bxx,Bxy,Bxz,Byy,Byz] = start_gradient(point,permanent_loc,permanent_dipo)
%% ����˵����
% ��2.0��ȣ��޸��˳�ʼ���Ĳ�����ΪMT��a��b���Լ�����ų��Ĺ�ʽ
%���룺
% pointΪ�����㣬
%���:
% permanentΪ����õ��ĺ㶨����ÿһ�б�ʾһ���������Ĳ���ֵ��
%���㣺����ż���ӷֱ���ÿ��������������ų�����ֵ����ÿ�������������۲���ֵ
%% ���ó�ʼֵ�����ڵشų����棩
point_col = size(point,2);%�ж��ٸ�������
%% ��ʼ���㶨����ż����λ�ü�����
%% �㶨������
permanent = [];
for i = 1:point_col   %�ж��ٸ�������
   permanent_tmp = generate_gradient_at_sensorV1_0( permanent_dipo,permanent_loc,point(:,i));
   permanent = [permanent,permanent_tmp];
end
Bxx=permanent(1,:);
Bxy=permanent(2,:);
Bxz=permanent(3,:);
Byy=permanent(4,:);
Byz=permanent(5,:);
end
