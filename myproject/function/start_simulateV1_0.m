function [permanent,permanent_loc,permanent_dipo] = start_simulateV1_0(point,flag)
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
[permanent_loc, permanent_dipo] = init_setV1_0(flag);
% source_col = size(permanent_loc,2);%有多少个磁偶极子
%% 恒定场仿真
permanent = [];
for i = 1:point_col   %有多少个传感器
   permanent_tmp = generate_permanent_at_sensorV1_0( permanent_dipo,permanent_loc,point(:,i));
   permanent = [permanent,permanent_tmp];
end
end
