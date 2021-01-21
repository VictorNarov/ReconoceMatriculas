clear all, clc, close all, addpath(genpath(pwd))

%% PRIMERA FASE - SEGMENTACIÓN DE CARACTERES
% UMBRALIZACION: GLOBAL VS LOCAL

% UMBRALIZACION GLOBAL: OTSU
Ib_global = {};
figure
tic
for i=1:5
    titulo = "Training_0" + num2str(i,'%0d') + ".jpg";
    I = imread(titulo);

    % Nos quedamos con la componente roja de la imagen
    I = I(:,:,1);
    I = mat2gray(I, [0 255]);
    %figure,subplot(1,2,1),imshow(I),title(titulo + " escala de grises Componente R"), subplot(1,2,2), imhist(I),title("Histograma");

    % Mirando su histograma, podemos binarizar segun el umbral de otsu para
    % quedarnos con la primera agrupacion del histograma, la contribucion de
    % pixeles oscuros
    Umbral = graythresh(I) - 25/255;
    Ib_global{i} = I < Umbral;
     
    % Queremos contar cuantos objetos se detectan
    [~, N] = bwlabel(Ib_global{i});
    
    % Representamos
    subplot(5,1,i),imshow(Ib_global{i}),title("Imagen binaria " + num2str(i)+" umbralización global de Otsu T=" + num2str(Umbral*255) + " Objetos=" +num2str(N));   
end
toc

% UMBRALIZACION GLOBAL: EXTRACCION DE FONDO
Ib_global2 = {};
figure
tic
for i=1:5
    titulo = "Training_0" + num2str(i,'%0d') + ".jpg";
    I = imread(titulo);

    % Nos quedamos con la componente roja de la imagen
    I = I(:,:,1);
    I = mat2gray(I, [0 255]);
    %figure,subplot(1,2,1),imshow(I),title(titulo + " escala de grises Componente R"), subplot(1,2,2), imhist(I),title("Histograma");

    % Mirando su histograma, podemos binarizar segun el umbral de otsu para
    % quedarnos con la primera agrupacion del histograma, la contribucion de
    % pixeles oscuros

    Ib_global2{i} = funcion_umbralizacionGlobalExtraccionFondo(I,9, 65);
     
    % Queremos contar cuantos objetos se detectan
    [~, N] = bwlabel(Ib_global2{i});
    
    % Representamos
    subplot(5,1,i),imshow(Ib_global2{i}),title("Imagen binaria " + num2str(i)+" umbralización global post extraccion fondo" + " Objetos=" +num2str(N));   
end
toc

% UMBRALIZACION LOCAL: MEDIAS + DESV. TIPICA
Ib_local = {};
figure
tic
for i=1:5
    titulo = "Training_0" + num2str(i,'%0d') + ".jpg";
    I = imread(titulo);

    % Nos quedamos con la componente roja de la imagen
    I = I(:,:,1);
    %figure,subplot(1,2,1),imshow(I),title(titulo + " escala de grises Componente R"), subplot(1,2,2), imhist(I),title("Histograma");

    % Mirando su histograma, podemos binarizar segun el umbral de otsu para
    % quedarnos con la primera agrupacion del histograma, la contribucion de
    % pixeles oscuros
    
    % Excoger ventana de media tal que sea suficientemente grande para que
    % haya pixeles de fondo y de matricula (imtool), puede ser el mismo
    % para las desviaciones tipicas
    WMedias = 70; WDesv = 65; ConstDesbalanceoClases = 10;
    Ib_local{i} = funcion_umbralizacionLocalMedias(I, WMedias,WDesv, ConstDesbalanceoClases);
    
    % Queremos contar cuantos objetos se detectan
    [~, N] = bwlabel(Ib_local{i});
    
    % Representamos
    subplot(5,1,i),imshow(Ib_local{i}),title("Imagen binaria " + num2str(i)+" umbralización local WMedias=" + num2str(WMedias) +" WDesv="+num2str(WDesv)+ " Objetos=" +num2str(N));  
end
toc


%% Reconocer agrupaciones de pixeles conexas en la imagen y etiquetarlas
Ib = Ib_local{3};
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
%     figure, title("Objeto de Area=" + num2str(area) + " Etiqueta=" + num2str(objeto)), hold on;
%     imshow(Iobj), hold on,
%     line([Cmin Cmax],[Fmin Fmin]), hold on,     % bb arriba
%     line([Cmin Cmax],[Fmax Fmax]), hold on,     % bb abajo
%     line([Cmin Cmin],[Fmin Fmax]), hold on,     % bb izqda
%     line([Cmax Cmax],[Fmin Fmax]), hold on,     % bb dcha
%     plot(centroide(1), centroide(2), '+r');
    
end


%% Estrategia de filtrado
% Objetos que tengan pixeles en la linea horizontal central de la imagen
% Quedarnos con los N_objetos (parametro) mayores
% Y descartar el objeto a la izqda (deteccion de cuadro E España matricula)


%% Prueba de segmentacion con todas las imagenes
clear all, clc,close all, addpath(genpath(pwd))

tic
nCaracteresTrain = [7 7 6 7];
nCaracteresTest = [7 6 7 7 7 7 7 6 6 6 7 7 7 7 7 7 7 7 7 6];

for i=1:length(nCaracteresTest)
   
    Nombre = "Test_" + num2str(i, "%02d") + ".jpg";
    
    Ietiq = funcion_segmentaCaracteres(Nombre,nCaracteresTest(i));
    
    figure, subplot(1,2,1), imshow(imread(Nombre)),title(Nombre)
    subplot(1,2,2), imshow(Ietiq), hold on, funcion_pintaBBCentroide(Ietiq), title("Segmentacion I " + Nombre), hold off;
    %imtool(Ietiq)
    
end
toc


