function [a,b,y] = make_notch_filter(x, fs, notchFreq, notchWidth)

fn = fs/2;              %Nyquist frequency
freqRatio = notchFreq/fn;      %ratio of notch freq. to Nyquist freq.

if nargin<4
    notchWidth = .5/(.5*fs);       %width of the notch
end

%Compute zeros
zeros = [exp( sqrt(-1)*pi*freqRatio ), exp( -sqrt(-1)*pi*freqRatio )];

%Compute poles
poles = (1-notchWidth) * zeros;

%figure;
%zplane(zeros.', poles.');

b = poly( zeros ); % Get moving average filter coefficients
a = poly( poles ); % Get autoregressive filter coefficients

% Frequency response of the filter created (for reference purposes?)
% figure;
% freqz(b,a,32000,fs)

if nargout==3
    % In addition to returing the filter (coef.) created, also do and return 
    % the filtered signal x
    y = filter(b,a,x);
end
    