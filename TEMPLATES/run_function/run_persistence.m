function run_persistence(template)
    if isfield(template,'INPUT')
        joint_file = template.INPUT;
        if isfield(template,'COVER')
            cover  = template.COVER;
            if cover>1 || cover<0
                warning('Cover parameters must be [0:1]')
                return;
            elseif cover==0
                joints = load(joint_file);
                nodes = readJoints(joints);
                nodes.synthetic = template.SYNTHETIC;
                %Persistence on overall area
                figure(1)
                fprintf('I-- Persistence over the entire window\n')
                persistance = computePersistance(nodes);
                fprintf('\n\n')
                %Persistence map
                figure(2)
                fprintf('II-- Persistence MAP\n')
                prompt = 'How many squares to run persistence MAP ?';
                squares = input(prompt);
                computePersistanceMap(nodes, squares);
            else
                joints = load(joint_file);
                nodes = readJoints(joints);
                nodes.synthetic = template.SYNTHETIC;
                %Persistence on overall area
                figure(1)
                title('I-- Persistence over the entire window')
                fprintf('I-- Persistence over the entire window\n')
                persistance = computePersistance(nodes, cover);
                fprintf('\n\n')
                %Persistence map
                figure(2)
                title('II-- Persistence MAP')
                fprintf('II-- Persistence MAP\n')
                prompt = 'How many squares to run persistence ?';
                squares = input(prompt);
                computePersistanceMap(nodes, squares);
                fprintf('\n\n')
            end
        else %no cover given
            joints = load(joint_file);
            nodes = readJoints(joints);
            prompt = 'How many squares to run persistence ?';
            squares = input(prompt);
            figure
            computePersistanceMap(nodes, squares);
        end
    else
        warning('Missing arguments : INPUT(mandatory) - COVER(optional)')
        return;
    end
end