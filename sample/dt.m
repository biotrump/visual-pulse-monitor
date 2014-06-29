##asdfjasdflj
#
t = 0:300;

dailyFluct = gallery('normaldata',size(t),2);
sdata = cumsum(dailyFluct) + 20 + t/100;
mean(sdata);
figure;
plot(t,sdata);
legend('Original Data','Location','northwest');
xlabel('Time (days)');
ylabel('Stock Price (dollars)');
detrend_sdata=detrend(sdata);
trend = sdata - detrend_sdata;
mean(detrend_sdata);
hold on;
plot(t,trend,':r');
plot(t,detrend_sdata,'m');
plot(t,zeros(size(t)),':k');
legend('Original Data','Trend','Detrended Data',...
       'Mean of Detrended Data','Location','northwest');
xlabel('Time (days)');
ylabel('Stock Price (dollars)');
