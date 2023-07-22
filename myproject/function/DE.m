function  [best_value_all,best_fit_all,t,e2] =  DE(x_all,y_all,D_boundary, z_boundary, I_boundary, poplength, y_boundary, stopsize, x_boundary, M_boundary, Bxy, Bxx, Bxz, point, Byz, Byy)
p = poplength*6;%变量空间大小
n = 10;
popsize = n*p;%种群大小
Fmax = 0.9;%0-2,变异概率
Fmin = 0.4;
CR0 = 0.8;%0-1，交叉概率
fai_max = 1;
fai_min = 0.1;
best_value_all = {};
dim_group = 1:p;
%初始化参数  %如果磁异常区域内只包含单个磁源，则直接赋值其xy，若包含多个磁源，则赋值其中一个xy，另外的在范围内随机初始化
[poplocal_x,poplocal_y,poplocal_z,pop_I,pop_D,pop_M] = init_methodV3_1(popsize,poplength,x_boundary,y_boundary,z_boundary,I_boundary,D_boundary,M_boundary);
pop_fitness = calculate_fitness_GV1_0(poplocal_x,poplocal_y,poplocal_z,pop_I,pop_D,pop_M,point,[Bxx;Bxy;Bxz;Byy;Byz]);
[best_fit,best_index] = min(pop_fitness);
best_poplocal_x = poplocal_x(best_index,:);
best_poplocal_y = poplocal_y(best_index,:);
best_poplocal_z = poplocal_z(best_index,:);
best_pop_I = pop_I(best_index,:);
best_pop_D = pop_D(best_index,:);
best_pop_M = pop_M(best_index,:);
for t =1:stopsize
    t1 = clock;
    t
    %     if mod(t,1000)==0
    %         t
    %     end
    %为变异变量赋初值
    V_poplocal_x = zeros(size(poplocal_x));
    V_poplocal_y = zeros(size(poplocal_y));
    V_poplocal_z = zeros(size(poplocal_z));
    V_pop_I = zeros(size(pop_I));
    V_pop_D = zeros(size(pop_D));
    V_pop_M = zeros(size(pop_M));
    U_poplocal_x = zeros(size(poplocal_x));
    U_poplocal_y = zeros(size(poplocal_y));
    U_poplocal_z = zeros(size(poplocal_z));
    U_pop_I = zeros(size(pop_I));
    U_pop_D = zeros(size(pop_D));
    U_pop_M = zeros(size(pop_M));
    
    F = Fmin+(Fmax-Fmin)*(stopsize-t)/stopsize;
    CR = CR0*(1-sqrt(stopsize^2-t^2)/stopsize);
    fai = fai_min + (fai_max-fai_min)*(stopsize-t)/stopsize;
    
    %用来选择变异策略的,每次迭代选择一次
    if rand <= fai
        mutation_strategy = 1;
    else
        mutation_strategy = 2;
    end
    %     Mutation;
    if mutation_strategy == 1 %第一种变异策略
        for i = 1:popsize
            index_group = 1:popsize;
            index_group(i) = [];
            random_num = index_group(randperm(size(index_group,2),3));%生成三个互不重复的索引
            V_poplocal_x(i,:) = poplocal_x(random_num(1),:) + F.*(poplocal_x(random_num(2),:)-poplocal_x(random_num(3),:));
            V_poplocal_y(i,:) = poplocal_y(random_num(1),:) + F.*(poplocal_y(random_num(2),:)-poplocal_y(random_num(3),:));
            V_poplocal_z(i,:) = poplocal_z(random_num(1),:) + F.*(poplocal_z(random_num(2),:)-poplocal_z(random_num(3),:));
            V_pop_I(i,:) = pop_I(random_num(1),:) + F.*(pop_I(random_num(2),:)-pop_I(random_num(3),:));
            V_pop_D(i,:) = pop_D(random_num(1),:) + F.*(pop_D(random_num(2),:)-pop_D(random_num(3),:));
            V_pop_M(i,:) = pop_M(random_num(1),:) + F.*(pop_M(random_num(2),:)-pop_M(random_num(3),:));
            
            V_poplocal_x(i,:) = boundary_pop(V_poplocal_x(i,:),x_boundary);
            V_poplocal_y(i,:) = boundary_pop(V_poplocal_y(i,:),y_boundary);
            V_poplocal_z(i,:) = boundary_pop(V_poplocal_z(i,:),z_boundary);
            V_pop_I(i,:) = boundary_pop(V_pop_I(i,:),I_boundary);
            V_pop_D(i,:) = boundary_pop(V_pop_D(i,:),D_boundary);
            V_pop_M(i,:) = boundary_pop(V_pop_M(i,:),M_boundary);
        end
    else
        %第二种变异策略
        for i = 1:popsize
            index_group = 1:popsize;
            index_group(i) = [];
            random_num = index_group(randperm(size(index_group,2),2));%生成两个互不重复的索引
            V_poplocal_x(i,:) = poplocal_x(i,:)+F.*(best_poplocal_x-poplocal_x(i,:))+F.*(poplocal_x(random_num(1),:)-poplocal_x(random_num(2),:));
            V_poplocal_y(i,:) = poplocal_y(i,:)+F.*(best_poplocal_y-poplocal_y(i,:))+F.*(poplocal_y(random_num(1),:)-poplocal_y(random_num(2),:));
            V_poplocal_z(i,:) = poplocal_z(i,:)+F.*(best_poplocal_z-poplocal_z(i,:))+F.*(poplocal_z(random_num(1),:)-poplocal_z(random_num(2),:));
            V_pop_I(i,:) = pop_I(i,:)+F.*(best_pop_I-pop_I(i,:))+F.*(pop_I(random_num(1),:)-pop_I(random_num(2),:));
            V_pop_D(i,:) = pop_D(i,:)+F.*(best_pop_D-pop_D(i,:))+F.*(pop_D(random_num(1),:)-pop_D(random_num(2),:));
            V_pop_M(i,:) = pop_M(i,:)+F.*(best_pop_M-pop_M(i,:))+F.*(pop_M(random_num(1),:)-pop_M(random_num(2),:));
            
            V_poplocal_x(i,:) = boundary_pop(V_poplocal_x(i,:),x_boundary);
            V_poplocal_y(i,:) = boundary_pop(V_poplocal_y(i,:),y_boundary);
            V_poplocal_z(i,:) = boundary_pop(V_poplocal_z(i,:),z_boundary);
            V_pop_I(i,:) = boundary_pop(V_pop_I(i,:),I_boundary);
            V_pop_D(i,:) = boundary_pop(V_pop_D(i,:),D_boundary);
            V_pop_M(i,:) = boundary_pop(V_pop_M(i,:),M_boundary);
        end
    end
    %     Crossover;%%%%%%%%%%%%%%%%%%%%%%%%%需要进一步修改
    for i = 1:popsize
        sn = dim_group(randperm(size(dim_group,2),1));
        sn_i = ceil(sn/6);%j
        sn_m = mod(sn,6);%
        for j = 1:size(poplocal_x,2)
            if rand <= CR
                U_poplocal_x(i,j) = V_poplocal_x(i,j);
            else
                U_poplocal_x(i,j) = poplocal_x(i,j);
            end
        end
        for j = 1:size(poplocal_y,2)
            if rand <= CR
                U_poplocal_y(i,j) = V_poplocal_y(i,j);
            else
                U_poplocal_y(i,j) = poplocal_y(i,j);
            end
        end
        for j = 1:size(poplocal_z,2)
            if rand <= CR
                U_poplocal_z(i,j) = V_poplocal_z(i,j);
            else
                U_poplocal_z(i,j) = poplocal_z(i,j);
            end
        end
        for j = 1:size(pop_I,2)
            if rand <= CR
                U_pop_I(i,j) = V_pop_I(i,j);
            else
                U_pop_I(i,j) = pop_I(i,j);
            end
        end
        for j = 1:size(pop_D,2)
            if rand <= CR
                U_pop_D(i,j) = V_pop_D(i,j);
            else
                U_pop_D(i,j) = pop_D(i,j);
            end
        end
        for j = 1:size(pop_M,2)
            if rand <= CR
                U_pop_M(i,j) = V_pop_M(i,j);
            else
                U_pop_M(i,j) = pop_M(i,j);
            end
        end
        switch sn_m
            case 0
                U_pop_M(i,sn_i) = V_pop_M(i,sn_i);
            case 1
                U_poplocal_x(i,sn_i) = V_poplocal_x(i,sn_i);
            case 2
                U_poplocal_y(i,sn_i) = V_poplocal_y(i,sn_i);
            case 3
                U_poplocal_z(i,sn_i) = V_poplocal_z(i,sn_i);
            case 4
                U_pop_I(i,sn_i) = V_pop_I(i,sn_i);
            case 5
                U_pop_D(i,sn_i) = V_pop_D(i,sn_i);
        end
    end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %     Selection;
    for i  = 1:popsize
        pop_fitness_X = calculate_fitness_GV1_0(poplocal_x(i,:),poplocal_y(i,:),poplocal_z(i,:),pop_I(i,:),pop_D(i,:),pop_M(i,:),point,[Bxx;Bxy;Bxz;Byy;Byz]);
        pop_fitness_U = calculate_fitness_GV1_0(U_poplocal_x(i,:),U_poplocal_y(i,:),U_poplocal_z(i,:),U_pop_I(i,:),U_pop_D(i,:),U_pop_M(i,:),point,[Bxx;Bxy;Bxz;Byy;Byz]);
        if pop_fitness_U < pop_fitness_X
            poplocal_x(i,:) = U_poplocal_x(i,:);
            poplocal_y(i,:) = U_poplocal_y(i,:);
            poplocal_z(i,:) = U_poplocal_z(i,:);
            pop_I(i,:) = U_pop_I(i,:);
            pop_D(i,:) = U_pop_D(i,:);
            pop_M(i,:) = U_pop_M(i,:);
        end
    end
    %求最优值，并更新
    new_pop_fitness = calculate_fitness_GV1_0(poplocal_x,poplocal_y,poplocal_z,pop_I,pop_D,pop_M,point,[Bxx;Bxy;Bxz;Byy;Byz]);
    [new_best_fit,new_best_index] = min(new_pop_fitness);
    if new_best_fit < best_fit
        best_poplocal_x = poplocal_x(new_best_index,:);
        best_poplocal_y = poplocal_y(new_best_index,:);
        best_poplocal_z = poplocal_z(new_best_index,:);
        best_pop_I = pop_I(new_best_index,:);
        best_pop_D = pop_D(new_best_index,:);
        best_pop_M = pop_M(new_best_index,:);
        best_fit = new_best_fit;
    end
    best_value = [best_poplocal_x;best_poplocal_y;best_poplocal_z;best_pop_I;best_pop_D;best_pop_M];
    best_value_all(t) = {best_value};
    best_fit_all(t) = best_fit;
    t2=clock;
    e2(t) = etime(t2,t1);
    if best_fit <0.1
        break;
    end
end
end