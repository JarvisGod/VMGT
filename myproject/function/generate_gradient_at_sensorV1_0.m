function permanent = generate_gradient_at_sensorV1_0(popdipo, poplocation,sensor_matrix)

%����len����ż������̽ͷ����������������ĺ㶨���ܺ�
%���������permanent_dipo����ż���ؾ���Fly_matrix����ż���ӵ�̽ͷ��λ��������len���������������ǲ�����
%���������ÿ����ż������̽ͷ�������ĺ㶨��������

[Bxx,Bxy,Bxz,Byy,Byz] = calculate_G(poplocation,popdipo,sensor_matrix); 
%Bxx:1*n,nΪż���Ӹ���

    Bxx = sum(Bxx,2);
    Bxy = sum(Bxy,2);
    Bxz = sum(Bxz,2);
    Byy = sum(Byy,2);
    Byz = sum(Byz,2);
    permanent = [Bxx;Bxy;Bxz;Byy;Byz];
end