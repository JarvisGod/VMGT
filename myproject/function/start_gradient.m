function [Bxx,Bxy,Bxz,Byy,Byz] = start_gradient(point,permanent_loc,permanent_dipo)
%% 函数说明：
% 与2.0相比，修改了初始化的参数，为MT和a、b。以及计算磁场的公式
%输入：
% point为测量点，
%输出:
% permanent为仿真得到的恒定场，每一列表示一个传感器的测量值，
%计算：所有偶极子分别在每个测量点出产生磁场的总值，即每个传感器的理论测量值
%% 设置初始值（用于地磁场仿真）
point_col = size(point,2);%有多少个传感器
%% 初始化恒定场磁偶极子位置及极距
%% 恒定场仿真
permanent = [];
for i = 1:point_col   %有多少个传感器
   permanent_tmp = generate_gradient_at_sensorV1_0( permanent_dipo,permanent_loc,point(:,i));
   permanent = [permanent,permanent_tmp];
end
Bxx=permanent(1,:);
Bxy=permanent(2,:);
Bxz=permanent(3,:);
Byy=permanent(4,:);
Byz=permanent(5,:);
end
