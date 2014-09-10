function [pows, freq] = analyse_power_spectrum(X, Fs)
  % X is a row vector which is from one of the R, G, B channel data.
  % calculate the FFT of the signal X, transform to power, and
  % generate frequency range according to the sampling rate Fs , sample rate, fps in the video

  N = length(X);

  % take FFT and shift it for symmetry
  % If you need to shift frequency components to be visually clearer (not necessary always), use fftshift after fft. 
  % FFT => F(X) = Sum(a*cos(nx)+j*b*sin(nx)), each term is exp(2 * pi *j *w * t) = cos(2*pi*w*t) + j sin(2*pi*w*t)
  % fft(X) will get 2 symmetric parts : positive side and negative side, only one side is enough!
  amp = fftshift(fft(X));

  % make frequency range over the N sampled data
  fN = N - mod(N, 2);
  k = -fN/2 : fN/2 - 1; % 1-d arrary whose content is from (-fN/2) to (fN/2 - 1)
  T = N / Fs; % the seconds to process, Fs is the FPS , sampling rate per second, N is the total sample data
  freq = k/T;

  % select the positive domain FFT and range
  one_idx = fN/2 + 2;
  amp = amp(one_idx:end); % here to retreive the positive side
  freq = freq(one_idx:end); % start from one to positive idx

  % return power spectrum
  % ".^2" is the element-wise power of 2, each element is powered of 2
  pows = abs(amp).^2; %abs of the complex (a+bi) is to sqrt(a^2+b^2).
end
