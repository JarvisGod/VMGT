function [lamd_1,lamd_2,lamd_3] = calculate_NSS(Bxx,Bxy,Bxz,Byy,Byz)
%CALCULATE_NSS 此处显示有关此函数的摘要
%   此处显示详细说明
Bzz = -(Bxx+Byy);
I1 = Byy.*Bzz + Bxx.*Byy + Bzz.*Bxx - Bxy.^2 - Bxz.^2 - Byz.^2;
I2 = Bxx.*Byy.*Bzz - Bxx.*(Byz.^2) - Bzz.*(Bxy.^2) - Byy.*(Bxz.^2) + 2.*Bxy.*Bxz.*Byz;
popsize = size(Bxx,2);
lamd_1 = [];
lamd_2 = [];
lamd_3 = [];
for i=1:popsize
    p =[1 0 I1(i) I2(i)];
    x = roots(p);
    index = 1:3;
    [lamd_1_tmp,index_1] = max(x);
    [lamd_3_tmp,index_3] = min(x);
    x_maxmin = [lamd_1_tmp;lamd_3_tmp];
    isx = ismember(x,x_maxmin);
    lamd_2_tmp = x(~isx);
%     index(index_1) = [];
%     index(index_3) = [];
%     index_2 = index;
%     lamd_2_tmp = x(index_2,:);
    lamd_1 = [lamd_1,lamd_1_tmp];
    lamd_2 = [lamd_2,lamd_2_tmp];
    lamd_3 = [lamd_3,lamd_3_tmp];
end


end

