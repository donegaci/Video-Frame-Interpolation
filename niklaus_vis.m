close all 
clear

load test.mat

% define coordinates of interest
x = 592;
y = 441;
% center of kernel
x_center = 26;
y_center = 26;

% matrix multiplication vertical by horizontal
% transpose the vertical vector
kernel1 = vert1(1,:,y,x)' * hor1(1,:,y,x);
kernel2 = vert2(1,:,y,x)' * hor2(1,:,y,x);
s = 100 / max(max(abs([kernel1 kernel2])));
ker1 = kernel1 * s + 128;
ker2 = kernel2 * s + 128;


% kernel1
[CoM_x1, CoM_y1, CoM_vector1] = getCenterOfMass(kernel1);
[max_abs_x1, max_abs_y1, max_abs_vector1] = getMaxAbs(kernel1);
% kernel1
[CoM_x2, CoM_y2, CoM_vector2] = getCenterOfMass(kernel2);
[max_abs_x2, max_abs_y2, max_abs_vector2] = getMaxAbs(kernel2);


% plot kernels
% kernel 1
figure()
subplot(2,1,1)
image(ker1)
colormap(gray(256))
hold on;
contour(ker1)
quiver(CoM_x1, CoM_y1, CoM_vector1(1), CoM_vector1(2), 0,'r', 'LineWidth',3)
quiver(max_abs_x1, max_abs_y1, max_abs_vector1(1), max_abs_vector1(2), 0,'b', 'LineWidth',3)
title('Kernel_1 (backward)')

% kernel 2
subplot(2,1,2)
image(ker2)
colormap(gray(256))
hold on;
contour(ker2)
quiver(CoM_x2, CoM_y2, CoM_vector2(1), CoM_vector2(2), 0,'r', 'LineWidth',3)
quiver(max_abs_x2, max_abs_y2, max_abs_vector2(1), max_abs_vector2(2), 0,'b', 'LineWidth',3)
% title('Kernel_2 (forward)')


% define some place you want to look at
sy = 300 : 450;
sx = 550 : 700;

% plot interpolated image and GT image
% rearrange order so that channels is last
bgr = squeeze(permute(img_interp,[1,3,4,2]));
rgb = cat(3, bgr(:,:,3), bgr(:,:,2),bgr(:,:,1));
figure()
subplot(2,1,1)
gt_img = imread('./HD_dataset/HD720p_GT/parkrun_frames/frame010.png');
image(sx, sy, (gt_img(sy, sx, :)))
title('GT image')
subplot(2,1,2)
image(sx, sy, im2uint8(rgb(sy, sx, :)));
hold on;
plot(x, y, 'xr', 'Linewidth', 10)
title('Interpolated image')



% get gradient of kernel
function GtG = getGradient(kernel)
    [gx, gy] = gradient(kernel);
    GtG = [sum(sum(gx.^2)), sum(sum(gx.*gy));...
           sum(sum(gx.*gy)), sum(sum(gy.^2))] / (51*51);
end


% calculate center of mass of kernel
function [x, y, vector] = getCenterOfMass(kernel)
    x_center = 26;
    y_center = 26;
    cols = 1 : size(kernel, 2); % columns
    rows = 1 : size(kernel, 1); % rows
    [X, Y] = meshgrid(cols, rows);
    mean_kernel = mean(kernel(:));
    x = mean(kernel(:) .* X(:)) / mean_kernel;
    y = mean(kernel(:) .* Y(:)) / mean_kernel;
    vector = [x_center y_center]-[x y];
end


% calculate the max absoloute value of kernel
function [x, y, vector] = getMaxAbs(kernel)
    x_center = 26;
    y_center = 26;
    max_val = max(max(abs(kernel)));
    [y, x] = find(kernel==max_val);
    vector = [x_center y_center]-[x y];
end