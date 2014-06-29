
fid=fopen('g:\cv\database\ipcam\ip60\20140614_072056-r180-320x256.raw');
%rdata=fscanf(fid,'%e %e %e %e',[4 inf]);  %[m n] = [4 inf] 4 channels (R,G,B,0.0)
rdata=fscanf(fid,'%e %e %e',[3 inf]);  %[m n] = [3 inf] 3 channels (R,G,B)
sdata=rdata'; %[m n] = [inf, 3], each column vector is R,G,B channel
fclose(fid);

mean(sdata);

[m n]=size(sdata);
t = 1:m;

%R,G,B channels
figure;
plot(t,sdata);
legend('Original Data','Location','northeast');
xlabel('Sampling (frames)');
ylabel('RGB(Intensity)');
detrend_sdata=detrend(sdata);
trend = sdata - detrend_sdata;
mean(detrend_sdata);

%channel 1
figure;
plot(t,sdata(:,1), 'b');
%channel 2
figure;
plot(t,sdata(:,2), 'g');
%channel 3
figure;
plot(t,sdata(:,3), 'r');

%channel 1
figure;
plot(t,detrend_sdata(:,1), 'b');
%channel 2
figure;
plot(t,detrend_sdata(:,2), 'g');
%channel 3
figure;
plot(t,detrend_sdata(:,3), 'r');


figure;
hold on;
plot(t,trend,':r')
plot(t,detrend_sdata,':m')
plot(t,zeros(size(t)),':k')
legend('Original Data','Trend','Detrended Data',...
       'Mean of Detrended Data','Location','northeast');
xlabel('Sampling (frames)');
ylabel('RGB(Intensity)');


%visual-pulse-monitor
frames= load_frames('g:\cv\database\ipcam\ip60\20140614_072056-r180-320x256.avi');
%fps=11


 pulse_from_traces(frames,11);