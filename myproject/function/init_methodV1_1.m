function [poplocal_x,poplocal_y,poplocal_z,pop_I,pop_D,pop_M] ...
    = init_methodV1_1(popsize,poplength,x_boundary,y_boundary,z_boundary,I_boundary,D_boundary,M_boundary,group_source_num,xy_all)

%INIT_METHOD 此处显示有关此函数的摘要
%   此处显示详细说明
for i  = 1:popsize
    pop_num = 1;
    xy_all_num = 1;
    for gn = 1:size(group_source_num,2)
       poplocal_x(i,pop_num) = xy_all(1,xy_all_num);
       poplocal_y(i,pop_num) = xy_all(2,xy_all_num);
       poplocal_z(i,pop_num) = (z_boundary(2,xy_all_num)-z_boundary(1,xy_all_num))*rand(1)+z_boundary(1,xy_all_num);
       pop_I(i,pop_num) = (I_boundary(2)-I_boundary(1))*rand(1)+I_boundary(1);
       pop_D(i,pop_num) = (D_boundary(2)-D_boundary(1))*rand(1)+D_boundary(1);
       pop_M(i,pop_num) = (M_boundary(2)-M_boundary(1))*rand(1)+M_boundary(1);
       pop_num = pop_num+1;
       xy_all_num = xy_all_num+1;
       if group_source_num(gn)>1
          for j = 1:group_source_num(gn)-1
               poplocal_x(i,pop_num) = (x_boundary(2,xy_all_num)-x_boundary(1,xy_all_num))*rand(1)+x_boundary(1,xy_all_num);
               poplocal_y(i,pop_num) = (y_boundary(2,xy_all_num)-y_boundary(1,xy_all_num))*rand(1)+y_boundary(1,xy_all_num);
               poplocal_z(i,pop_num) = (z_boundary(2,xy_all_num)-z_boundary(1,xy_all_num))*rand(1)+z_boundary(1,xy_all_num);
               pop_I(i,pop_num) = (I_boundary(2)-I_boundary(1))*rand(1)+I_boundary(1);
               pop_D(i,pop_num) = (D_boundary(2)-D_boundary(1))*rand(1)+D_boundary(1);
               pop_M(i,pop_num) = (M_boundary(2)-M_boundary(1))*rand(1)+M_boundary(1);
               pop_num = pop_num+1;
          end
           
       end
       
    end
end
end

