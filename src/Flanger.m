function [out] = Flanger(in,mix,delay,width,rate,fs)
%FLANGER simulates a guitar flanger effect pedal
%
% VARIÁVEIS:
%   IN - vetor coluna de entrada representando um audio
%   MIX - depth - amplitude do sinal atrasado adicionado na entrada (0 a 1)
%   DELAY - tempo de delay mínimo - 100usec a 10msec (em msec) 0.1 to 10
%   WIDTH - sweep depth - quão largo a troca é (100nsec to 10msec) 
%           (in msec, 0.0001)
%   RATE - frequência do Oscilador de Baixa Frequência (LFO) - 0.05 to 5 Hz
%     FS - Frequência de Amostragem

    in=interp1(1:length(in),in,1:.25:length(in));
    fsn=fs*4;

    minDelaySamp=ceil(delay*fsn/1000); %converte para (ms), então amostras
    maxDelaySamp=ceil((delay+width)*fsn/1000); %converte para (ms),então amostras
    n=(1:length(in)+maxDelaySamp)'; %quanto extender pelo LFO 
    LFO=sawtooth(2*pi*rate/(fsn)*n,.5); %sawtooth comumente usado
                                        %em flangers
    delayTimeSamples=(delay+width/2+width/2*LFO)*fsn/1000; 
    % instantaneous delay in samples (computed by looking at graph from class
    % PDF)

    out=zeros(length(in)+minDelaySamp,1); % inicializar vetor de saída

    out(1:maxDelaySamp)=in(1:maxDelaySamp); 
    % copiar frente do sinal antes do delay mínimo

    for i=maxDelaySamp+1:length(in) % começando pela próxima amostra
        delaySamples=ceil(delayTimeSamples(i)); %número inteiro do delay atual
        out(i)=in(i)+mix*out(i-delaySamples); %adiciona entrada e fração de delay
    end
 
   
    out=downsample(out,4);

end

