function last_single_1 = add_noise(Ori_single,rate)
%ADD_NOISE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%Ori_single ��ʾԭʼ�źţ� rate ��ʾ��ӵ������İٷֱ�

% snr = 20*log10(1/rate);
% last_single_1 = awgn(Ori_single,snr);
% rate = 100*(1-rate);
% rate = (1-rate);
% snr_rate = (1-rate)/rate;
last_single_1 = awgn(Ori_single,rate,'measured');
% last_single_1 = awgn(Ori_single,rate);
% sss = rate.*randn(size(Ori_single))
end