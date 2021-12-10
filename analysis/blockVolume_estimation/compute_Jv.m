function Jv = compute_Jv(w)
    spacing = w(:,2);
    Jv = 0;
    for s=1:length(spacing)
        Jv = Jv + 1/spacing(s);
    end
    fprintf('The volumetric joint count : Nb of joints intersecting a volume of rock mass (Nb of joints per surface unit)\n')
    fprintf('Volumetric joint count : %f\n', Jv)
end
 
