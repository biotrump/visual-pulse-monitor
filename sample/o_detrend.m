## Copyright (C) 1995-2013 Kurt Hornik
##
## This file is part of Octave.
##
## Octave is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or (at
## your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {} detrend (@var{x}, @var{p})
## If @var{x} is a vector, @code{detrend (@var{x}, @var{p})} removes the
## best fit of a polynomial of order @var{p} from the data @var{x}.
##
## If @var{x} is a matrix, @code{detrend (@var{x}, @var{p})} does the same
## for each column in @var{x}.
##
## The second argument is optional.  If it is not specified, a value of 1
## is assumed.  This corresponds to removing a linear trend.
##
## The order of the polynomial can also be given as a string, in which case
## @var{p} must be either @qcode{"constant"} (corresponds to
## @code{@var{p}=0}) or
## @qcode{"linear"} (corresponds to @code{@var{p}=1}).
## @seealso{polyfit}
## @end deftypefn

## Author: KH <Kurt.Hornik@wu-wien.ac.at>
## Created: 11 October 1994
## Adapted-By: jwe

####Arithmetic Operators + - * / \ ^ '
####http://dali.feld.cvut.cz/ucebna/matlab/techdoc/ref/arithmeticoperators.html
#http://bime-matlab.blogspot.tw/2006/10/blog-post.html

#'
#Complex transpose A' ctranspose(A), if it's real, =>transpose(A).

#*
#Matrix multiplication A*B mtimes(A,B)

#-
#Binary subtraction A-B minus(A,B)

#\
#Backslash or matrix left division. If A is a square matrix, 
#A\B is roughly the same as inv(A)*B, except it is computed in a different way.
#mldivide(A,B)

#.^
#Array-wise power A.^B power(A,B)	, element to element, one by one
#x.^y = x1^y1, x2^y2, x3^y3 .... it's still an array.
#

#If you want to create a row vector, containing integers from 1 to 10, you write:
#(1:10) => 1     2     3     4     5     6     7     8     9    10
#(1:10)' transpose row to column

#x is a 1xn matrix (row vector)
function dy = detrend (y, p = 1)
  ## Check input
  if (nargin > 0 && isreal (y) && ndims (y) <= 2)
    ## Check p
    if (ischar (p) && strcmpi (p, "constant"))
      p = 0;
    elseif (ischar (p) && strcmpi (p, "linear"))
      p = 1;
    elseif (!isscalar (p) || p < 0 || p != fix (p))
      error ("detrend: second input argument must be 'constant', 'linear' or a positive integer");
    endif
  else
    error ("detrend: first input argument must be a real vector or matrix");
  endif

  [m, n] = size (y); #y is 1xn, so m=1
  if (m == 1)
    y = y';	#row vector to column vector
  endif

  r = rows (y); # number of rows of the matrix
  x = ((1 : r)' * ones (1, p + 1)) .^ (ones (r, 1) * (0 : p));
#x is called design matrix. each element (1,Xi)
#if (x,y) pair is from a 1-d discrete signal with a fixed sample period,
#so x is the sample time number 1,2,3,4,5,6,..... with respect to y1,y2,y3..
#so (x,y) pair is (1,y1), (2,y2),(3,y3)...(n,yn)
#x =
#     1     1
%     1     2
%     1     3
%     1     4
%     1     5
%     1     6
%     1     7
%     1     8
%	....
%	  1
# the Residuals are e = y - x * b, this is a detrend data in epsilon.
#where b = inv(x*x') *x'*y
#dy= episolon e
  dy = y - x * (x \ y); # ==> (x \ y) = INV(x)*y

  if (m == 1)
    dy = dy';
  endif

endfunction


%!test
%! N = 32;
%! x = (0:1:N-1)/N + 2;
%! y = detrend (x);
%! assert (abs (y(:)) < 20*eps);

%!test
%! N = 32;
%! t = (0:1:N-1)/N;
%! x = t .* t + 2;
%! y = detrend (x,2);
%! assert (abs (y(:)) < 30*eps);

%!test
%! N = 32;
%! t = (0:1:N-1)/N;
%! x = [t;4*t-3]';
%! y = detrend (x);
%! assert (abs (y(:)) < 20*eps);

