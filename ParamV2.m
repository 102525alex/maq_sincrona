% clc; clear all; close all;
tstop = 9; % tiempo de simulación 
Vm=120*sqrt(2);
Srated=920.35e6;           %Volt Amperios
Nrated=1800;                 %rpm
xls = 0.215;                    % reactancia de fuga del estator en ohmios [p.u]
xd = 1.790;                     % [p.u]
xpd = 0.355;                   % [p.u]
xppd = 0.275;                 % [p.u]
Tpdo = 7.9;                    %[s]
Tppdo = 0.032;               %[s]
H = 3.77;




Vrated = 18e3;               %  tensión nominal de línea a línea en V 
Pfrated= 0.9;                  %Factor de potencia
rs = 0.0048;                  % [p.u]
xq = 1.660;                   % [p.u]
xpq = 0.570;                 % [p.u]
xppq = 0.275;               % [p.u]
Tpqo = 0.41;                 % [s]
Tppqo = 0.055;             % [s]
Domega = 0;                  % coeficiente de amortiguamiento mecánico
%//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

% Prated = 15e6;  
% Prated = 750;                                   % potencia de salida nominal W
Prated=Pfrated*Srated;

% KA = 50;
% TA =.06;
% VRmax = 1;
% VRmin = -1;
% TE = 0.052;
% KE = -0.0465;
% TF = 1.0;2;
% AEx = 0.0012; 
% KF = 0.083;
% BEx = 1.264;
Frated=60;
frated=Frated;
P = 4;                    % número de polos


%///////////////////////////////////////////////////////////////////////////////////////////////
% Cantidades base
we = 2*pi*Frated;
wbase = 2*pi*Frated;
wbasem = wbase*(2/P);
% Sbase = Prated/Pfrated;
Sbase = Srated;
Vbase = Vrated*sqrt(2/3); 
Ibase = sqrt(2)*(Sbase/(sqrt(3)*Vrated));
Zbase = Vbase/Ibase;
Tbase = Sbase/wbasem;

% Para calcular los parámetros del circuito equivalentes dq0 
xmq = xq - xls;
xmd = xd - xls;

xplf = xmd*(xpd - xls)/(xmd - (xpd-xls));

xplkd = xmd*xplf*(xppd-xls)/(xplf*xmd - (xppd-xls)*(xmd+xplf));

xplkq = xmq*(xppq - xls)/(xmq - (xppq-xls));

rpf = (xplf + xmd)/(wbase*Tpdo);

rpkd = (xplkd + xpd - xls)/(wbase*Tppdo);

rpkq = (xplkq + xmq)/(wbase*Tppqo);

% Conversión a parámetros de circuito dqo por unidad
rs = rs/Zbase;
xls = xls/Zbase;

xppd = xppd/Zbase;
xppq = xppq/Zbase;
xpd = xpd/Zbase;
xpq = xpq/Zbase;

xd = xd/Zbase;
xq = xq/Zbase;

xmd = xmd/Zbase;
xmq = xmq/Zbase;

rpf = rpf/Zbase;
rpkd = rpkd/Zbase;
rpkq = rpkq/Zbase;

xplf = xplf/Zbase;
xplkd = xplkd/Zbase;
xplkq = xplkq/Zbase;


%******************
% Condiciones iniciales para la simulación

wb=wbase;
xMQ = (1/xls + 1/xmq + 1/xplkq)^(-1);
xMD = (1/xls + 1/xmd + 1/xplf + 1/xplkd)^(-1);

%Condiciones de funcionamiento
P = 1.0;% rango e incremento de la parte real
Q = 0; 	%Potencia reactiva de salida
Vt = 1. + 0*j; % voltaje terminal
% Vm = abs(Vt);
thetaeo = angle(Vt); %  valor inicial del ángulo de voltaje
St = P+Q*j;	% potencia compleja de salida del generador
  
% Ecuaciones del fasor en estado estacionario 
  It = conj(St/Vt); % corriente fasorial del generador
  Eq = Vt + (rs + j*xq)*It; %Tensión detrás de la reactancia del eje q 
  delt = angle(Eq);          % ángulo Eq conduce a Vt

% Variables en estado estable q-d 
%   Eqo = abs(Eq);
%   I = It*(cos(delt) - sin(delt)*j); 
%   Iqo = real(I);
%   Ido = -imag(I);      
%   Efo = Eqo + (xd-xq)*Ido;
%   Ifo = Efo/xmd;
%   Psiado = xmd*(-Ido + Ifo);
%   Psiaqo = xmq*(-Iqo);
%   Psiqo = xls*(-Iqo) + Psiaqo;
%   Psido = xls*(-Ido) + Psiado;
  
  
  Eqo = 0;
  I = It*(cos(delt) - sin(delt)*j); % same as I = (conj(Eq)/Eqo)*It;
  Iqo = 0;
  Ido = 1;      
  Efo = 2.056;
  Ifo = Efo/xmd;
  Psiado = 1;
  Psiaqo =0;
  Psiqo = 0;
  Psido =1;



Psifo=1;
  Psikqo = Psiaqo;
  Psikdo = Psiado;

  Vto = Vt*(cos(delt) - sin(delt)*j);
  Vqo = real(Vto);
  Vdo = -imag(Vto);
  Sto = Vto*conj(I);
  Eqpo = Vqo + xpd*Ido + rs*Iqo;
  Edpo = Vdo - xpq*Iqo + rs*Ido;
  
  delto = delt; % valor inicial del ángulo del rotor
  thetaro = delto+thetaeo;% thetar(0) en el oscilador de frecuencia variable
  Pemo = real(Sto);
  Qemo = imag(Sto);
  Tmech = Pemo;
  


tmech_time =   [4 5.5 5.5 7.5 7.5 tstop];
tmech_value = [1 1 0 0 -1 -1]*Tmech; 

tef_time = [0 tstop];
tef_value = [1 1]*Efo;