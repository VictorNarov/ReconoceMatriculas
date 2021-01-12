clear all, clc, close all, addpath(genpath(pwd))

Caracteres = '0123456789ABCDFGHKLNRSTXYZ';

metricaCorrelacion = cell(length(Caracteres),1);
%% Probamos a reconocer todas las matriculas del conjunto de datos Training

nCaracteresTrain = [7 7 6 7];

for i=1:length(nCaracteresTrain)
    
    Nombre = "Training_" + num2str(i, "%02d") + ".jpg";
    
    [cadenaReconocida, metricaSeparabilidad] = Funcion_Reconoce_Matricula(Nombre, nCaracteresTrain(i));
    
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
    
    [cadenaReconocida, metricaSeparabilidad] = Funcion_Reconoce_Matricula(Nombre, nCaracteresTest(i));
    
    disp(Nombre + " -> " + cadenaReconocida);
    
    
        %% Añadimos el valor de correlacion de cada caracter a su correspondiente array
    for j=1:strlength(cadenaReconocida)
        posCaracter = strfind(Caracteres, cadenaReconocida{1}(j));
        metricaCorrelacion{posCaracter} = [metricaCorrelacion{posCaracter} metricaSeparabilidad(j)];
    end
end

%% Representamos la metrica de separabilidad de cada caracter
bpFigure = figure; hold on

for i=1:10
    figure(bpFigure),
    subplot(1,10,i), boxplot(metricaCorrelacion{i})
    xlabel('Diagrama de Caja')
    ylabel('Valor de correlacion')
    axis([ 0 2 0 1 ])
    title("Caracter: " +Caracteres(i));
end

