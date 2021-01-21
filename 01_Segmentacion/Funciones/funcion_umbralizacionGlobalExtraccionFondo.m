function Ib = funcion_umbralizacionGlobalExtraccionFondo(I,WMediana, WMedia)
    
    
    Ifil = medfilt2(I,[WMediana WMediana], 'symmetric');
    %figure,imshow(Ifil)
    
    Ifil = double(Ifil);
    
    H = (1/(WMedia*WMedia)) * ones(WMedia);
    Ifondo = imfilter(Ifil,H,'symmetric');
    
    %figure,imshow(Ifondo)
    
    Icorr = uint8(255*mat2gray(Ifil-Ifondo));
    
    %figure,imshow(Icorr)
    
    %figure,imhist(Icorr)
    
    Umbral = graythresh(Icorr)*255;
    Ib = Icorr < Umbral;
    
    %figure, imshow(Ib)
    
    

end

