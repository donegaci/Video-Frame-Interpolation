
close all 
clear

% frame to be inspected
name = 'adobe_720p_240fps_1';
frame = 76;

load(sprintf('data/niklaus/%s/frame_%04d.mat', name, frame))
load(sprintf('data/memc/%s/frame_%04d.mat', name, frame))

% tidy up variables
memc_motion = motion;
clear('motion', 'img_interp', 'img', 'occlusion', 'filter')

% read ground truth frames and interpolated frames
prev_frame = imread(sprintf('data/ground_truth/%s/frame_%04d.png', name, frame-1));
next_frame = imread(sprintf('data/ground_truth/%s/frame_%04d.png', name, frame+1));
gt_frame = imread(sprintf('data/ground_truth/%s/frame_%04d.png', name, frame));
niklaus_interp = imread(sprintf('data/niklaus/%s/frame_%04d.png', name, frame));
memc_interp = imread(sprintf('data/memc/%s/frame_%04d.png', name, frame));

% define coordinates of interest
x = 700;
y = 260;
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

% define some place you want to look at
sy = 240 : 340;
sx = 660 : 740;

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
legend(["Contour plot", "C of M vector", "Max Abs vector"])
title('Kernel_1 (backward)')
axis image


% kernel 2
subplot(2,1,2)
image(ker2)
colormap(gray(256))
hold on;
contour(ker2)
quiver(CoM_x2, CoM_y2, CoM_vector2(1), CoM_vector2(2), 0,'r', 'LineWidth',3)
quiver(max_abs_x2, max_abs_y2, max_abs_vector2(1), max_abs_vector2(2), 0,'b', 'LineWidth',3)
title('Kernel_2 (forward)')
axis image

% Plot the previous and next frame
figure()
subplot(1,2,1)
image(sx, sy, prev_frame(sy, sx, :))
title('Previous image')
axis image
subplot(1,2,2)
image(sx, sy, next_frame(sy, sx, :))
title('Next image')
axis image

figure()
image(sx, sy, gt_frame(sy, sx, :))
axis image
title(sprintf('Ground Truth'));
% now display the vectors
hold on;
plot(x, y, 'xr', 'Linewidth', 10)

% Plot the ground truth along with both interpolated frames
figure()
subplot(1,3,1)
image(sx, sy, gt_frame(sy, sx, :))
title('Ground truth')
axis image
subplot(1,3,2)
image(sx, sy, memc_interp(sy, sx, :))
title('MEMC interpolated image')
axis image
subplot(1,3,3)
image(sx, sy, niklaus_interp(sy, sx, :))
title('Niklaus interpolated image')
axis image

% MEMC optic flow vectors
forw_memc = squeeze(memc_motion(1,:,:,:)); % forward motion
u_memc = squeeze(forw_memc(:,:,1)); % x-component
v_memc = squeeze(forw_memc(:,:,2)); % y-component


% NIKLAUS
dim = size(vert1, 3, 4);
back_niklaus = zeros([2, dim]);
forw_niklaus = zeros([2, dim]);

for x = sx
    for y = sy
        % matrix multiplication vertical by horizontal
        % transpose the vertical vector
        kernel1 = vert1(1,:,y,x)' * hor1(1,:,y,x);
        kernel2 = vert2(1,:,y,x)' * hor2(1,:,y,x);
        

        % kernel1
        [CoM_x1, CoM_y1, CoM_vector1] = getCenterOfMass(kernel1);
        [max_abs_x1, max_abs_y1, max_abs_vector1] = getMaxAbs(kernel1);
        % kernel1
        [CoM_x2, CoM_y2, CoM_vector2] = getCenterOfMass(kernel2);
        [max_abs_x2, max_abs_y2, max_abs_vector2] = getMaxAbs(kernel2);

        back_niklaus(:, y, x) = CoM_vector1;
        forw_niklaus(:, y, x) = CoM_vector2;

    end
end


figure()
image(sx, sy, gt_frame(sy, sx, :))
axis image
title(sprintf('Ground Truth'));
% now display the vectors
hold on;
X = ones(length(sy), 1) * sx;
Y = sy' * ones(1, length(sx));
n = 10;
quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
  u_memc(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)),...
  v_memc(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)), 0, 'r-',...
  'linewidth', 2.5);
quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
        squeeze(forw_niklaus(1, sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end))),...
        squeeze(forw_niklaus(2, sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end))), 0, 'b-',...
        'linewidth', 2.5)
 legend(["MEMC-NET", "Niklaus"])