%%%the raw data is from the preprocess of openCV
%%%fid=fopen('g:\cv\database\ipcam\ip60\20140614_072056-r180-320x256.raw');
%%%fid=fopen('d:\ipcam\ip60\20140614_072056-r180-320x256.raw');
%fid=fopen('d:\ipcam\cannonS3IS\MVI_1066.raw');%640x480x30fps
%fid=fopen('/media/data/ipcam/usb_cam/C0-2.raw');%640x480x15fps
%fid=fopen('d:\ipcam\usb_cam\C0-0713-1.raw');%640x480x15fps

% octave in ubuntu
%fid=fopen('../data/cam/raw-trace-25fps.txt');%640x480x15fps
fid=fopen('../data/cam/raw-25fps.txt');%640x480x15fps
%fid=fopen('../data/cam/raw.txt');%640x480x15fps

%rdata=fscanf(fid,'%e %e %e %e',[4 inf]);  %[m n] = [4 inf] 4 channels (R,G,B,0.0)
rdata=fscanf(fid,'%e %e %e',[3 inf]);  %[m n] = [3 inf] 3 channels (R,G,B), 3 row vectors and the column can be infinite
%sdata=rdata'; %[m n] = [inf, 3], 3 columns, each column vector is R,G,B channel
sdata=rdata;    %[m n] = [3, inf], 3 rows, each row vector is R,G,B channel
fclose(fid);
%%% the 3rd parameter win_size should be power of 2: 2,4,8,...
%%%[pulse ic_spectra trace_spectra] = pulse_from_traces(sdata, 11, 4, 3);
%FPS=15, win_size : 4S, overlapped 3S, so the increment is 4-3=1S
[pulse ic_spectra trace_spectra] = pulse_from_traces(sdata, 25, 4, 3);
%RR
%[pulse ic_spectra trace_spectra] = pulse_from_traces(sdata,25, 16, 15);
