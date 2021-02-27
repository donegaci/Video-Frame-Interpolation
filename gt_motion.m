close all 
clear

% Frame to inspect
frame_num = 10;

% Load in saved motion vectors 
load (sprintf('data/memc/parkrun/frame_%04d.mat', frame_num))
load (sprintf('data/niklaus/parkrun/frame_%04d.mat', frame_num))
load (sprintf('data/ground_truth/parkrun/gt_forw_frame_%04d.mat', frame_num))

% tidy up variables
memc_motion = motion;
clear('motion', 'img_interp', 'img', 'occlusion', 'filter')

% read in picture
name = sprintf('data/ground_truth/parkrun/frame_%04d.png', frame_num-1);
prev_frame = imread(name);
name = sprintf('data/ground_truth/parkrun/frame_%04d.png', frame_num+1);
next_frame = imread(name);
name = sprintf('data/ground_truth/parkrun/frame_%04d.png', frame_num);
gt_frame = imread(name);

% define some place you want to look at
sy = 330 : 355;
sx = 590 : 660;

% gt flow vectors
gt_u_forward = gt_flow(:,:,1);
gt_v_forward = gt_flow(:,:,2);


% MEMC optic flow vectors
forw_memc = squeeze(memc_motion(2,:,:,:)); % forward motion
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
        % kernel2
        [CoM_x2, CoM_y2, CoM_vector2] = getCenterOfMass(kernel2);
        [max_abs_x2, max_abs_y2, max_abs_vector2] = getMaxAbs(kernel2);

        back_niklaus(:, y, x) = CoM_vector1;
        forw_niklaus(:, y, x) = CoM_vector2;

    end
end

figure()
% subplot(1,2,1)
image(sx, sy, prev_frame(sy, sx, :));
title(sprintf('prev frame (frame # %d)', frame_num-1))
axis image
% subplot(1,2,2)
figure()
image(sx, sy, next_frame(sy, sx, :));
title(sprintf('next frame (frame # %d)', frame_num+1))
axis image


figure()
overlayed = imfuse(prev_frame, next_frame, 'blend', 'Scaling','joint');
image(sx, sy, gt_frame(sy, sx, :))
title(sprintf('Frame number %d', frame_num));
% now display the vectors
hold on;
X = ones(length(sy), 1) * sx;
Y = sy' * ones(1, length(sx));
n = 4;
quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
  u_memc(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)),...
  v_memc(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)), 0, 'r-',...
  'linewidth', 2.5);
quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
        squeeze(forw_niklaus(1, sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end))),...
        squeeze(forw_niklaus(2, sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end))), 0, 'b-',...
        'linewidth', 2.5)
quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
  gt_u_forward(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)),...
  gt_v_forward(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)), 0, 'g-',...
  'linewidth', 2.5);
 legend(["MEMC-NET", "Niklaus", "GT (RAFT)"])
 axis image


