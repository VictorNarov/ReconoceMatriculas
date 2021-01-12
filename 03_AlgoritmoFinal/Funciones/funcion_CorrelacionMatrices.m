function ValorCorrelacion = funcion_CorrelacionMatrices (Matriz1, Matriz2)
    
    Matriz1 = double(Matriz1); Matriz2=double(Matriz2);
    

    media1 = mean(Matriz1(:));
    media2 = mean(Matriz2(:));
    
    % Numerador
    num = (Matriz1 - media1) .* (Matriz2 - media2);
    num = sum(num(:));
    
    % Denominador
    t1 = (Matriz1 - media1).^2; t1 = sum(t1(:));
    t2 = (Matriz2 - media2).^2; t2 = sum(t2(:));
    
    den = sqrt( t1 .* t2);
    
    ValorCorrelacion = num ./ den;

end

