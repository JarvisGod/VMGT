function [permanent,permanent_loc,permanent_dipo] = start_simulateV1_0(point,flag)
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
[permanent_loc, permanent_dipo] = init_setV1_0(flag);
% source_col = size(permanent_loc,2);%�ж��ٸ���ż����
%% �㶨������
permanent = [];
for i = 1:point_col   %�ж��ٸ�������
   permanent_tmp = generate_permanent_at_sensorV1_0( permanent_dipo,permanent_loc,point(:,i));
   permanent = [permanent,permanent_tmp];
end
end
