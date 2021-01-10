function Ib = funcion_umbralizacionLocalMedias(I, WMedia, WDesv, ConstDesbalanceoClases)

    % Un pixel es de letra si es mas oscuro que un umbral tomado de su vecindad

    I = double(I);
    
    % Matriz de medias de la I, convolucion
    Hmedia = (1/(WMedia*WMedia))*ones(WMedia);
    Medias = imfilter(I, Hmedia, 'symmetric');
    
    %% 01 - Binarizacion matricial con umbral de medias - constante
    % Ya que las clases del histograma están desbalanceadas
    
    UMedias = Medias - ConstDesbalanceoClases;
    Ib1 = I < UMedias;
    
    
    %% 02 - Aplicar esa binarizacion en zonas de interes (alta desv tipica)
    % (para no aplicar la operacion en areas de fondo)
    
    Desviaciones = stdfilt(I, ones(WDesv));
    
    % aplicamos una umbralizacion con otsu de las dos clases
    % normalizamos las desviaciones
    Desviaciones = mat2gray(Desviaciones);
    %Umbral bimodal
    %imhist(Desviaciones) 
    UDesviaciones = graythresh(Desviaciones); % Umbral de otsu
    Ib2 = Desviaciones > UDesviaciones;
    
    % Aplicar solo en zonas de interes
    Ib = and(Ib1, Ib2);
    
    % Mejora: binariazcion zonal en las desviaciones, por si hay zonas con
    % mayores diferencias de iluminacion

end

