function objvalue = calculate_fitnessV1_0(poplocal_x,poplocal_y,poplocal_z,a,b,MT,point,permanent_ori)
%CALCULATE_FITNESS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% ����ÿ����Դ��ÿ��������λ�õĴų���С��������Ҫ���б任�����žز���Ҫ
measurePoint_size = size(point,2);%�ж��ٸ�������
%���ɶ�Ӧ���д�Դ��ÿһ���������Ĵų�ֵ ��Ⱥ����������������
    for j = 1:measurePoint_size
         sum_permanet(:,j) = generate_permanent_at_sensorV1_0([a(1,:);b(1,:);MT(1,:)]...
            ,[poplocal_x(1,:);poplocal_y(1,:);poplocal_z(1,:)],point(:,j));%%%�洢��ÿ����Դ�ڴ������ϲ����Ĵų�ֵ
    end
    % �Ƚ������ų���ʵ�ʴų����кϳɣ������ܳ�������Ӧ��ֵ�ļ���;�����Ͼ������Ķ���
    per_sub = sum_permanet-permanent_ori;%ÿ�����������������Ĳ�ֵ
    objvalue  = sum(sum(per_sub.^2,2),1);
end
