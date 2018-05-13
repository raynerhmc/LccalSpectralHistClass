    %retorna solo el filtro de sobel normalizado en la direction x 
function A = getSobelFilter(direction)
if direction == 'x'
    A = [-1 0 1; -2 0 2; -1 0 1]; % x direction
elseif direction == 'y'
    A = [1 2 1; 0 0 0 ; -1 -2 -1]; % y direction
end