close all 
clear

load test.mat

% center of kernel
x_center = 26;
y_center = 26;

% define some place you want to look at
sy = 1 : 720;
sx = 1 : 1280;

dim = size(vert1, 3, 4);
motion_back = zeros([2, dim]);
motion_forw = zeros([2, dim]);

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

        motion_back(:, y, x) = CoM_vector1;
        motion_forw(:, y, x) = CoM_vector2;

    end
end

save('motion.mat', 'motion_back', 'motion_forw')


% 
% load motion.mat


% % plot interpolated image and GT image
% % rearrange order so that channels is last
% bgr = squeeze(permute(img_interp,[1,3,4,2]));
% rgb = cat(3, bgr(:,:,3), bgr(:,:,2),bgr(:,:,1));
% figure()
% subplot(2,1,1)
% gt_img = imread('./HD_dataset/HD720p_GT/parkrun_frames/frame010.png');
% image(sx, sy, (gt_img(sy, sx, :)))
% title('GT image')
% subplot(2,1,2)
% image(sx, sy, im2uint8(rgb(sy, sx, :)));
% hold on;
% X = ones(length(sy), 1) * sx;
% Y = sy' * ones(1, length(sx));
% n = 4;
% quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
%   squeeze(motion_forw(1, sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end))),...
%   squeeze(motion_forw(2, sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end))), 0.5, 'r-',...
%   'linewidth', 2.5);
% % quiver(550, 300, 1, 6.7123e-08, 10, 'r-',...
% %   'linewidth', 2.5 )
% title('Interpolated image')