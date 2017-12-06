function [ y Fs ] = LoadAudio( fname )
%LOADAUDIO Fun��o de compatibilidade entre MATLAB 2012~2017
%   Fun��o wavread n�o est� presente mais na vers�o 2016+
%   Fun��o audioread n�o rest� presente em 2012

    [y Fs] = audioread(fname);

end

