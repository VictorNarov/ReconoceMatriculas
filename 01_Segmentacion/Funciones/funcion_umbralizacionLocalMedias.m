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
    
     
    %figure,imshow(Ib1),title("Ib filtro medias W=" + num2str(WMedia)) 
    
    
    %% 02 - Aplicar esa binarizacion en zonas de interes (alta desv tipica)
    % (para no aplicar la operacion en areas de fondo)
    
    Desviaciones = stdfilt(I, ones(WDesv));
    
    % aplicamos una umbralizacion con otsu de las dos clases
    % normalizamos las desviaciones
    Desviaciones = mat2gray(Desviaciones);
    
%     DesvMedias = imfilter(Desviaciones, Hmedia, 'symmetric');
%     Ib2 = Desviaciones < DesvMedias + 0.05;
    
    %Umbral bimodal
    UDesviaciones = graythresh(Desviaciones)-0.30; % Umbral de otsu
    
    %figure, subplot(2,1,1),imshow(Desviaciones), title("Matriz desviaciones tipicas W=" +num2str(WDesv)), subplot(2,1,2),imhist(Desviaciones),title("Histograma") 
    
    Ib2 = Desviaciones > UDesviaciones;
    
    %figure,imshow(Ib2),title("Zona de interés (alta desviación típica) Desv > "+num2str(UDesviaciones)) 
    
    % Aplicar solo en zonas de interes
    Ib = and(Ib1,Ib2);
    %Ib = Ib1;
   
%     figure, subplot(3,1,1),imshow(Ib1),title("Ib1"),
%     subplot(3,1,2),imshow(Ib2),title("Ib2"),
%     subplot(3,1,3),imshow(Ib),title("Ib:interseccion Ib1 ^ Ib2");
    % Mejora: binariazcion zonal en las desviaciones, por si hay zonas con
    % mayores diferencias de iluminacion

end

