clear all, clc, close all, addpath(genpath(pwd))

Caracteres = '0123456789ABCDFGHKLNRSTXYZ';

metricaCorrelacion = cell(length(Caracteres),1);

% 26x26 CARACTER REAL X 2do CARACTER PREDICHO
posCaracteresParecidos = zeros(length(Caracteres));


verbose = true; % Mostrar imagenes

%% Probamos a reconocer todas las matriculas del conjunto de datos Training

% nCaracteresTrain = [7 7 6 7];
% 
% for i=1:length(nCaracteresTrain)
%     
%     Nombre = "Training_" + num2str(i, "%02d") + ".jpg";
%     
%     [cadenaReconocida, metricaSeparabilidad] = Funcion_Reconoce_Matricula(Nombre, nCaracteresTrain(i),verbose);
%     
%     disp(Nombre + " -> " + cadenaReconocida);
%     
%     
%     %% Añadimos el valor de correlacion de cada caracter a su correspondiente array
%     for j=1:strlength(cadenaReconocida)
%         posCaracter = strfind(Caracteres, cadenaReconocida{1}(j));
%         metricaCorrelacion{posCaracter} = [metricaCorrelacion{posCaracter} metricaSeparabilidad(j)];
%     end
% 
% end

 %% Probamos a reconocer todas las matriculas del conjunto de datos Test
nCaracteresTest = [7 6 7 7 7 7 7 6 6 6 7 7 7 7 7 7 7 7 7 6];

for i=1:length(nCaracteresTest)
    
    Nombre = "Test_" + num2str(i, "%02d") + ".jpg";
    
    [cadenaReconocida, metricaSeparabilidad, iCaracteresParecidos] = Funcion_Reconoce_Matricula(Nombre, nCaracteresTest(i),verbose);
    
    disp(Nombre + " -> " + cadenaReconocida);
    
    
    %% Añadimos el valor de correlacion de cada caracter a su correspondiente array
    for j=1:strlength(cadenaReconocida)
        posCaracter = strfind(Caracteres, cadenaReconocida{1}(j));
        metricaCorrelacion{posCaracter} = [metricaCorrelacion{posCaracter} metricaSeparabilidad(j)];
    
    
    %% Sumamos un voto al caracter más parecido
        posCaracteresParecidos(posCaracter,iCaracteresParecidos(j)) =  posCaracteresParecidos(posCaracter,iCaracteresParecidos(j)) + 1;
    end   
end



%% Representamos la metrica de separabilidad de cada caracter

% Creamos las etiquetas para la representacion
% Caracter - caracter mas parecido (numVotos); ...
etiquetas = cell(length(Caracteres),1);

for i=1:length(Caracteres)
   
    [votos, posCaracter] = maxk(posCaracteresParecidos(i,:),3);
    etiquetas{i} = [Caracteres(i) ':' '\newline'];
    for j=1:3
       if votos(j) > 0
            etiquetas{i} = [etiquetas{i} Caracteres(posCaracter(j)) '(' num2str(votos(j)) ')' '\newline'];
       end
    end
end


% Etiquetamos los datos de cada muestra de separabilidad con su
% correspondiente caracter
% Siendo XVCorr el valor de cada muestra de metrica de separabilidad
% y YVCorr la clase a la que pertenece (caracter reconocido)
XVCorr = []; YVCorr = [];
for i=1:length(Caracteres)
    
    valores = metricaCorrelacion{i};
    
    for j=1:length(valores)
        XVCorr = [XVCorr ; valores(j)];
        YVCorr = [YVCorr ; etiquetas(i)];
    end
   
end

% Representamos en un diagrama de caja
figure, hold on,
boxplot(XVCorr, YVCorr)
xlabel('Caracter reconocido')
ylabel('Dif. 2 mayores valores de correlacion (más es mejor)')
axis([ 0 length(Caracteres)+1 0 1 ])
title("Diagrama de caja - Métrica de separabilidad");
fix_xticklabels();

