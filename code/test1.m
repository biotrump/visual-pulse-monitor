
fid=fopen('g:\cv\database\ipcam\ip60\20140614_072056-r180-320x256.raw');
%rdata=fscanf(fid,'%e %e %e %e',[4 inf]);  %[m n] = [4 inf] 4 channels (R,G,B,0.0)
rdata=fscanf(fid,'%e %e %e',[3 inf]);  %[m n] = [3 inf] 3 channels (R,G,B)
%sdata=rdata'; %[m n] = [inf, 3], each column vector is R,G,B channel
sdata=rdata;
fclose(fid);

[pulse ic_spectra trace_spectra] = pulse_from_traces(sdata, 11, 4, 1);
