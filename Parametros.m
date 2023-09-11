%Parametros
tstop=5;
F=60;
wb=2*pi*F;
Perunit = 1;
xqp = 0.570;

rs=0.0048;
xls=0.215;

xd=1.790;
xmd=xd-xls;

xq=1.660;
xmq=xq-xls;

H=3.77;
Domega=0;

xdp=0.355;
xplf=(xmd*(xdp-xls)/(xmd-(xdp-xls)));

xdpp=0.275;
xplkd=(((xdpp-xls)*xmd*xplf)/(xplf*xmd-(xdpp-xls)*(xmd+xplf)));

Tdop=7.9;
rpf=((xplf+xmd)/(wb*Tdop));

Tdopp=0.032;
rpkd=((xplkd+xdp-xls)/(wb*Tdopp));

xqpp=0.275;
xplkq=(xmq*(xqpp-xls))/(xmq-(xqpp-xls));

Tqopp=0.055;
rpkq=((xplkq+xmq)/(wb*Tqopp));

xMQ = (1/xls + 1/xmq + 1/xplkq)^(-1);
xMD = (1/xls + 1/xmd + 1/xplf + 1/xplkd)^(-1);


P=1;
Q=0;
Vt = 1. + 0*j;          %#ok<*IJCL>
thetaeo = angle(Vt);   
Vm = abs(Vt);
St = P+Q*j;	

It = conj(St/Vt);
Eq = Vt + (rs + j*xq)*It; 
  delt = angle(Eq);
  
Eqo = abs(Eq);
I = It*(cos(delt) - sin(delt)*j);% same as I = (conj(Eq)/Eqo)*It;
Iqo = real(I);
Ido = -imag(I);        % when the d-axis lags the q-axis
Efo = Eqo + (xd-xq)*Ido;
Ifo = Efo/xmd;

Psiado = xmd*(-Ido + Ifo);
Psiaqo = xmq*(-Iqo);

Psiqo = xls*(-Iqo) + Psiaqo;
Psido = xls*(-Ido) + Psiado;
Psifo = xplf*Ifo + Psiado;
Psikqo = Psiaqo;
Psikdo = Psiado;

Vto = Vt*(cos(delt) - sin(delt)*j);
Vqo = real(Vto);
Vdo = -imag(Vto);
Sto = Vto*conj(I);
Eqpo = Vqo + xdp*Ido + rs*Iqo;
Edpo = Vdo - xqp*Iqo + rs*Ido;
  
delto = delt;% initial value of rotor angle
thetaro = delto+thetaeo;% thetar(0) in variable frequency oscillator
Pemo = real(Sto);
Qemo = imag(Sto);
Tmech = Pemo;
  
tmech_time=[0  0.5  0.5  3  3  tstop];
tmech_value= [1  1  0  0  -1  -1]*Tmech;

ef=1;
tef_time=[0 0.5 3 tstop];
tef_value= [1  1  1 1]*ef;
  
