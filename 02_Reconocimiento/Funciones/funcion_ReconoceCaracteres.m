%%Procedimiento:
% Una vez segmentado el carácter de una matrícula y obtenido su bounding box,
% hay que cuantificar el grado de similitud de este con cada una de las plantillas facilitadas.
% El algoritmo decidirá que el carácter del objeto desconocido es aquel al que corresponde la plantilla 
% para la que se alcanza la correlación máxima.
function [cadenaReconocida, metricaSeparabilidad, iCaracteresParecidos] = funcion_ReconoceCaracteres(Ietiq, nCaracteres, cadenaReal)

    Caracteres = '0123456789ABCDFGHKLNRSTXYZ';
    nCaracteresPosibles = length(Caracteres);
    load Plantillas.mat
    
    cadenaReconocida = "";
    iCaracteresParecidos= zeros(nCaracteres,1);
    
    %% Medir la confianza de cada detección
    % Diferencia de correlacion entre los dos caracteres mas probables
    metricaSeparabilidad = zeros(nCaracteres,1); 
        

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
        mejorValorCorrelacion = ValoresCorrelacion(FMaxCorr,CMaxCorr);
        
        caracterReconocido = Caracteres(FMaxCorr);
         
        % Guardamos la diferencia de correlacion del valor predicho al real
        % Ponemos a cero la fila del mejor caracter para encontrar el
        % segundo mejor
        ValoresCorrelacion(FMaxCorr,:) = 0;
        [F2MaxCorr, C2MaxCorr] = find(ValoresCorrelacion == max(ValoresCorrelacion(:)));
        segundoMejorValorCorrelacion = ValoresCorrelacion(F2MaxCorr,C2MaxCorr);
        
        % Si la prediccion es acertada
        if caracterReconocido == cadenaReal{1}(objeto)
            % Diferencia entre el mejor caracter,angulo 
            % MENOS segundo mejor caracter,mejor angulo
            metricaSeparabilidad(objeto) = mejorValorCorrelacion - segundoMejorValorCorrelacion;
            
            % Añadimos el indice del segundo caracter más probable
            iCaracteresParecidos(objeto) = F2MaxCorr;
            
            % Si no (fallo en prediccion)
            % Diferencia entre el real - predicho
        else
            FilaCaracterReal = strfind(Caracteres,cadenaReal{1}(objeto));
            ValorCorrelacionReal = max(ValoresCorrelacion(FilaCaracterReal,:));
            metricaSeparabilidad(objeto) = ValorCorrelacionReal - mejorValorCorrelacion; % Diferencia negativa
            
            % Añadimos el indice del segundo caracter más probable
            iCaracteresParecidos(objeto) = FMaxCorr;
        end
       
        
        % Añadimos el caracter reconocido a la cadena
        cadenaReconocida = cadenaReconocida + caracterReconocido;
        

    end
end

