function Vb = compute_volume(w)
    
    NBjoints = size(w,1);
    if NBjoints == 1
        fprintf('1 jointset\n');
        Vb = 50*w(1,2)^.3;
    elseif NBjoints == 2
        fprintf('2 jointsets\n');
        Vb = 5*w(1,2).^2*w(2,2);
    elseif NBjoints == 3
        fprintf('3 jointsets\n');
        ori = sort(w(:,1));
        g1 = abs(ori(1)-ori(2));
        g2 = abs(ori(2)-ori(3));
        g3 = abs(ori(3)-ori(1));
        Vb = w(1,2)*w(2,2)*w(3,2)/(sind(g1)*sind(g2)*sind(g3));
    else
        fprintf('You should not consider more than 3 jointsets\n')
        Vb = -1;
    end

    if Vb ~= -1
       fprintf('Vb value : %f\n', Vb) 
    end
    
    spacing = sort(w(:,2));
    if length(spacing) == 3
        a3 = spacing(3)/spacing(1);
        a2 = spacing(2)/spacing(1);
    elseif length(spacing) == 2
        disp('!!!!WARNING : Plotting blockshape for only 2 joints can be wrong !!!!')
        a3 = spacing(2)/spacing(1);
        a2 = spacing(2)/spacing(1);
    else %length(spacing) == 1
        disp('!!!!WARNING : Plotting blockshape for only 1 joint is wrong !!!!')
        a3 = spacing(1)/spacing(1);
        a2 = spacing(1)/spacing(1);
    end
    B =  [a2, a3]; 
    %Block shape factor 
    Beta = (a2 + a2*a3 + a3)^3/(a2*a3)^2;
    fprintf('Alpha2: %f -- Alpha3: %f\n', B)
    fprintf('Block shape factor : %f\n', Beta)

 im = imread('img_blockShape.PNG');
 % Do the actual plotting
 figure() 
 % Define plot extent so that image can be aligned with plot
 xrng = [1 1e2];
 yrng = [1 50];
 image(xrng,yrng,im);
 ax1 = gca;
 % Get rid of pixel ticklabels
 set(ax1,'YTickLabel', [], 'XTickLabel', [])
 axes('Position',get(ax1,'Position'),'Color','none','XScale', 'log', 'YScale', 'log');
 ylim(yrng)
 xlim(xrng)
 hold on 
 loglog(a3,a2, 'r*', 'MarkerSize',12)
 title('Block types analysis with the block shape factor')
 xlabel('\alpha_{3} = largest spacing / smallest spacing')
 ylabel('\alpha_{2} = medium spacing / smallest spacing')
 
 txt = '   \leftarrow Block type';
 text(a3,a2,txt);

end 