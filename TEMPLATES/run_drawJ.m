%% -- To draw joints on a given image, knowing its scale and the nb of joints to plot
clear, close

%Read wanted joints information from table 
%-----
img           = '.\TEMPLATES\examples\images_example.jpg';
scale_factor  = 10;
output_path   = 'wavelet2.txt';
%-----


nodes = drawOnImg(img, output_path, scale_factor);