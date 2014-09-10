function [pass_pows pass_freq] = bandlimit(pows, freq, low, high)
  %pows, freq are all sorted/ordered by the freq along the index axis.
  % The larger the index, the larger the frequency.
  % select a certain frequency range from the power spectrum of a signal
  % find the upper and lower bound
  low_limit = min(find(freq > low));  % find the elements of freq, 1-d array, whose element is greater than low.
                                      % the return of the find is the index list to the found elements, but not the elements.
                                      % and then get the minimized index from the return of the find.
  high_limit = max(find(freq < high));

  pass = low_limit:high_limit;  %the upper and lower bound index
  pass_pows = pows(pass);
  pass_freq = freq(pass);
end
