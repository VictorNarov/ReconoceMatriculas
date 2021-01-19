%%Procedimiento:
% Una vez segmentado el carácter de una matrícula y obtenido su bounding box,
% hay que cuantificar el grado de similitud de este con cada una de las plantillas facilitadas.
% El algoritmo decidirá que el carácter del objeto desconocido es aquel al que corresponde la plantilla 
% para la que se alcanza la correlación máxima.
function [cadenaReconocida, metricaSeparabilidad, caracteresParecidosMatricula] = funcion_ReconoceCaracteres(Ietiq, nCaracteres)

    Caracteres = '0123456789ABCDFGHKLNRSTXYZ';
    nCaracteresPosibles = length(Caracteres);
    load Plantillas.mat
    
    cadenaReconocida = "";
    
    %% Medir la confianza de cada detección
    % Diferencia de correlacion entre los dos caracteres mas probables
    metricaSeparabilidad = zeros(nCaracteres,1); 
    
    % Identificar cuál es el segundo caracter más probable
    caracteresParecidosMatricula = cell(nCaracteres,1);
    

    %% Por cada caracter
    for objeto=1:nCaracteres
        Iobj = Ietiq==objeto;
               
        %% Recortamos por el Bounding Box, fila y col max y min
        [F, C] = find(Iobj==true);
        Fmin = min(F); Fmax = max(F);
        Cmin = min(C); Cmax = max(C);

        % Región de interés (caracter recortado)
        ROI = Iobj(Fmin:Fmax, Cmin:Cmax);

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
        [FMaxCorr, CMaxCorr] = find(ValoresCorrelacion == max(ValoresCorrelacion(:)));
        
        caracterReconocido = Caracteres(FMaxCorr);
        
        
        % Guardamos la diferencia de correlacion del maximo al 2do maximo
        % OJO: no indicamos ValoresCorrelacion(:) porque queremos
        % diferenciar el mejor caracter del segundo mejor (filas), no
        % entre los distintos angulos de un caracter
        max2ValoresCorrelacion = maxk(ValoresCorrelacion,2);
        
        mejorValorCorrelacion = ValoresCorrelacion(FMaxCorr,CMaxCorr);
        segundoMejorValorCorrelacion = max(max2ValoresCorrelacion(2,:));
        
        % Diferencia entre el mejor caracter,angulo 
        % MENOS segundo mejor caracter,mejor angulo
        metricaSeparabilidad(objeto) = mejorValorCorrelacion - segundoMejorValorCorrelacion;
        
        % Añadimos el caracter reconocido a la cadena
        cadenaReconocida = cadenaReconocida + caracterReconocido;
    end
end

