function GtG = getGradient(kernel)
    % get gradient of kernel
    [gx, gy] = gradient(kernel);
    GtG = [sum(sum(gx.^2)), sum(sum(gx.*gy));...
           sum(sum(gx.*gy)), sum(sum(gy.^2))] / (51*51);
end
