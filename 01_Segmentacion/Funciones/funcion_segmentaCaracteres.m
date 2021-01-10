function Ietiq = funcion_segmentaCaracteres(Nombre,Numero_Objetos)

    I = imread(Nombre);

    % Nos quedamos con la componente roja de la imagen
    I = I(:,:,1);
    %I = mat2gray(I, [0 255]);
    %subplot(1,2,1),imshow(I), subplot(1,2,2), imhist(I);

    %% UMBRALIZACION GLOBAL - NO CORRIGE DEFECTOS ILUMINACION
    % Mirando su histograma bimodal, podemos binarizar segun un umbral para
    % quedarnos con la primera agrupacion del histograma, la contribucion de
    % pixeles oscuros
%     Umbral = graythresh(double(I));
%     Ib = I < Umbral*255;
    %imshow(Ib);
    
    %% TRATAMIENTO DE DEFECTOS DE ILUMINCACION -> UMBRALIZACION LOCAL
     WMedias = 155; WDesv = 75; ConstDesbalanceoClases = 35;
     Ib = funcion_umbralizacionLocalMedias(I, WMedias,WDesv, ConstDesbalanceoClases);
   
   
    
    %% Estrategia de filtrado
    % Objetos que tengan pixeles en la linea horizontal central de la imagen
    % Quedarnos con los N_objetos (parametro) mayores
    % Y descartar el objeto a la izqda (deteccion de cuadro E España matricula)

    [Ietiq, nObj] = bwlabel(Ib);

    [M,N] = size(Ib);
    Ib_lineaCentral = false(M,N);
    Ib_lineaCentral(floor(M/2), :) = true;
    %imshow(Ib_lineaCentral), title("Imagen binaria linea central horizontal");


    %% Tratammiento de cada caracter
    for iObj=1:nObj

        Iobj = Ietiq==iObj;

        % Linea central contiene al menos un pixel del objeto
        Ib_interseccion = and(Iobj, Ib_lineaCentral);
        num_pix_lineaCentral = sum(Ib_interseccion(:));

        % Si no contiene ningun pixel
        if(num_pix_lineaCentral == 0)
            Ietiq(Ietiq==iObj) = 0; %Quitamos esa deteccion
            %continue % Pasamos al siguiente caracter
        end

    end

    % Volvemos a etiquetar
    [Ietiq, nObj] = bwlabel(Ietiq);
    %imshow(Ietiq), title("Etiquetado tras eliminar objetos que no estan en fila central");

    %% Nos quedamos con los n_objetos+1 mayores
    
    % Calculamos sus areas
    areas = zeros(nObj,1);
    
    for objeto=1:nObj
        Iobj = Ietiq==objeto;
        areas(objeto) = sum(Iobj(:)); 
    end
    
    % Las ordenamos de mayor a menor, conservando sus indices
    [~, iObjMayores] = sort(areas, 'descend');

    Ib_mayores = false(size(Ietiq));
    
    for objeto=1:Numero_Objetos+1
        % Nos quedamos con el i objeto mayor
        iObjetoMayor = iObjMayores(objeto);
        Iobj = Ietiq==iObjetoMayor;
        
        Ib_mayores(Iobj) = true;
        
    end
    
    % Volvemos a etiquetar para reasignar las etiquetas
    [Ietiq] = bwlabel(Ib_mayores);
    
    % Y eliminamos la primera etiqueta de la deteccion
    % (bwlabel recorre de izqda a derecha y de arriba a abajo)
    % recorrido por columnas, primera etiqueta esta mas a la izqda
    
    Ietiq(Ietiq==1) = 0;
    
    Ietiq(Ietiq>0) = Ietiq(Ietiq>0)-1; % Etiquetas de 1:Numero_Objetos
    
    %% TODO: rellenar huecos, filtro de apertura y cierre
   
    
end

