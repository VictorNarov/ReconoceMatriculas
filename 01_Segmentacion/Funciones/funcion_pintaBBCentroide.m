function funcion_pintaBBCentroide(Ietiq)
%% Tratammiento de cada caracter
    numObjetos = length(unique(Ietiq)) - 1;
    for objeto=1:numObjetos
        Iobj = Ietiq==objeto;
        %% Sin usar regionprops, obtenemos el BB y centroide de cada agrupacion

        [F, C] = find(Iobj==true);
        %centroide =[mean(C) mean(F)]; % X=col, Y=fila

        %% Bounding Box, fila y col max y min
        Fmin = min(F); Fmax = max(F);
        Cmin = min(C); Cmax = max(C);

        %% Centroide centro del bounding box
        centroide = [(Cmax+Cmin)/2 (Fmax+Fmin)/2];

        %% Visualizar
        line([Cmin Cmax],[Fmin Fmin]), hold on,     % bb arriba
        line([Cmin Cmax],[Fmax Fmax]), hold on,     % bb abajo
        line([Cmin Cmin],[Fmin Fmax]), hold on,     % bb izqda
        line([Cmax Cmax],[Fmin Fmax]), hold on,     % bb dcha
        plot(centroide(1), centroide(2), '+r'), hold on;

    end
end

