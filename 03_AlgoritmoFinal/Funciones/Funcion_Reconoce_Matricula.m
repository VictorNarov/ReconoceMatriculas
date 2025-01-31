function [cadenaReconocida,metricaSeparabilidad,iCaracteresParecidos] = Funcion_Reconoce_Matricula(Nombre, Numero_Objetos, cadenaReal, verbose)

    %% Obtenemos su imagen segmentada
    Ietiq = funcion_segmentaCaracteres(Nombre,Numero_Objetos);

    %% Reconocemos la cadena de caracteres de la matricula
    [cadenaReconocida, metricaSeparabilidad,iCaracteresParecidos] = funcion_ReconoceCaracteres(Ietiq, Numero_Objetos, cadenaReal);
   
    % TODO: grafico de barras distancia separabilidad 
    
    %%  Visualizamos
    if verbose
        I = imread(Nombre);
        figure, imshow(I), hold on, funcion_pintaBBCentroide(Ietiq), title(cadenaReconocida);
    end
    
end

