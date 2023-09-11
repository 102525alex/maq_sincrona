Parametros;

disp('');
disp('Espere un momento.....la simulacion esta en progreso')
tic;
sim('Maq_Sincronica',tstop);
toc
disp('');
disp('Simulacion finalizada')

clock = ans.salida(:,1); %#ok<*NOANS>
Pgen = ans.salida(:,2);
Qgen = ans.salida(:,3);
Vt = ans.salida(:,4);
it = ans.salida(:,5);


figure (1);
        plot(clock, Pgen);
        title ('Pgen vs Tiempo');
        ylabel('P_g_e_n [pu]');
        xlabel('Tiempo [s]');
        grid on
        
figure (2);
        plot(clock, Qgen);
        title ('Qgen vs Tiempo');
        ylabel('Q_g_e_n [pu]');
        xlabel('Tiempo [s]');
        grid on
figure (3);
        plot(clock, round(Vt));
        title ('Vt vs Tiempo');
        ylabel('|Vt| [pu]');
        xlabel('Tiempo [s]');
        grid on
           
figure (4);
        plot(clock, it);
        title ('It vs Tiempo');
        ylabel('|It| [pu]');
        xlabel('Tiempo [s]');
        grid on
   