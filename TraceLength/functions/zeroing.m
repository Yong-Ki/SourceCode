function answer = zeroing(vector)

    NearZero = 1E-10;

    if abs(vector(1)) < NearZero
        vector(1) = 0;
    end
    if abs(vector(2)) < NearZero
        vector(2) = 0;
    end
    if abs(vector(3)) < NearZero
        vector(3) = 0;
    end
    
    vector = vector / norm(vector);
    
    answer = [vector(1), vector(2), vector(3)]; return
    