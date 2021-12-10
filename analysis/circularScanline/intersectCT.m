function [xTC,yTC,k] = intersectCT(x_1,x_2,y_1,y_2,r,lT,xTC,yTC,k,int)
    %find all the intersection points [circles/joints]
    %x_1, x_2, y_1, y_2 : joints limits
    %xTC, yTC           : list of points of intersection with the circle 
    %k                  : nb of intersections
    %int                : sign value for the calculation 
    % see https://mathworld.wolfram.com/Circle-LineIntersection.html
    dx = [x_2-x_1];
    dy = [y_2-y_1];
    d  = sqrt(dx.^2+dy.^2);  %distance
    D  = x_1.*y_2-x_2.*y_1;  %determinant  
    x  = (D.*dy+int*sign(dy).*dx.*sqrt(r.^2*d.^2-D.^2))./d.^2;
    y  = (-D.*dx+int*abs(dy).*sqrt(r.^2.*d.^2-D.^2))./d.^2;
    %CHECK IF xTC ON THE JOINTS
    for i=1:length(lT)
        if(isreal(x(i))==1)
            %distance intersection point/middle of segment 
            d=sqrt((real(x(i))-mean([x_2(i) x_1(i)],2)).^2+(real(y(i))-mean([y_2(i) y_1(i)],2)).^2);
            if(d<0.5*lT(i)) % the intersection point is on the segment 
                xTC(k) = real(x(i));
                yTC(k) = real(y(i));
                k=k+1;
            end
        end
    end
end