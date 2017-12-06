
%% Distortion
[x Fs] = audioread('lead.wav');
gain = 10; % ganho em relação ao audio original (amplificador) (0-11)
tone = 1; % realça agudos (0-1)
y = Distortion(x, gain, tone, Fs);
sound(y, Fs);

%% Delay
[x Fs] = audioread('deltaclick.wav');
depth = 2;
delay = 1/8; %ms
feedback = 1/32;
y = Delay(x, depth, delay, feedback, Fs);
sound(y, Fs);

%% Flanger
[x Fs] = audioread('pen15.wav');
mix = 0.5; % (0 to 1)
delay = 0.1; % 100usec to 10msec (in msec) 0.1 to 10
width = 2; % 100nsec to 10msec
rate = 0.05; % 0.05 to 5 Hz
y = Flanger(x, mix, delay, width, rate, Fs);
sound(y, Fs);