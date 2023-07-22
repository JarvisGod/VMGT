function last_single_1 = add_noise(Ori_single,rate)
%ADD_NOISE 此处显示有关此函数的摘要
%   此处显示详细说明
%Ori_single 表示原始信号， rate 表示添加的噪声的百分比

% snr = 20*log10(1/rate);
% last_single_1 = awgn(Ori_single,snr);
% rate = 100*(1-rate);
% rate = (1-rate);
% snr_rate = (1-rate)/rate;
last_single_1 = awgn(Ori_single,rate,'measured');
% last_single_1 = awgn(Ori_single,rate);
% sss = rate.*randn(size(Ori_single))
end