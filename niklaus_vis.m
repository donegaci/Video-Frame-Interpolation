close all 
clear

% Frame to inspect
file = 'sintel_alley2';
frame_num = 42;

load (sprintf('data/ground_truth/%s/gt_forw_frame_%04d.mat', file, frame_num))
load (sprintf('data/ground_truth/%s/gt_back_frame_%04d.mat', file, frame_num))
load(sprintf('data/niklaus/%s/frame_%04d.mat', file, frame_num))

niklaus_interp = imread(sprintf('data/niklaus/%s/frame_%04d.png', file, frame_num));
gt_frame = imread(sprintf('data/ground_truth/%s/frame_%04d.png', file, frame_num));


% define coordinates of interest
x = 21;
y = 380;
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
quiver(x_center, y_center, CoM_vector1(1), CoM_vector1(2), 0,'r', 'LineWidth',3)
quiver(x_center, y_center, max_abs_vector1(1), max_abs_vector1(2), 0,'b', 'LineWidth',3)
quiver(x_center, y_center, gt_flow_back(y, x, 1), gt_flow_back(y, x, 2), 0, 'g', 'LineWidth', 3)
legend(["Contour plot", "C of M vector", "Max Abs vector"])
title('Kernel_1 (backward)')
axis image


% kernel 2
subplot(2,1,2)
image(ker2)
colormap(gray(256))
hold on;
contour(ker2)
quiver(x_center, y_center, CoM_vector2(1), CoM_vector2(2), 0,'r', 'LineWidth',3)
quiver(x_center, y_center, max_abs_vector2(1), max_abs_vector2(2), 0,'b', 'LineWidth',3)
quiver(x_center, y_center, gt_flow(y, x, 1), gt_flow(y, x, 2), 0, 'g', 'LineWidth', 3)
title('Kernel_2 (forward)')
axis image


% define some place you want to look at
sy = 300 : 420;
sx = 1 : 60;

% plot interpolated image and GT image
figure()
subplot(1,2,1)
image(sx, sy, (gt_frame(sy, sx, :)))
title('GT image')
axis image
subplot(1,2,2)
image(sx, sy, niklaus_interp(sy, sx, :));
hold on;
plot(x, y, 'xr', 'Linewidth', 10)
title('Interpolated image')
axis image

error = double(gt_frame(:,:,2)) - double(niklaus_interp(:,:,2));
figure()
image(128 + error)
colormap(gray(256))
title('Interpolated image')
axis image