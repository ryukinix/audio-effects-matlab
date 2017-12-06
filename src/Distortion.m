function [ y ] = Distortion(in, gain, tone, fs)
% DISTORTION simula um efeito de distorção de pedais de guitarra
%
% VARIÁVEIS:
%   IN - audio de entrada como um vetor coluna input guitar audio column vector
%   GAIN - quantidade de ganho ao aplicar o filtro -- (0 a 11)
%   TONE - 0 para tons baixo, 1 para agudos (um polo no filtro passa banda)
%     FS - Frequência de Amostragem

    dbstop if error

    % GAIN BEFORE NONLINEARITY
    b=in;
    b=b/max(abs(b));
    b=gain*b;

    % NONLINEARITY
    i=(b>=0.75); b(i)=1;  % hard clipping on +ve edge
    i=(b<=-2/3); b(i)=-1; % hard clipping on -ve edge

    % região linear deixada de lado entre -1/3 e 1/2
    % parabola para conectar regi�es lineares e saturadas

    % coeficientes de parabola de corte suave no limite de +ve
    c1=4*sqrt(2); c2=3*sqrt(2);
    i=(b>=0.5 & b<=0.75);
    b(i)=(4-(c2-c1*b(i)).^2)./4;

    % coeficientes de parabola de corte suave no limite de -ve
    c2=4-sqrt(6); c1=6-3*sqrt(6);
    i=(b<=-1/3 & b>=-2/3);
    b(i)=(3-(c2+c1*b(i)).^2)./3;

    % TONE SECTION - sobrepor dois filtros butterworth de primeira ordem
    [ZL,PL,KL]= butter(1, 1200/(fs/2), 'low');
    [ZH,PH,KH]= butter(1, 265/(fs/2), 'high');
    [BL,AL]=zp2tf(ZL,PL,KL); % calcula a fun��o de transfer�ncia
    [BH,AH]=zp2tf(ZH,PH,KH); % fun��o de transfer�ncia

    y=(1-tone)*filter(BL,AL,b)+tone*filter(BH,AH,b);
end

