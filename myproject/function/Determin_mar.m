function [save_data,save_data_num,save_maxtilt_index] = Determin_mar(gardient_tilt,max_tilt_index,aa1,bb1,per_loc_ori)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
% 确定磁异常区域的算法
% gardient_tilt：存储所有点的倾角值，81*81
% max_tilt_index: 存储所有估计的磁源的索引
%save_maxtilt_index:每个异常区域中包含的磁源对应在max_tilt_index中的索引

%% 获取所有点的xy索引:
gardient_tilt_index = [];
for i = 1:size(gardient_tilt,1)
    for j = 1:size(gardient_tilt,2)
        gardient_tilt_tmpindex = [i;j];
        gardient_tilt_index= [gardient_tilt_index,gardient_tilt_tmpindex];
    end
end
%gardient_tilt_index存储所有点的索引  2*点数
%% 为all_data赋初值,为只包含一个元组，该元组包含所有的测量点的水平索引
all_data = {gardient_tilt_index};
save_data= {};
save_data_new = {};
save_data_num = [];
save_maxtilt_index={};
stop_m = 99;% 设置阈值修改次数
save_data_index = 1;
%% 开始循环，直到all_data中不包含元组
while size(all_data,2) ~= 0
    new_all_data = {};
    new_all_data_index = 1;
    %% 对于all_data中的每一个元组，代表着包含多个磁源的一个磁异常区域，需要对其再分解
    % 确定每个磁异常区域包含的估计磁源的索引：
    index_all_tilt = {};%存储每一组中对应的极大值偶极子的索引
    for i = 1:size(all_data,2)
        ismember_max_tilt = ismember(max_tilt_index',all_data{i}','rows');
        index_tilt = [];%存储第i组中对应的极大值偶极子的索引
        for j = 1:size(ismember_max_tilt,1)
            if ismember_max_tilt(j,:) == 1
                index_tilt = [index_tilt,j];
            end
        end
        index_all_tilt(i) = {index_tilt};
    end
    %index_all_tilt:有多少磁异常区域，就有多少元组，每个元组表示该磁异常区域中包含 估计磁源对应max_tilt_index中的索引
    for cell_i = 1:size(all_data,2)
        %% 设置阈值，用于对磁异常区域进行分解：
        %通过获取该元组中包含的所有已估计的磁源中对应的最小倾角值和该元组的平均值来计算阈值。
        min_gardient_tilt = [];%计算包含的这几个磁源的最小tilt值
        index_all_tilt_tmp = index_all_tilt{1,cell_i};%对应max_tilt_index中磁源的索引
        for m_index = 1:size(index_all_tilt_tmp,2)
            min_gardient_tilt_tmp = gardient_tilt(max_tilt_index(1,index_all_tilt_tmp(m_index)),max_tilt_index(2,index_all_tilt_tmp(m_index)));
            min_gardient_tilt = [min_gardient_tilt,min_gardient_tilt_tmp]; % min_gardient_tilt 包含对应磁源的倾角值
        end
        min_tilt_tmp = min(min_gardient_tilt);%获取最小倾角值
        mean_tilt = mean(gardient_tilt(all_data{cell_i}(1,:),all_data{cell_i}(2,:)),'all');%求得all_data中第cell_i个磁异常区域的倾角均值
        min_tilt_all = min(gardient_tilt(all_data{cell_i}(1,:),all_data{cell_i}(2,:)),[],'all')
        inter_tilt = (min_tilt_tmp-min_tilt_all)/(stop_m+1);
        rate_tilt = 1; %决定阈值的取值
        run_flag = 1;
        while run_flag
            yuzhi_value = min_tilt_all+inter_tilt*rate_tilt;%设置阈值
            [new_all_tilt_group,~] = calculate_localmax6(gardient_tilt,all_data{cell_i},yuzhi_value);
            
            if size(new_all_tilt_group,2) == 1 %未分离成功
                if rate_tilt == stop_m %说明该磁异常区域不可再分，即使包含多个磁源，保存该磁异常区域到save_data中
                    
                    save_data(save_data_index) = {new_all_tilt_group{1,1}};
