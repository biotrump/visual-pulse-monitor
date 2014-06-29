t = 0:300;
dailyFluct = gallery('normaldata',size(t),2);
sdata = cumsum(dailyFluct) + 20 + t/100;
mean(sdata)

figure
plot(t,sdata);
legend('Original Data','Location','northwest');
xlabel('Time (days)');
ylabel('Stock Price (dollars)');

detrend_sdata=detrend(sdata);
trend = sdata - detrend_sdata;

mean(detrend_sdata)

hold on
plot(t,trend,':r')
plot(t,detrend_sdata,'m')

legend('Original Data','Trend','Detrended Data',...
       'Mean of Detrended Data','Location','northwest')
xlabel('Time (days)');
ylabel('Stock Price (dollars)');

X = detrend_sdata;
%function [white_X] = whiten(X)
  % whiten the matrix X as ICA preprocessing step:
  % by sphering the data the optimization can be restricted to
  % independent rotations
  %
  % Note: assumes X is formed s.t. each row is a component and the columns
  % are observations

  % whiten by singular value decomposition of covariance
  % (scale by inverse square root)
  [U, S, V] = svd(cov(X'));
  M_whiten = V*S^(-0.5)*U';
  white_X = M_whiten*X;
%end
plot(t,white_X,'g')
plot(t,zeros(size(t)),':k')

