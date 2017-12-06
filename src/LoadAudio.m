function [ y Fs ] = LoadAudio( fname )
%LOADAUDIO Função de retrocompatibilidade entre MATLAB 2012~2017
%   Função wavread não está presente mais na versão 2016+
%   Função audioread não restá presente em 2012

    if ~ exist('wavread', 'file')
        wavread = @(f) audioread(f);
    end
    [y Fs] = wavread(fname);
end

