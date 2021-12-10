function orientations = mean_orientation(nodes)
    ori_vect = (cell2mat(nodes.ori_mean_deg));
    orientations.MEAN = mean(ori_vect);
    orientations.STD  = std(ori_vect);
    orientations.MIN = min(ori_vect);
    orientations.MAX = max(ori_vect); 

    %add complementary values
    ori_vect_all = [ori_vect; ori_vect+180];
    ori_vect_perp = ori_vect_all(ori_vect_all>90);
    ori_vect_perp = ori_vect_perp(ori_vect_perp<270);
    MEAN_perp = mean(ori_vect_perp);
    STD_perp  = std(ori_vect_perp);

    if STD_perp<orientations.STD/5 %ori close to 0 or 180
        orientations.MEAN = MEAN_perp;
        orientations.STD  = STD_perp;   
        orientations.MIN = min(ori_vect_perp);
        orientations.MAX = max(ori_vect_perp);        
    end
end