function [x, y, vector] = getCenterOfMass(kernel)
    % calculate center of mass of kernel
    x_center = 26;
    y_center = 26;
    cols = 1 : size(kernel, 2); % columns
    rows = 1 : size(kernel, 1); % rows
    [X, Y] = meshgrid(cols, rows);
    mean_kernel = mean(abs(kernel(:)));
    x = mean(abs(kernel(:)) .* X(:)) / mean_kernel;
    y = mean(abs(kernel(:)) .* Y(:)) / mean_kernel;
    vector = [x y] - [x_center y_center];
end