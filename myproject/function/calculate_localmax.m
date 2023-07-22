function [all_tilt3_group,max_tilt3_index] = calculate_localmax(gardient_tilt3)
%CALCULATE_LOCALMAX 此处显示有关此函数的摘要
%   此处显示详细说明
gardient_tilt3_index = [];
for i = 1:size(gardient_tilt3,1)
    for j = 1:size(gardient_tilt3,2)
        if gardient_tilt3(i,j)>0
            gardient_tilt3_tmpindex = [i;j];
            gardient_tilt3_index= [gardient_tilt3_index,gardient_tilt3_tmpindex];
        end
    end
end
% for i = 1:size(gardient_tilt3,1)
%     for j = 1:size(gardient_tilt3,2)
%         if gardient_tilt3(i,j)<0
%             gardient_tilt3(i,j)=0;
%         end
%     end
% end

gardient_tilt3_index_size = size(gardient_tilt3_index,2);
all_tilt3_group = {};
t=1;
while size(gardient_tilt3_index,2)>0
    X1 = gardient_tilt3_index(:,1);
    for i = 2:size(gardient_tilt3_index,2)
        gar_tmpindex = [gardient_tilt3_index(1,i);gardient_tilt3_index(2,i)];
        dif = gar_tmpindex - X1;
        diff_1 = dif==[1;0];
        diff_2 = dif==[0;1];
        diff_3 = dif==[-1;0];
        diff_4 = dif==[0;-1];
        diff_1 = max(diff_1(1,:).*diff_1(2,:));
        diff_2 = max(diff_2(1,:).*diff_2(2,:));
        diff_3 = max(diff_3(1,:).*diff_3(2,:));
        diff_4 = max(diff_4(1,:).*diff_4(2,:));
        if (diff_1||diff_2||diff_3||diff_4)
            X1 = [X1,gar_tmpindex];
        end
    end
    if  size(gardient_tilt3_index,2)>2
        for i = size(gardient_tilt3_index,2):-1:2
            gar_tmpindex = [gardient_tilt3_index(1,i);gardient_tilt3_index(2,i)];
            dif = gar_tmpindex - X1;
            diff_1 = dif==[1;0];
            diff_2 = dif==[0;1];
            diff_3 = dif==[-1;0];
            diff_4 = dif==[0;-1];
            diff_1 = max(diff_1(1,:).*diff_1(2,:));
            diff_2 = max(diff_2(1,:).*diff_2(2,:));
            diff_3 = max(diff_3(1,:).*diff_3(2,:));
            diff_4 = max(diff_4(1,:).*diff_4(2,:));
            if (diff_1||diff_2||diff_3||diff_4)
                X1 = [X1,gar_tmpindex];
            end
        end
    end
    is_nonsep = ismember(gardient_tilt3_index',X1','rows');
%     is_nonsep = is_nonsep(1,:).*is_nonsep(2,:);
    gardient_tilt3_index = gardient_tilt3_index(:,~is_nonsep);
    all_tilt3_group(t) = {X1};
    t = t+1;
end
%计算每一组元胞中的极大值点的坐标
max_tilt3_index = [];
for i = 1:size(all_tilt3_group,2)
    group_tmp = all_tilt3_group{1,i};
    gardient_tilt3_tmp =[];
    for j = 1:size(group_tmp,2)
        gardient_tilt3_tmp = [gardient_tilt3_tmp,gardient_tilt3(group_tmp(1,j),group_tmp(2,j))];
    end
    [max_value,max_index] = max(gardient_tilt3_tmp);
    max_tilt3_index_tmp = [group_tmp(1,max_index);group_tmp(2,max_index)];
    max_tilt3_index = [max_tilt3_index,max_tilt3_index_tmp];
end
end

