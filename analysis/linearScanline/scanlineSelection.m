function [scanline] = scanlineSelection(selectNB, nodes, nbScan)
    %% Scanline-PROCESSING 
    switch selectNB
        case 0
            disp('-- Scanline AUTO --')
            scanline = find_best_scanline(nodes, nbScan); %automatic scanline selection
        case 1
            disp('-- Draw scanline extremity --')
            figure(1)
            scanline = click_endPoints(nodes);
        case 2
            disp('-- 1point/1orientation--')
            %-- Passing point selection 
            disp('Click point for scanline on plot')
            figure(1);
            clf; %clear figure window 
            hold on    
            plot_nodes(nodes);
            %% Observation window for synthetic joints
            if nodes.synthetic
                [~, window, nodes] = selectExtends(nodes, 0.1);
                xlim([window.minX,window.maxX])
                ylim([window.minY,window.maxY])
            end
            [point.x,point.y] = ginput(1);
            %-- Scanline orientation
            prompt = 'Scanline orientation (in degrees)? : ';
            theta_scanline = input(prompt);           
            theta_scanline = deg2rad(90 - theta_scanline);
            %-- Draw scanline
            scanline = user_create_scanline(point, theta_scanline, nodes);
        otherwise
            error('Accepted value : 0 - 1 - 2');
    end
end

