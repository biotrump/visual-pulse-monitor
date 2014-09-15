function [windows] = extract_normalized_windows(traces, window_len, overlap)
%%%size(traces)=> [m n] = [3, inf], 3 rows, each row vector is R,G,B channel
%%window_len :total frames in a window, to be analyze in a time
%%%overlap : the overlapped frames in the window
  % Extract moving window from traces according to window length
  % and the desired overlap (both in number of frames),
  % then normalize each window to have zero mean and unit variance

  % FIXME implement as clever vectorization

  % roll out traces into a matrix of window rows
  num_channels = size(traces, 1);%the first dim is row, rows=3 channels, R,G,B
  win_spacing = window_len - overlap;   %frames diff from total frames minus overlapped frames
  %%%length : return the max elements among dimensions
  %%%length(traces) : The total frames in a channel. since row vector is R,G,B channel, the column elements of a row
  %%%is the observed data.
  %%%(total frames in a channel - overlapped frames in a window) => the total left frames to scan in a channel.
  %%% num_windows : the total windows to process in a channel, but skipping the first overlapped frames.
  
  fprintf('length(traces)=%d frames  ', length(traces)); % total sample data
  fprintf('overlap=%d frames  ', overlap);
  fprintf('win_spacing=%d frames\n', win_spacing);
  
  num_windows = floor((length(traces) - overlap) / win_spacing); %length : return the max elements among dimensions
  
  fprintf(' num_windows=%d\n',  num_windows);
  
  %%% num_windows*num_channels : RGB channel(3 channel) * total scanning windows ==> total scanning windows in R and G andB channels.
  %%window_len :total frames in a window
  trace_windows = zeros([window_len num_windows*num_channels]);
  fprintf('[window_len=%d num_windows*num_channels=%d * %d = %d ]\n', [window_len num_windows num_channels num_windows*num_channels]);
  
  %%% procecssing the total windows in a channel
  for win=1:num_windows
    win_start = (win-1)*win_spacing + 1;    %unit is frame
    win_end = win_start + window_len - 1;   %unit is frames
    tr_win_idx = (win-1)*num_channels + 1;
    tr_win_end = tr_win_idx + num_channels - 1;
    trace_windows(:, tr_win_idx:tr_win_end) = traces(:, win_start:win_end)';
  end

  % normalize each trace window to have zero mean and unit variance
  % repmat(A,[2 3]) => A can be any mxn matrix or single data or 1-d array
  % replicate A to 2x3 Matrix as
  % A A A
  % A A A
  trace_windows = trace_windows - repmat(mean(trace_windows), [window_len 1]);
  trace_windows = trace_windows ./ repmat(std(trace_windows), [window_len 1]);

  % create a channels * frames * windows matrix
  fprintf('reshape trace_windows[%d %d] [window_len=%d num_channels=%d num_windows=%d] \n', [size(trace_windows) window_len num_channels num_windows] );
  windows = reshape(trace_windows, [window_len num_channels num_windows]);
  fprintf('to windows[%d %d %d]\n', size(windows));
  windows = permute(windows, [2 1 3]);
  fprintf('[2 1 3] permute : windows[%d %d %d]\n\n', size(windows));
end
