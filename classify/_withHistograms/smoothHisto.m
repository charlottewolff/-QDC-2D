function smoothed = smoothHisto(data, windowSize) 
    smoothed = smoothdata(data,'gaussian',windowSize);
end 