function cadenaReconocida = Funcion_Reconoce_Matricula(Nombre, Numero_Objetos)

    %% Obtenemos su imagen segmentada
    Ietiq = funcion_segmentaCaracteres(Nombre,Numero_Objetos);

    %% Reconocemos la cadena de caracteres de la matricula
    cadenaReconocida = funcion_ReconoceCaracteres(Ietiq, Numero_Objetos);
    
    %%  Visualizamos
    I = imread(Nombre);
    figure, imshow(I), hold on, funcion_pintaBBCentroide(Ietiq), title(cadenaReconocida);
    
end

