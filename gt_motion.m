close all 
clear

% data = 'parkrun_data/';
% files = dir(fullfile(data, '*.mat'));
load data/memc/parkrun/frame_0010.mat
load motion.mat
load parkrun_gt_flow_010_i_011.mat

frame_num = 10;

% read in picture
name = sprintf('./HD_dataset/HD720p_GT/parkrun_frames/frame_%03d.png', frame_num-1);
prev_frame = imread(name);
name = sprintf('./HD_dataset/HD720p_GT/parkrun_frames/frame_%03d.png', frame_num+1);
next_frame = imread(name);
name = sprintf('./HD_dataset/HD720p_GT/parkrun_frames/frame_%03d.png', frame_num);
gt_frame = imread(name);

% define some place you want to look at
sy = 330 : 355;
sx = 590 : 660;

% gt flow vectors
gt_u_forward = gt_flow(:,:,1);
gt_v_forward = gt_flow(:,:,2);

% optic flow vectors
forw_motion = squeeze(motion(2,:,:,:));
u_forward = squeeze(forw_motion(:,:,1));
v_forward = squeeze(forw_motion(:,:,2));
back_motion = squeeze(motion(1,:,:,:));
u_back = squeeze(back_motion(:,:,1));
v_back = squeeze(back_motion(:,:,2));

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
  u_forward(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)),...
  v_forward(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)), 0, 'r-',...
  'linewidth', 2.5);
quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
        squeeze(motion_forw(1, sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end))),...
        squeeze(motion_forw(2, sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end))), 0, 'b-',...
        'linewidth', 2.5)
quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
  gt_u_forward(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)),...
  gt_v_forward(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)), 0, 'g-',...
  'linewidth', 2.5);
 legend(["MEMC-NET", "Niklaus", "GT (RAFT)"])
 axis image


forw_occl = im2uint8(squeeze(occlusion(2,:,:)));

figure()
gray_img = overlayed(:,:,1);
image(sx, sy, gray_img(sy, sx));
colormap(gray(256))
axis image

covered = forw_occl - 127;
uncovered = 127 - forw_occl;

rgb = cat(3, gray_img+uncovered, gray_img, gray_img+covered);
figure()
image(rgb(sy, sx, :));
axis image

