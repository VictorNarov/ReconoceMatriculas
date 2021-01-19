function [cadenaReconocida,metricaSeparabilidad,cadenaMasParecida] = Funcion_Reconoce_Matricula(Nombre, Numero_Objetos, verbose)

    %% Obtenemos su imagen segmentada
    Ietiq = funcion_segmentaCaracteres(Nombre,Numero_Objetos);

    %% Reconocemos la cadena de caracteres de la matricula
    [cadenaReconocida, metricaSeparabilidad,cadenaMasParecida] = funcion_ReconoceCaracteres(Ietiq, Numero_Objetos);
   
    % TODO: grafico de barras distancia separabilidad 
    
    %%  Visualizamos
    if verbose
        I = imread(Nombre);
        figure, imshow(I), hold on, funcion_pintaBBCentroide(Ietiq), title(cadenaReconocida);
    end
    
end

