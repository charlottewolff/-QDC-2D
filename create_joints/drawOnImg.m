function nodes = drawOnImg(imgPath, outPath, scale)
    close all
    global draw
    draw = 1;
    imshow(imread(imgPath));

    c = uicontrol;
    c.String = 'Done';
    c.Callback = @stopDraw;

    hold on
    nbJoints = 0;

    %% -- Plot previous joints
    %if joints already exist, we plot them 
    if exist(outPath, 'file')
        previousJoints = load(outPath);
        %previousJoints = readmatrix(matrix);
        if size(previousJoints,1)>0
            previous_nodes = readJoints(previousJoints);
            nbJoints = max(cell2mat(previous_nodes.iD));
            
            for j=1:length(previous_nodes.iD)
                x = 1/scale*previous_nodes.x{j};
                y = 1/scale*previous_nodes.y{j};
                plot(x,y,'Color','g','LineWidth',2)
            end
        end
    end
    
    %% -- Draw j new joints
    n=1;
    jointMatrice = [];
    while draw
        hLine = drawpolyline('LineWidth',2,'Color','cyan');
        if draw == 1           
            p = scale*(hLine.Position);
            id = (nbJoints+n)*ones(size(p,1), 1);
            joints = [id,p];
            jointMatrice = [jointMatrice;joints];
            n = n+1;
        end
    end
    if exist('previousJoints')
        jointMatrice = [previousJoints; jointMatrice];
    end
    writematrix(jointMatrice,outPath);
    nodes = readJoints(jointMatrice);
    close all 
    
    
    function stopDraw(src,event)
        %global draw
        draw = 0;
        close
        disp('Drawing is done.')
    end
end