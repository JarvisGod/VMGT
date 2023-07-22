function objvalue = calculate_fitnessV1_0(poplocal_x,poplocal_y,poplocal_z,a,b,MT,point,permanent_ori)
%CALCULATE_FITNESS 此处显示有关此函数的摘要
%   此处显示详细说明

% 生成每个磁源在每个传感器位置的磁场大小；坐标需要进行变换，但磁矩不需要
measurePoint_size = size(point,2);%有多少个传感器
%生成对应所有磁源在每一个传感器的磁场值 种群个数×传感器个数
    for j = 1:measurePoint_size
         sum_permanet(:,j) = generate_permanent_at_sensorV1_0([a(1,:);b(1,:);MT(1,:)]...
            ,[poplocal_x(1,:);poplocal_y(1,:);poplocal_z(1,:)],point(:,j));%%%存储了每个磁源在传感器上产生的磁场值
    end
    % 先将测量磁场和实际磁场进行合成，利用总场进行适应度值的计算;更符合均方误差的定义
    per_sub = sum_permanet-permanent_ori;%每个传感器上三分量的差值
    objvalue  = sum(sum(per_sub.^2,2),1);
end
