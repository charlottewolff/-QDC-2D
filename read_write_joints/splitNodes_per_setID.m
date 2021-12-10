function split_nodes = splitNodes_per_setID(nodes, setID)
    n=1;
    split_nodes = [];
    if isfield(nodes,'setiD')
        for j = 1:length(nodes.iD)
            if nodes.setiD{j} == setID
                split_nodes.iD{n}            = n;
                split_nodes.x{n}             = nodes.x{j};
                split_nodes.y{n}             = nodes.y{j};
                split_nodes.nseg{n}          = nodes.nseg{j};
                split_nodes.norm{n}          = nodes.norm{j};
                split_nodes.theta{n}         = nodes.theta{j};
                split_nodes.wi{n}            = nodes.wi{j};
                split_nodes.ori_w{n}         = nodes.ori_w{j};
                split_nodes.ori_mean{n}      = nodes.ori_mean{j};
                split_nodes.ori_mean_deg{n}  = nodes.ori_mean_deg{j};
                split_nodes.setiD{n}         = nodes.setiD{j};
                n = n+1;
            end
        end
    end
end
