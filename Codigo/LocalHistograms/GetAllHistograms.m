function all_hist = GetAllHistograms(HI, offset)

num_rows = size(HI, 1);
num_cols = size(HI, 2);
num_feats = size(HI, 3);
all_hist = zeros(num_rows * num_cols, num_feats);
cont = 1;
for row = 1:num_rows
    for col = 1:num_cols
        all_hist(cont, :) = GetHistogramAt(HI, [row,col], offset);
        cont = cont + 1;
    end
end

end