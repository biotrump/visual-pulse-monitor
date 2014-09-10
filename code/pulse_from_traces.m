function [pulse ic_spectra trace_spectra] = pulse_from_traces(traces, Fs, win_size, overlap)
  % measure pulse from hand-picked frames
  % by signal normalization, independent components analysis,
  % fourier transform, and picking the maximum power frequency
  % within the operation healthy human pulse range [.75, 4] Hz or 45-240 bpm
  %%% win_size should be 2's power, 2,4,8,...
  %%%size(traces)=> [m n] = [3, inf], 3 rows, each row vector is R,G,B channel

  % operational range for human pulse (45-240 bpm)
  % TODO TODO : if the respiratory rate is needed, the freq should be considered.
  PULSE_MIN = .75;
  PULSE_MAX = 3.5;

  % threshold on pulse change per-measurement (12 bpm)
  PULSE_DELTA = .2;

  FS = 30; % sampling rate; video captured at ~30 fps
  WINDOW_SIZE = 30;   % window size in seconds
  OVERLAP     = 29;   % overlap in moving window in seconds

  % default to Fs of 30 fps if unspecified
  % default to 30 sec window with 96.7% overlap if no window args given
  if nargin == 1
    Fs = FS;
  end
  if nargin < 4
    win_size = WINDOW_SIZE;
    overlap = OVERLAP;
  end

  NUM_FREQS = 10; % number of top power frequencies to record

  % split channel traces into blocks by a moving window,
  % with the blocks normalized for zero mean and unit variance
  %%%size(traces)=> [m n] = [3, inf], 3 rows, each row vector is R,G,B channel
  trace_blocks = extract_normalized_windows(traces, win_size*Fs, overlap*Fs);
  num_channels = size(traces, 1);   %The 1st dim of traces is 3 rows, num_channels==3
  num_blocks = size(trace_blocks, 3);% get the 3rd dim of trace_blocks

  % measure pulse for each time window in each channel
  pulse = zeros([1 num_blocks]);% 1 x num_blocks matrix of zeros
  spectra = zeros([2 NUM_FREQS num_channels num_blocks]);% 2 x NUM_FREQS x num_channels x num_blocks
  for idx=1:num_blocks
    this_block = trace_blocks(:,:,idx);
    % progress output
    this_sec = (idx-1)*(win_size - overlap);
    fprintf('Measuring pulse over seconds %d - %d\n', [this_sec+1 this_sec+win_size]);

    % detrend window, is this necessary if this_block has been zero-mean???
    this_block = detrend(this_block')';

	%%% whitening, test code
	this_block = whiten(this_block);

    % find independent components by JADE
	% B = jadeR(X, m) is an m*n matrix such that Y=B*X are separated sources
	% extracted from the n*T data matrix X.
	% If m is omitted,  B=jadeR(X)  is a square n*n matrix (as many sources as sensors)
    B = jade(this_block);
    Y = B*this_block;	%Y[3 :], R,G,B channels

    % find independent components by RADICAL
    % http://people.cs.umass.edu/~elm/ICA/
    % http://www.measurement.sk/2005/S2/krishnaveni.pdf
    % http://www.mlpack.org/files/mlpack-1.0.10.tar.gz
    % http://www.mlpack.org/doxygen.php?doc=classmlpack_1_1radical_1_1Radical.html#_details
    % RADICAL on average outperformed Fast ICA, JADE, Kernel ICA, and the extended Infomax algorithms.
    % [Y, B] = RADICAL(this_block);

    % record power spectra for each channel trace & independent component
    for chn=1:num_channels
      % power spectra
      [ic_pows, ic_freq] = analyse_power_spectrum(Y(chn, :), Fs); % Y(chn, :) the chn row is used.
      [trace_pows, trace_freq] = analyse_power_spectrum(this_block(chn, :), Fs); %this_block is detrend and whiten, but no ICA yet
      [ic_ppows, ic_pfreq] = bandlimit(ic_pows, ic_freq, PULSE_MIN, PULSE_MAX); %filter
      [trace_ppows, trace_pfreq] = bandlimit(trace_pows, trace_freq, PULSE_MIN, PULSE_MAX);
      ic_spect(chn, :, :) = [ ic_pows ; ic_freq ];		%for plot signal show only
      trace_spect(chn, :, :) = [ trace_pows ; trace_freq ];	%for plot signal show only

      % rank frequencies by power
      [ic_max_pow ic_max_idx] = sort(ic_ppows, 'descend');
      ic_spectra(:, :, chn, idx) = [ic_pfreq(ic_max_idx(1:NUM_FREQS)) ; ...
                                    ic_max_pow(1:NUM_FREQS)];
      [trace_max_pow trace_max_idx] = sort(trace_ppows, 'descend');
      trace_spectra(:, :, chn, idx) = [trace_pfreq(trace_max_idx(1:NUM_FREQS)) ; ...
                                    trace_max_pow(1:NUM_FREQS)];
    end

    % pick maximum power frequency of any channel
    % within change threshold as pulse
    max_freqs = ic_spectra(1, :, :, idx);
    max_pows = ic_spectra(2, :, :, idx);
    if idx > 1
      last_pulse = pulse(idx-1);
      valid_freq_idx = find(max_freqs > last_pulse - PULSE_DELTA  ...
                            & max_freqs < last_pulse + PULSE_DELTA);
    else
      valid_freq_idx = 1:NUM_FREQS;
    end

    if length(valid_freq_idx) == 0
      % no frequency in valid range for this measurement; keep previous
      pulse(idx) = pulse(idx-1);
    else
      % pick the highest power frequency in valid range
      valid_freqs = max_freqs(valid_freq_idx)
      valid_pows = max_pows(valid_freq_idx);
      [v pulse_idx] = max(valid_pows);
      pulse(idx) = valid_freqs(pulse_idx);
    end

    % signal visualization
    %show_signals(this_block, Y, trace_spect, ic_spect, [PULSE_MIN PULSE_MAX]);
  end
end
