fid=fopen('../data/cam/raw-25fps.txt');%640x480x15fps
rdata=fscanf(fid,'%e %e %e',[3 inf]);  %[m n] = [3 inf] 3 channels (R,G,B), 3 row vectors and the column can be infinite
fclose(fid);
test_data=rdata();
detrend(this_block);
fid=fopen('detrend.txt');