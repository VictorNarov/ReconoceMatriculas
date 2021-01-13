clear all, clc, close all, addpath(genpath(pwd))

Caracteres = '0123456789ABCDFGHKLNRSTXYZ';

metricaCorrelacion = cell(length(Caracteres),1);

verbose = false; % Mostrar imagenes

%% Probamos a reconocer todas las matriculas del conjunto de datos Training

nCaracteresTrain = [7 7 6 7];

for i=1:length(nCaracteresTrain)
    
    Nombre = "Training_" + num2str(i, "%02d") + ".jpg";
    
    [cadenaReconocida, metricaSeparabilidad] = Funcion_Reconoce_Matricula(Nombre, nCaracteresTrain(i),verbose);
    
    disp(Nombre + " -> " + cadenaReconocida);
    
    
    %% Añadimos el valor de correlacion de cada caracter a su correspondiente array
    for j=1:strlength(cadenaReconocida)
        posCaracter = strfind(Caracteres, cadenaReconocida{1}(j));
        metricaCorrelacion{posCaracter} = [metricaCorrelacion{posCaracter} metricaSeparabilidad(j)];
    end

end

 %% Probamos a reconocer todas las matriculas del conjunto de datos Test
nCaracteresTest = [7 6 7 7 7 7 7 6 6 6 7 7 7 7 7 7 7 7 7 6];

for i=1:length(nCaracteresTest)
    
    Nombre = "Test_" + num2str(i, "%02d") + ".jpg";
    
    [cadenaReconocida, metricaSeparabilidad] = Funcion_Reconoce_Matricula(Nombre, nCaracteresTest(i),verbose);
    
    disp(Nombre + " -> " + cadenaReconocida);
    
    
        %% Añadimos el valor de correlacion de cada caracter a su correspondiente array
    for j=1:strlength(cadenaReconocida)
        posCaracter = strfind(Caracteres, cadenaReconocida{1}(j));
        metricaCorrelacion{posCaracter} = [metricaCorrelacion{posCaracter} metricaSeparabilidad(j)];
    end
end

%% Representamos la metrica de separabilidad de cada caracter

% Etiquetamos los datos de cada muestra de separabilidad con su
% correspondiente caracter
% Siendo XVCorr el valor de cada muestra de metrica de separabilidad
% y YVCorr la clase a la que pertenece (caracter reconocido)
XVCorr = []; YVCorr = [];
for i=1:length(Caracteres)
    
    valores = metricaCorrelacion{i};
    
    for j=1:length(valores)
        XVCorr = [XVCorr ; valores(j)];
        YVCorr = [YVCorr ; Caracteres(i)];
    end
   
end

% Representamos en un diagrama de caja
figure, hold on,
boxplot(XVCorr, YVCorr)
xlabel('Caracter reconocido')
ylabel('Dif. 2 mayores valores de correlacion (más es mejor)')
axis([ 0 length(Caracteres)+1 0 1 ])
title("Diagrama de caja - Métrica de separabilidad");

