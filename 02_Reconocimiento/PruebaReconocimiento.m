clear all, clc, close all, addpath(genpath(pwd))

%El problema está restringido al reconocimiento de los siguientes caracteres, 
%que son todos los que aparecen en las placas de matrícula facilitadas:
Caracteres = '0123456789ABCDFGHKLNRSTXYZ';

%% Metodología de reconocimiento: ajuste de plantillas mediante 
% correlación bidimensional normalizada (template matching). 
%Este procedimiento evalúa la similitud del carácter desconocido 
% con plantillas generadas a priori de caracteres conocidos. 
%El reconocimiento del carácter se decide según la plantilla para la que se alcanza la máxima similitud.

%%Procedimiento:
% Una vez segmentado el carácter de una matrícula y obtenido su bounding box,
% hay que cuantificar el grado de similitud de este con cada una de las plantillas facilitadas.
% Implementa para ello una función que calcule la correlación normalizada entre dos matrices bidimensionales de igual dimensión:
% El algoritmo decidirá que el carácter del objeto desconocido es aquel al que corresponde la plantilla para la que se alcanza la correlación máxima.
load Plantillas.mat
%% Por cada imagen de matricula
nCaracteresPosibles = length(Caracteres);
nCaracteresTrain = [7 7 6 7];
nCaracteresTest = [7 6 7 7 7 7 7 6 6 6 7 7 7 7 7 7 7 7 7 6];


for i=1:length(nCaracteresTest)
    CadenaReconocida = "";
    Nombre = "Test_" + num2str(i, "%02d") + ".jpg";
    I = imread(Nombre);
    
    %% Obtenemos su imagen segmentada
    Ietiq = funcion_segmentaCaracteres(Nombre,nCaracteresTest(i));
    
    %% Por cada caracter
    for objeto=1:nCaracteresTest(i)
        Iobj = Ietiq==objeto;
               
        %% Recortamos por el Bounding Box, fila y col max y min
        [F, C] = find(Iobj==true);
        Fmin = min(F); Fmax = max(F);
        Cmin = min(C); Cmax = max(C);

        % Región de interés (caracter recortado)
        ROI = Iobj(Fmin:Fmax, Cmin:Cmax);

        [M,N] = size(ROI);

        %% Hacemos el template matching con todas las plantillas
        nAngulos = 7;
        ValoresCorrelacion = zeros(nCaracteresPosibles, nAngulos);
        
        for objetoT=1:nCaracteresPosibles
            for anguloT=1:nAngulos
                 
                % Cargamos la plantilla
                nombreT = "Objeto" + num2str(objetoT, '%02d') + "Angulo" + num2str(anguloT, '%02d');
                T = eval(nombreT);
                
                % Ajustamos el tamaño de la imagen a la plantilla
                [MT, NT] = size(T);
                ROIrecortada = imresize(ROI, [MT NT]);
                
                % Medimos su valor de correlacion normal cruzada
                ValoresCorrelacion(objetoT, anguloT) = funcion_CorrelacionMatrices(ROIrecortada, T);
            end
        end
        
        % Buscamos el objeto de la plantilla de mayor correlacion
        [FMaxCorr, ~] = find(ValoresCorrelacion == max(ValoresCorrelacion(:)));
        
        caracterReconocido = Caracteres(FMaxCorr);
        
        % Añadimos el caracter reconocido a la cadena
        CadenaReconocida = CadenaReconocida + caracterReconocido;
    end
    
    % Visualizamos
    figure, imshow(I), hold on, funcion_pintaBBCentroide(Ietiq), title(Nombre+ " - "+ CadenaReconocida);
    
    %% Para automatizar el proceso en la etapa, hemos programado la funcion_reconoceCaracteres
    % Que recibe como entrada una imagen binaria segmentada y etiquetada
    % de los caracteres y devuelve la cadena reconocida usando el metodo de
    % template matching de mayor valor de correlación
end
