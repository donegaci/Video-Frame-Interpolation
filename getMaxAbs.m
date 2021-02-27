function [x, y, vector] = getMaxAbs(kernel)
    % calculate the max absoloute value of kernel
    x_center = 26;
    y_center = 26;
    max_val = max(max(abs(kernel)));
    [y, x] = find(abs(kernel)==max_val);
    vector = [x y] - [x_center y_center];
end