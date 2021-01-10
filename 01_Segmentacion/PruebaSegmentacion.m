clear all, clc, close all

%% PRIMERA FASE - SEGMENTACIÓN DE CARACTERES

I = imread("Training_02.jpg");
imshow(I);

% Nos quedamos con la componente roja de la imagen
I = I(:,:,1);
I = mat2gray(I, [0 255]);
subplot(1,2,1),imshow(I), subplot(1,2,2), imhist(I);

% Mirando su histograma, podemos binarizar segun el umbral de otsu para
% quedarnos con la primera agrupacion del histograma, la contribucion de
% pixeles oscuros
Umbral = graythresh(I);
Ib = I < Umbral;
imshow(Ib);

%% Reconocer agrupaciones de pixeles conexas en la imagen y etiquetarlas
[Ietiq, numObjetos] = bwlabel(Ib);

imtool(Ietiq);

%% Tratammiento de cada caracter
for objeto=1:numObjetos
    
    Iobj = Ietiq==objeto;
    
    %% Sin usar regionprops, obtenemos el area y centroide de cada agrupacion
    %% Area, contar los pixeles detectados
    area = sum(Iobj(:)); 
    
    %% Centroide = media de la posicion de los pixeles detectados
    % en coordenadas X,Y OJO!
    [F, C] = find(Iobj==true);
    %centroide =[mean(C) mean(F)]; % X=col, Y=fila
   
    %% Bounding Box, fila y col max y min
    Fmin = min(F); Fmax = max(F);
    Cmin = min(C); Cmax = max(C);
    
    %% Centroide centro del bounding box
    centroide = [(Cmax+Cmin)/2 (Fmax+Fmin)/2];
    
    %% Visualizar
    figure, title("Objeto de Area=" + num2str(area) + " Etiqueta=" + num2str(objeto)), hold on;
    imshow(Iobj), hold on,
    line([Cmin Cmax],[Fmin Fmin]), hold on,     % bb arriba
    line([Cmin Cmax],[Fmax Fmax]), hold on,     % bb abajo
    line([Cmin Cmin],[Fmin Fmax]), hold on,     % bb izqda
    line([Cmax Cmax],[Fmin Fmax]), hold on,     % bb dcha
    plot(centroide(1), centroide(2), '+r');
    
end


%% Estrategia de filtrado
% Objetos que tengan pixeles en la linea horizontal central de la imagen
% Quedarnos con los N_objetos (parametro) mayores
% Y descartar el objeto a la izqda (deteccion de cuadro E España matricula)

for i=1:4
   
    Nombre = "Training_" + num2str(i, "%02d") + ".jpg";
    
    Ietiq = funcion_segmentaCaracteres(Nombre,6);
    
    figure, subplot(1,2,1), imshow(imread(Nombre)),title(Nombre)
    subplot(1,2,2), imshow(Ietiq), title("Segmentacion I " + Nombre), hold off;
    %imtool(Ietiq)
    
end


