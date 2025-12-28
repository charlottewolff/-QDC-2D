function result = circleAnalysis(x1, x2, y1, y2, R, poly_id)
% SEGMENTS_IN_CIRCLE analyse les intersections de segments avec un cercle centré en (0,0)
%
% Entrées :
%   x1, y1 : coordonnées des débuts de segments (vecteurs)
%   x2, y2 : coordonnées des fins de segments (vecteurs)
%   R      : rayon du cercle
%   poly_id: identifiant du polyligne auquel chaque segment appartient
%
% Sorties (dans la structure "result") :
%   result.intersections     = [xi, yi] des points d'intersection avec le cercle
%   result.inside_points     = [x, y] des extrémités de segments situées dans le cercle
%   result.lengths_inside    = vecteur des longueurs de chaque segment à l'intérieur du cercle
%   result.n_intersections   = nombre total de points d'intersection
%   result.n_inside_points   = nombre total de points d'extrémité dans le cercle
%   result.total_length      = somme des longueurs à l’intérieur du cercle
%   result.n_polylines_inside = nombre de polylignes distincts touchant le cercle

% ---- Initialisation ----
n = numel(x1);
intersections = [];
inside_points = [];
lengths_inside = zeros(n,1);

% Track polylines touching circle 
maxID = max(poly_id);
poly_hits = false(maxID,1);   % poly_hits(i) = true if polyline i touches circle

for i = 1:n
    xA = x1(i);  yA = y1(i);
    xB = x2(i);  yB = y2(i);
    dx = xB - xA;
    dy = yB - yA;

    % Équation paramétrique : P(t) = A + t*(B - A), t ∈ [0,1]
    % On cherche les t tels que |P(t)|^2 = R^2
    a = dx^2 + dy^2;
    b = 2*(xA*dx + yA*dy);
    c = xA^2 + yA^2 - R^2;

    % Résolution quadratique
    delta = b^2 - 4*a*c;
    t_values = [];

    if delta >= 0
        t1 = (-b - sqrt(delta)) / (2*a);
        t2 = (-b + sqrt(delta)) / (2*a);
        t_values = [t1, t2];
    end

    % Garde uniquement les intersections dans [0,1]
    t_valid = t_values(t_values >= 0 & t_values <= 1);

    % Points d'intersection valides
    for t = t_valid
        xi = xA + t*dx;
        yi = yA + t*dy;
        intersections = [intersections; xi, yi];
    end

    % Points à l’intérieur du cercle
    distA = hypot(xA, yA);
    distB = hypot(xB, yB);
    inside = [];
    if distA <= R, inside = [inside; xA, yA]; end
    if distB <= R, inside = [inside; xB, yB]; end
    inside_points = [inside_points; inside];

    % Calcul de la longueur du segment dans le cercle
    pts = [];
    if distA <= R, pts = [pts; xA, yA]; end
    if distB <= R, pts = [pts; xB, yB]; end
    if numel(t_valid) > 0
        for t = t_valid
            pts = [pts; xA + t*dx, yA + t*dy];
        end
    end

    % Garder uniquement les points à l’intérieur
    in_mask = vecnorm(pts, 2, 2) <= R + 1e-10;
    pts_in = pts(in_mask, :);

    if size(pts_in,1) >= 2
        % Longueur du segment dans le cercle = distance max entre les points internes
        D = pdist(pts_in);
        lengths_inside(i) = max(D);
    else
        lengths_inside(i) = 0;
    end
	
	% Mark polyline if ANY interaction happens ----
    if (~isempty(t_valid)) || distA <= R || distB <= R
        poly_hits(poly_id(i)) = true;
    end
end

% ---- Résultats ----
result.intersections   = intersections;
result.inside_points   = inside_points;
result.lengths_inside  = lengths_inside;
result.n_intersections = size(intersections,1);
result.n_inside_points = size(inside_points,1);
result.total_length    = sum(lengths_inside);
result.n_polylines_inside   = sum(poly_hits);
end






% function RST = segments_in_circle_fast(x1, x2, y1, y2, R)
% % Version vectorisée : analyse segments ↔ cercle (0,0,R)
% 
% % ---- Préparation ----
% dx = x2 - x1; 
% dy = y2 - y1;
% a  = dx.^2 + dy.^2;
% b  = 2*(x1.*dx + y1.*dy);
% c  = x1.^2 + y1.^2 - R^2;
% delta = b.^2 - 4*a.*c;
% 
% % ---- Intersections ----
% t1 = (-b - sqrt(max(delta,0))) ./ (2*a);
% t2 = (-b + sqrt(max(delta,0))) ./ (2*a);
% 
% % On ne garde que les t dans [0,1]
% valid1 = (delta >= 0) & (t1 >= 0) & (t1 <= 1);
% valid2 = (delta >= 0) & (t2 >= 0) & (t2 <= 1);
% 
% xi = [x1(valid1) + t1(valid1).*dx(valid1); x1(valid2) + t2(valid2).*dx(valid2)];
% yi = [y1(valid1) + t1(valid1).*dy(valid1); y1(valid2) + t2(valid2).*dy(valid2)];
% 
% % ---- Points internes ----
% insideA = (x1.^2 + y1.^2) <= R^2;
% insideB = (x2.^2 + y2.^2) <= R^2;
% xin = [x1(insideA); x2(insideB)];
% yin = [y1(insideA); y2(insideB)];
% 
% % ---- Longueurs à l’intérieur ----
% % On récupère les points pertinents pour chaque segment
% ptsA = [x1, y1];
% ptsB = [x2, y2];
% inside_len = zeros(size(x1));
% 
% for i = 1:numel(x1)
%     pts = [ptsA(i,:); ptsB(i,:)];
%     if valid1(i), pts = [pts; x1(i)+t1(i)*dx(i), y1(i)+t1(i)*dy(i)]; end
%     if valid2(i), pts = [pts; x1(i)+t2(i)*dx(i), y1(i)+t2(i)*dy(i)]; end
%     inmask = sum(pts.^2,2) <= R^2+1e-12;
%     pts = pts(inmask,:);
%     if size(pts,1)>=2
%         inside_len(i) = max(pdist(pts));
%     end
% end
% 
% % ---- Résumé ----
% RST.intersections   = [xi, yi];
% RST.inside_points   = [xin, yin];
% RST.lengths_inside  = inside_len;
% RST.n_intersections = numel(xi);
% RST.n_inside_points = numel(xin);
% RST.total_length    = sum(inside_len);
% end
