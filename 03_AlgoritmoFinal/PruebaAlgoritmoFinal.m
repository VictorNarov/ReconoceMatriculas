clear all, clc, close all, addpath(genpath(pwd))

Caracteres = '0123456789ABCDFGHKLNRSTXYZ';
cadenasTrainingReales = ["9014FCF";"8585GBX";"H0853Z";"H2305AB";"H2305AB"];
cadenasTestReales = ["7824BLX";"H0504S";"1374BXC";"8959DDY";"3189FYY";"4787DCX";"H2305AB";"H0853Z";"H2462Y";"H0612Y";"3189FYY";"4787DCX";"7226BLK";"3680FSH";"1675FLR";"9315FTC";"2904CNN";"8959DDY";"8959DDY";"H0612Y"];

metricaCorrelacion = cell(length(Caracteres),1);

% 26x26 CARACTER REAL X 2do CARACTER PREDICHO
posCaracteresParecidos = zeros(length(Caracteres));


verbose = false; % Mostrar imagenes

%% Probamos a reconocer todas las matriculas del conjunto de datos Training

nCaracteresTrain = [7 7 6 7];

for i=1:length(nCaracteresTrain)
    
    Nombre = "Training_" + num2str(i, "%02d") + ".jpg";
    
    [cadenaReconocida, metricaSeparabilidad, iCaracteresParecidos] = Funcion_Reconoce_Matricula(Nombre, nCaracteresTrain(i), cadenasTrainingReales(i),verbose);
    
    disp(Nombre + " -> " + cadenaReconocida);
      
    
    %% Añadimos el valor de correlacion de cada caracter a su correspondiente array
    for j=1:strlength(cadenaReconocida)
        posCaracter = strfind(Caracteres, cadenaReconocida{1}(j));
        metricaCorrelacion{posCaracter} = [metricaCorrelacion{posCaracter} metricaSeparabilidad(j)];
    
    %% Sumamos un voto al caracter más parecido
        posCaracteresParecidos(posCaracter,iCaracteresParecidos(j)) =  posCaracteresParecidos(posCaracter,iCaracteresParecidos(j)) + 1;
    end   

end

 %% Probamos a reconocer todas las matriculas del conjunto de datos Test
nCaracteresTest = [7 6 7 7 7 7 7 6 6 6 7 7 7 7 7 7 7 7 7 6];

for i=1:length(nCaracteresTest)
    
    Nombre = "Test_" + num2str(i, "%02d") + ".jpg";
    
    [cadenaReconocida, metricaSeparabilidad, iCaracteresParecidos] = Funcion_Reconoce_Matricula(Nombre, nCaracteresTest(i), cadenasTestReales(i),verbose);
    
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

% Medir la confianza de acierto de cada caracter en forma de probabilidad
% Modelamos los parametros en forma de distribucion gaussiana
% Area que encierra la curva=1.
% Area diferencias positivas (acierto en prediccion) probabilidad acierto
% Area Diferencias negativas (fallo en prediccion) es la probabilidad de error
confianzas = {};
for i=1:length(Caracteres)

     valores = metricaCorrelacion{i};
     
     media = mean(valores);
     desv = std(valores);
     
     % Medir el area por debajo de 0
     % Integral de -inf a 0 (Probabilidad de error)
     pError = normcdf(0, media, desv);
     pAcierto = 1 - pError;
     
     confianzas{i} = pAcierto;    
end


% Creamos las etiquetas para la representacion
% Caracter - caracter mas parecido (numVotos); ...
etiquetas = cell(length(Caracteres),1);

for i=1:length(Caracteres)
    confianza = num2str(round(confianzas{i},2) * 100);
    [votos, posCaracter] = maxk(posCaracteresParecidos(i,:),3);
    etiquetas{i} = [Caracteres(i) ' (' confianza '%)' '\newline'];
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

