function [idXY_matrice, idX1X2Y1Y2_matrice] = create_synthetic_2(wantedJoints)
    %wantedJoints = nb_joints - orientation - std_orientation - traceLength -
    %spacing
    nbJointSet = size(wantedJoints, 1);
    idX1X2Y1Y2_matrice = [];
    for set=1:nbJointSet
        %-- Joint informations
        jointInfo   = wantedJoints(set,:);
        nbJoints    = jointInfo(1);
        orientation = jointInfo(2);
        ori_std     = jointInfo(3);
        traceLength = jointInfo(4)/2; 
        spacing     = jointInfo(5);

        %-- Create joints
        aleatoire=rand(nbJoints,4);
        aleatoire(:,3)=-traceLength*log(1-aleatoire(:,3)); %length following negativ exponential law
        orientation_Vector = random('norm',orientation,ori_std,nbJoints,1);
        orientation_Vector(orientation_Vector<0)   = orientation_Vector(orientation_Vector<0) + 180;
        orientation_Vector(orientation_Vector>180) = orientation_Vector(orientation_Vector>180) - 180;
        orientation_Vector(orientation_Vector<=90) = 90 - orientation_Vector(orientation_Vector<=90);
        orientation_Vector(orientation_Vector>90)  = 270 - orientation_Vector(orientation_Vector>90);
        aleatoire(:,4)= orientation_Vector;
        X1=aleatoire(:,3).*cosd(aleatoire(:,4));
        X2=aleatoire(:,1)+X1;
        X1=aleatoire(:,1)-X1;
        Y1=aleatoire(:,3).*sind(aleatoire(:,4));
        Y2=aleatoire(:,2)+Y1;
        Y1=aleatoire(:,2)-Y1;
        
        X           = [X1, X2];
        Y           = [Y1, Y2];
        
        idX1X2Y1Y2_matrice = [idX1X2Y1Y2_matrice ; [X, Y]];
    end
    id = (1:size(idX1X2Y1Y2_matrice, 1));
    idX1X2Y1Y2_matrice = [id', idX1X2Y1Y2_matrice];
    idXY_matrice       = idx1x2y1y2_to_idxy(idX1X2Y1Y2_matrice);
    
end 
