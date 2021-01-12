clear all, clc, close all, addpath(genpath(pwd))


%% Probamos a reconocer todas las matriculas del conjunto de datos Training

nCaracteresTrain = [7 7 6 7];

for i=1:length(nCaracteresTrain)
    
    Nombre = "Training_" + num2str(i, "%02d") + ".jpg";
    
    cadenaReconocida = Funcion_Reconoce_Matricula(Nombre, nCaracteresTrain(i));
    
    disp(Nombre + " -> " + cadenaReconocida);
    
end

%% %% Probamos a reconocer todas las matriculas del conjunto de datos Test
nCaracteresTest = [7 6 7 7 7 7 7 6 6 6 7 7 7 7 7 7 7 7 7 6];

for i=1:length(nCaracteresTest)
    
    Nombre = "Test_" + num2str(i, "%02d") + ".jpg";
    
    cadenaReconocida = Funcion_Reconoce_Matricula(Nombre, nCaracteresTest(i));
    
    disp(Nombre + " -> " + cadenaReconocida);
    
end

