close all
clear,clc
modulator = comm.PSKModulator('ModulationOrder',8);
%%
% 产生随机信号
data = randi([0 7],100,1);
%%
% Use the |modulator| System object to modulate the random data.
modData = modulator(data);
%%
%成型滤波
rolloff = 0.25;%滚降系数
span = 8; %滤波器跨度
sps = 40;%每个符号的采样个数
b = rcosdesign(rolloff, span, sps); %升余弦滤波器
x_psk = upfirdn(modData, b, sps); %成型滤波
%%
% Create a Rayleigh channel System object to define a static frequency
% selective channel with four taps. Pass the modulated data through the
% channel object.
chan = comm.RayleighChannel('SampleRate',1000, ...
    'PathDelays',[0 0.02 0.04],'AveragePathGains',[0 -3 -6]);
rx = chan(x_psk);
%%
%匹配滤波
rs=upfirdn(rx, b,1,sps);
rxSig=rs(span+1:length(rs)-span);

%%
% Create a DFE equalizer that has 10 feed forward taps and five feedback
% taps. The equalizer uses the LMS update method with a step size of 0.01.
numFFTaps = 10;
numFBTaps = 5;
equalizerDFE = dfe(numFFTaps,numFBTaps,lms(0.01));

%%
% Set the |SigConst| property of the DFE equalizer to match the 8-PSK
% modulator reference constellation. The reference constellation is
% determined by using the |constellation| method. For decision directed
% operation, the DFE must use the same signal constellation as the
% transmission scheme.
equalizerDFE.SigConst = constellation(modulator).';
%%
% Equalize the signal to remove the effects of channel distortion. Use the
% first 600 symbols to train the equalizer.
trainlen = 25;
[eqSig,detectedSig] = equalize(equalizerDFE,rxSig, ...
    modData(1:trainlen));

%%
% Plot the received signal, equalizer output after training, and the ideal
% signal constellation.
hScatter = scatterplot(rxSig,1,trainlen,'bx');
hold on
scatterplot(eqSig,1,trainlen,'g.',hScatter);
scatterplot(equalizerDFE.SigConst,1,0,'m*',hScatter);
legend('Received signal','Equalized signal',...
    'Ideal signal constellation');
hold off
%%
% Create a PSK demodulator System object. Use the object to demodulate the
% received signal before and after equalization.
demod = comm.PSKDemodulator('ModulationOrder',8);
demodSig = demod(rxSig);
demodEqualizedSig = demod(detectedSig);

%%
% Compute the error rates for the two demodulated signals and compare the
% results.
errorCalc = comm.ErrorRate;
nonEqualizedSER = errorCalc(data(trainlen+1:end), ...
    demodSig(trainlen+1:end));
reset(errorCalc)
equalizedSER = errorCalc(data(trainlen+1:end), ...
    demodEqualizedSig(trainlen+1:end));
disp('Symbol error rates with and without equalizer:')
disp([equalizedSER(1) nonEqualizedSER(1)])
save('matlab.mat')