function log=laplacian_of_gaussian(sigma)
step = 1;
f_height =  fix((8 * sigma) / step);
f_width = fix((8 * sigma) / step);

if mod(f_height, 2) == 0  
    f_height = f_height + 1;
end
if mod(f_width , 2 ) == 0
    f_width = f_width + 1;
end
hh = (f_height - 1) /2 ;
ww = (f_width -1 ) / 2 ;

[X,Y] = meshgrid(-ww:step:ww, -hh:step:hh);

exp_gauss =  ( (X .^ 2) + (Y .^ 2) ) / (2 * (sigma ^ 2 ) );
log = - (1 / (pi * (sigma ^ 4) ) ) * ( 1 - exp_gauss ) .* exp( -exp_gauss) ;


%plot3(X, Y, log);