%                     mean_tilt
%                     yuzhi_value
                    save_maxtilt_index(save_data_index)= {index_all_tilt_tmp};
                    save_data_num(save_data_index) = 2;
                    save_data_index = save_data_index+1;
                    break;
                end
                rate_tilt = rate_tilt+1
%                 format long;
%                 yuzhi_value
                all_data(cell_i) = new_all_tilt_group;
            else  %分离出来至少两组，接下来就是判断每个分组内包含的磁源的个数
                %先判断是否是虚假分离，也就是分离出来了一个不包含磁源的磁异常区域，这种情况下直接rate_tilt+1,all_data（ceil）不变
                flag_False = 0;
                for every_i = 1:size(new_all_tilt_group,2)
                   ismember_max_tilt = ismember([max_tilt_index(1,index_all_tilt{1,cell_i});max_tilt_index(2,index_all_tilt{1,cell_i})]',new_all_tilt_group{every_i}','rows');
                    index_tilt = [];%存储第i组中对应的极大值偶极子的索引
                    for j = 1:size(ismember_max_tilt,1)
                        if ismember_max_tilt(j,:) == 1
                            index_tilt = [index_tilt,j];
                        end
                    end
                    if size(index_tilt,2)==0
                        flag_False = 1;
                    end
                end
                if flag_False == 1
                    rate_tilt = rate_tilt+1;
                else
                    for every_i = 1:size(new_all_tilt_group,2)%判断每一组包含的磁源个数，如果只有一个，则保存到save_data。如果有多个,则保存到new_all_data;
                        %                     new_all_tilt_group_tmp = new_all_tilt_group{1,every_i};
                        ismember_max_tilt = ismember([max_tilt_index(1,index_all_tilt{1,cell_i});max_tilt_index(2,index_all_tilt{1,cell_i})]',new_all_tilt_group{every_i}','rows');
                        index_tilt = [];%存储第i组中对应的极大值偶极子的索引
                        for j = 1:size(ismember_max_tilt,1)
                            if ismember_max_tilt(j,:) == 1
                                index_tilt = [index_tilt,j];
                            end
                        end
                        if size(index_tilt,2) == 1%说明对应的every_i的磁异常区域只包含一个磁源，则保存该磁异常区域到save_data中
                            save_data(save_data_index) = {new_all_tilt_group{every_i}};
                            save_maxtilt_index(save_data_index)= {index_all_tilt{1,cell_i}(index_tilt)};
                            save_data_num(save_data_index) = 1;
                            save_data_index = save_data_index+1;
                            yuzhi_value
                        elseif size(index_tilt,2) > 1 %说明对应的every_i的磁异常区域包含多个磁源，则保存该磁异常区域到new_all_data中,后续再进行分解
                            new_all_data(new_all_data_index) = {new_all_tilt_group{every_i}};
                            new_all_data_index = new_all_data_index+1;
                        else %这种情况表示该区域内不包含磁源，但是由于前面已经将边界排除掉了，所以算是某个区域内的一部分。这种情况下，保留该区域到
                            
                        end
                        figure;
                        h = pcolor(aa1,bb1,gardient_tilt);
                        shading interp;colorbar;colormap(jet);hold on;
                        for i = 1:size(new_all_tilt_group{every_i},2)
                            plot(aa1(new_all_tilt_group{every_i}(1,i),new_all_tilt_group{every_i}(2,i)),bb1(new_all_tilt_group{every_i}(1,i),new_all_tilt_group{every_i}(2,i)),'k*');hold on;
                        end
                        hold on;
                        plot(per_loc_ori(1,:),per_loc_ori(2,:),'MarkerEdgeColor',[1 1 1], 'Marker','*','MarkerFaceColor',[1 1 1],'MarkerSize',8,'LineStyle','none');
                        hd = datacursormode;
                        hd.UpdateFcn = @(obj,event_obj) NewCallback(obj,event_obj,h);
                    end
                     run_flag = 0;%停止本次循环
                end
               
            end
        end
    end
    all_data = new_all_data;
end


end

