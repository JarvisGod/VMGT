function permanent = generate_gradient_at_sensorV1_0(popdipo, poplocation,sensor_matrix)

%计算len个磁偶极子在探头处延三个方向产生的恒定场总和
%输入变量：permanent_dipo，磁偶极矩矩阵；Fly_matrix，磁偶极子到探头的位置向量；len，采样点数，不是布点数
%输出变量：每个磁偶极子在探头处产生的恒定场三分量

[Bxx,Bxy,Bxz,Byy,Byz] = calculate_G(poplocation,popdipo,sensor_matrix); 
%Bxx:1*n,n为偶极子个数

    Bxx = sum(Bxx,2);
    Bxy = sum(Bxy,2);
    Bxz = sum(Bxz,2);
    Byy = sum(Byy,2);
    Byz = sum(Byz,2);
    permanent = [Bxx;Bxy;Bxz;Byy;Byz];
end