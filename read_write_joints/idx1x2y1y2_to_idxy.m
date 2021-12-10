function idxy = idx1x2y1y2_to_idxy(idXXYY_matrice)
    idxy = NaN(2*size(idXXYY_matrice, 1), 3);
    for line=1:size(idXXYY_matrice, 1)
        joint_extremity1 = [idXXYY_matrice(line,1), idXXYY_matrice(line,2), idXXYY_matrice(line,4)];
        joint_extremity2 = [idXXYY_matrice(line,1), idXXYY_matrice(line,3), idXXYY_matrice(line,5)];
        idxy(2*line-1,:) = joint_extremity1;
        idxy(2*line, :)  = joint_extremity2;
    end
end 