function [ out ] = Delay( in, depth, delay, feedback, fs)
%DELAY Summary of this function goes here
%
% VARIÁVEIS:
%   IN - input -> audio da guitarra como vetor coluna 
%   DEPTH - 0 (sem sinal delay adicionado) a 1 (amplitude do sinal
%   igual )
%   DELAY - tempo de delay: de 0.1 milisegundos (0.0001 seg) a 8 seg (e seg)
%   FEEDBACK - ganho de feedback - amplitude do sinal defasado para
%              servir de feedback should be 0 < f < 1

    dbstop if error

    sampleDelay = ceil(delay*fs); % delay em sec * samp/sec = samples
    delayedSignal = [zeros(sampleDelay,1);in(1:end);zeros(64*fs-sampleDelay,1)];
    % primeiro delay no começo preenchendo com zeros
    % então o final do preenchimento do sinal defasado no resto dos
    % sinais defasados que irão vir por feedback
    % abaixo, está também preenchido com o mesmo número de zeros
    % para lidar com longos tempos de delay
    in=[in;zeros(64*fs,1)];

    n=1; %variável de iteração para número de delays
    while feedback >= 0.0001 % decrescer continuamente o feedbck no
        delayedSignal=delayedSignal+...
            feedback*[zeros(sampleDelay*n,1);...
            delayedSignal(1:end-sampleDelay*n)];
        feedback=feedback^2;
        n=n+1;
    end

    out = in + depth*delayedSignal;

    % removendo excesso de zeros no fim
    content = find(out,1,'last');
    out = out(1:content);

end

