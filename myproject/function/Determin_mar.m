function [save_data,save_data_num,save_maxtilt_index] = Determin_mar(gardient_tilt,max_tilt_index,aa1,bb1,per_loc_ori)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ȷ�����쳣������㷨
% gardient_tilt���洢���е�����ֵ��81*81
% max_tilt_index: �洢���й��ƵĴ�Դ������
%save_maxtilt_index:ÿ���쳣�����а����Ĵ�Դ��Ӧ��max_tilt_index�е�����

%% ��ȡ���е��xy����:
gardient_tilt_index = [];
for i = 1:size(gardient_tilt,1)
    for j = 1:size(gardient_tilt,2)
        gardient_tilt_tmpindex = [i;j];
        gardient_tilt_index= [gardient_tilt_index,gardient_tilt_tmpindex];
    end
end
%gardient_tilt_index�洢���е������  2*����
%% Ϊall_data����ֵ,Ϊֻ����һ��Ԫ�飬��Ԫ��������еĲ������ˮƽ����
all_data = {gardient_tilt_index};
save_data= {};
save_data_new = {};
save_data_num = [];
save_maxtilt_index={};
stop_m = 99;% ������ֵ�޸Ĵ���
save_data_index = 1;
%% ��ʼѭ����ֱ��all_data�в�����Ԫ��
while size(all_data,2) ~= 0
    new_all_data = {};
    new_all_data_index = 1;
    %% ����all_data�е�ÿһ��Ԫ�飬�����Ű��������Դ��һ�����쳣������Ҫ�����ٷֽ�
    % ȷ��ÿ�����쳣��������Ĺ��ƴ�Դ��������
    index_all_tilt = {};%�洢ÿһ���ж�Ӧ�ļ���ֵż���ӵ�����
    for i = 1:size(all_data,2)
        ismember_max_tilt = ismember(max_tilt_index',all_data{i}','rows');
        index_tilt = [];%�洢��i���ж�Ӧ�ļ���ֵż���ӵ�����
        for j = 1:size(ismember_max_tilt,1)
            if ismember_max_tilt(j,:) == 1
                index_tilt = [index_tilt,j];
            end
        end
        index_all_tilt(i) = {index_tilt};
    end
    %index_all_tilt:�ж��ٴ��쳣���򣬾��ж���Ԫ�飬ÿ��Ԫ���ʾ�ô��쳣�����а��� ���ƴ�Դ��Ӧmax_tilt_index�е�����
    for cell_i = 1:size(all_data,2)
        %% ������ֵ�����ڶԴ��쳣������зֽ⣺
        %ͨ����ȡ��Ԫ���а����������ѹ��ƵĴ�Դ�ж�Ӧ����С���ֵ�͸�Ԫ���ƽ��ֵ��������ֵ��
        min_gardient_tilt = [];%����������⼸����Դ����Сtiltֵ
        index_all_tilt_tmp = index_all_tilt{1,cell_i};%��Ӧmax_tilt_index�д�Դ������
        for m_index = 1:size(index_all_tilt_tmp,2)
            min_gardient_tilt_tmp = gardient_tilt(max_tilt_index(1,index_all_tilt_tmp(m_index)),max_tilt_index(2,index_all_tilt_tmp(m_index)));
            min_gardient_tilt = [min_gardient_tilt,min_gardient_tilt_tmp]; % min_gardient_tilt ������Ӧ��Դ�����ֵ
        end
        min_tilt_tmp = min(min_gardient_tilt);%��ȡ��С���ֵ
        mean_tilt = mean(gardient_tilt(all_data{cell_i}(1,:),all_data{cell_i}(2,:)),'all');%���all_data�е�cell_i�����쳣�������Ǿ�ֵ
        min_tilt_all = min(gardient_tilt(all_data{cell_i}(1,:),all_data{cell_i}(2,:)),[],'all')
        inter_tilt = (min_tilt_tmp-min_tilt_all)/(stop_m+1);
        rate_tilt = 1; %������ֵ��ȡֵ
        run_flag = 1;
        while run_flag
            yuzhi_value = min_tilt_all+inter_tilt*rate_tilt;%������ֵ
            [new_all_tilt_group,~] = calculate_localmax6(gardient_tilt,all_data{cell_i},yuzhi_value);
            
            if size(new_all_tilt_group,2) == 1 %δ����ɹ�
                if rate_tilt == stop_m %˵���ô��쳣���򲻿��ٷ֣���ʹ���������Դ������ô��쳣����save_data��
                    
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
            else  %��������������飬�����������ж�ÿ�������ڰ����Ĵ�Դ�ĸ���
                %���ж��Ƿ�����ٷ��룬Ҳ���Ƿ��������һ����������Դ�Ĵ��쳣�������������ֱ��rate_tilt+1,all_data��ceil������
                flag_False = 0;
                for every_i = 1:size(new_all_tilt_group,2)
                   ismember_max_tilt = ismember([max_tilt_index(1,index_all_tilt{1,cell_i});max_tilt_index(2,index_all_tilt{1,cell_i})]',new_all_tilt_group{every_i}','rows');
                    index_tilt = [];%�洢��i���ж�Ӧ�ļ���ֵż���ӵ�����
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
                    for every_i = 1:size(new_all_tilt_group,2)%�ж�ÿһ������Ĵ�Դ���������ֻ��һ�����򱣴浽save_data������ж��,�򱣴浽new_all_data;
                        %                     new_all_tilt_group_tmp = new_all_tilt_group{1,every_i};
                        ismember_max_tilt = ismember([max_tilt_index(1,index_all_tilt{1,cell_i});max_tilt_index(2,index_all_tilt{1,cell_i})]',new_all_tilt_group{every_i}','rows');
                        index_tilt = [];%�洢��i���ж�Ӧ�ļ���ֵż���ӵ�����
                        for j = 1:size(ismember_max_tilt,1)
                            if ismember_max_tilt(j,:) == 1
                                index_tilt = [index_tilt,j];
                            end
                        end
                        if size(index_tilt,2) == 1%˵����Ӧ��every_i�Ĵ��쳣����ֻ����һ����Դ���򱣴�ô��쳣����save_data��
                            save_data(save_data_index) = {new_all_tilt_group{every_i}};
                            save_maxtilt_index(save_data_index)= {index_all_tilt{1,cell_i}(index_tilt)};
                            save_data_num(save_data_index) = 1;
                            save_data_index = save_data_index+1;
                            yuzhi_value
                        elseif size(index_tilt,2) > 1 %˵����Ӧ��every_i�Ĵ��쳣������������Դ���򱣴�ô��쳣����new_all_data��,�����ٽ��зֽ�
                            new_all_data(new_all_data_index) = {new_all_tilt_group{every_i}};
                            new_all_data_index = new_all_data_index+1;
                        else %���������ʾ�������ڲ�������Դ����������ǰ���Ѿ����߽��ų����ˣ���������ĳ�������ڵ�һ���֡���������£�����������
                            
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
                     run_flag = 0;%ֹͣ����ѭ��
                end
               
            end
        end
    end
    all_data = new_all_data;
end


end

