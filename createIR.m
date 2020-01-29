function [ir]=createIR(response,pulse,fs)
%semi-automate the building of an Impulse Response for an object, for best
%results, use a sine-sweep pulse. When selecting a response, first round 
%select a wide window, but check for wall echoes/noise
%second pass, select wide as possible for resolution, but eliminate first chirp
%must be longer than the length of your input

%This is largely a work in progress that involves a really inelegent IR of
%an IR method to isolate echoes from the IR of the speaker
%seems noisy, but functional

%pulse=signal played
%response=recorded echo
%fs=sampling rate

%Created by KA 2020
%% Select response window (round 1)
figure;
spectrogram(response,2^8,(2^8)-1,2^8,fs,'yaxis','power','MinThreshold',-90);
title('zoom to fit, press enter when done');
pause;
title('select start and end of signal, press enter when done')
times=ginput;
times=round(times*(fs/1000));
echo=response(1,times(1,1):times(2,1));
spectrogram(echo,2^8,(2^8)-1,2^8,fs,'yaxis','power','MinThreshold',-90);
pause;

%% first IR
nFFT=2^(ceil(log2(length(echo)))); 
imp=zeros(nFFT, 1);
resp=zeros(nFFT, 1);

imp(1:length(pulse))=pulse; %zero pad the pulse and echo
resp(1:length(echo))=echo;

ir1=ifft(fft(resp)./fft(imp)); %get the inverse fft
ir1 = ir1(1:nFFT/2); %truncate to the relevent part of the signal

%% select response round 2
t = 0:1/fs:.001;
y=chirp(t,22000,.0005,75000);%create a very short chirp to give good separation

temp=conv(y,ir1);

spectrogram(temp,2^8,(2^8)-1,2^8,fs,'yaxis','power','MinThreshold',-90);
title('zoom to fit, press enter when done');
pause;
title('select start and end of signal, press enter when done')
time2=ginput;
time2=round(time2*(fs/1000));
temp = temp(time2(1,1):time2(2,1));

imp2=zeros(nFFT, 1);
resp2=zeros(nFFT, 1);
imp2(1:length(y))=y; 
resp2(1:length(temp))=temp;

ir=ifft(fft(resp2)./fft(imp2));
ir = ir(1:nFFT/4);
close all
