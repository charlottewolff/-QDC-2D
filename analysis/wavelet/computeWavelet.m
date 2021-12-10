
function computeWavelet(scanline)
    for scan=1:length(scanline.iD)

        X_trans = scanline.X_trans{scan};
        dist = sqrt((scanline.maxX{scan}-scanline.minX{scan}).^2 + (scanline.maxY{scan}-scanline.minY{scan}).^2);
        s = (0:dist/100:dist);
        
        index = NaN(length(X_trans),1);
        for i=1:length(X_trans)
            d = dist;
            for j=1:length(s)
                if abs(X_trans(i)-s(j))<d
                    d = abs(X_trans(i)-s(j));
                    index(i) = j;
                end
            end
        end
        
        
        wave= zeros(length(s), 1);
        wave(index) = 10;
        
        %% -- Plot wavelet analysis
        figure()
        % Scanline plot
        subplot(211); 
        hold on
        yline(1,'-','Scanline')
        xlim([0 length(wave)]);
        ylim([0.5 1.5]);
        plot(index,ones(1, length(index)),'rx') ; 
        
        %Wavelet analysis
        subplot(212);
        mtlb = wave;
        Fs = 1;
        tms = (0:numel(mtlb)-1)/Fs;
        [cfs,frq] = cwt(mtlb,Fs);
        surface(tms,frq,abs(cfs))
        axis tight
        shading flat       
        xlabel('Position on scanline')
        ylabel('Scale')
        if scanline.iD{scan}==0 %Main scanline
            title('Main scanline')
        else
            title_string = 'dX :' + string(scanline.dX{scan}) + ' - dY: ' + string(scanline.dY{scan});
            title(title_string);
        end
    end
  
end