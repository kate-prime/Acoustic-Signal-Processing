
function signal=getavecho(mics,reps,num)
%a function to create an average ensonification from multiple repitions
%mics=mic channels to load
%reps=number of repitions
%num=time between excitations in ms
%% load
disp('Load sound file')
[fname,fpath]=uigetfile;
load(fname,'fs','sig')
num=num*(fs/1000);
%% plot and assemble full
if length(mics)>1
    for i=1:length(mics)
        raw(:,i)=sig(:,mics(i));
        spectrogram(raw(:,i),2^8,(2^8)-1,2^8,fs,'yaxis');
        pause;
    end
    ask=input('average the mics? 1=y, 2=n');
    if ask==1
        raw=mean(raw,2);
    elseif ask==2
        ask2=input('Which one to use?');
        raw=raw(:,ask2);
    end
else
    raw=sig(:,mics);
end
close all
%% select a start time
figure;
plot(raw);
title('enter when done zooming, select a start time and end time, then enter again')
pause;
times=ginput;
times=round(times);
len=times(2,1)-times(1,1);
close all

ind=zeros(1,reps);

ind(1)=times(1,1);

for j=2:reps
    ind(j)=ind(j-1)+num+1;
end

for k=1:reps
    stacked(k,:)=raw(ind(k):ind(k)+len);
end
%% check alignment

figure;
title('looks right?')
hold on
for i=1:reps
    plot(stacked(i,:))
end
pause;
close all

%% means
signal=mean(stacked,1);
spectrogram(signal,2^8,(2^8)-1,2^8,fs,'MinThreshold',-65,'power','yaxis');
colormap('jet')
save([fname(1:end-4),'_avg'],'signal','fs');
