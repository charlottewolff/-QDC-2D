function [idXY_matrice, idX1X2Y1Y2_matrice] = create_synthetic(wantedJoints)
    %wantedJoints = nb_joints - orientation - std_orientation - traceLength -
    %spacing
    nbJointSet = size(wantedJoints, 1);
    figure()
    hold on
    idX1X2Y1Y2_matrice = [];
    for set=1:nbJointSet
        %-- Joint informations
        jointInfo   = wantedJoints(set,:);
        nbJoints    = jointInfo(1);
        orientation = jointInfo(2);
        ori_std     = jointInfo(3);
        traceLength = jointInfo(4);
        spacing     = jointInfo(5);

        %-- Create joints
        orientation_Vector = random('norm',orientation,ori_std,nbJoints,1);
        orientation_Vector(orientation_Vector<0)   = orientation_Vector(orientation_Vector<0) + 180;
        orientation_Vector(orientation_Vector>180) = orientation_Vector(orientation_Vector>180) - 180;
        orientation_Vector(orientation_Vector<=90) = 90 - orientation_Vector(orientation_Vector<=90);
        orientation_Vector(orientation_Vector>90)  = 270 - orientation_Vector(orientation_Vector>90);

        traceLength = 10*rand(nbJoints, 1);
        X           = zeros(nbJoints, 2);
        Y           = zeros(nbJoints, 2);
        X(:,2)      = cosd(orientation_Vector).*traceLength;
        Y(:,2)      = sind(orientation_Vector).*traceLength;
        %-- Translate joints to position
        shift       = 5* rand(nbJoints, 2);
        X           = X + shift(:,1);
        Y           = Y + shift(:,2);
        p           = plot(X.', Y.', 'b');
        idX1X2Y1Y2_matrice      = [idX1X2Y1Y2_matrice ; [X, Y]];
    end
    id = (1:size(idX1X2Y1Y2_matrice, 1));
    idX1X2Y1Y2_matrice = [id', idX1X2Y1Y2_matrice];
    idXY_matrice       = idx1x2y1y2_to_idxy(idX1X2Y1Y2_matrice);
    
    hold off 
    
end 