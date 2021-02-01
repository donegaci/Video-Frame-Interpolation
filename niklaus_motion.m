close all 
clear

load test.mat

% define some place you want to look at
sy = 300 : 450;
sx = 550 : 700;

dim = size(vert1, 3, 4);
motion_back = zeros([2, dim]);
motion_forw = zeros([2, dim]);

% for x = sx
%     for y = sy
%         % matrix multiplication vertical by horizontal
%         % transpose the vertical vector
%         kernel1 = vert1(1,:,y,x).' * hor1(1,:,y,x);
%         kernel2 = vert2(1,:,y,x).' * hor2(1,:,y,x);
% 
% %         ker1 = im2uint8(kernel1)*20;
% %         ker2 = im2uint8(kernel2)*20;
% 
% 
%         % calculate eigenvectors and eigen values
%         [e_vec1, e_val1] = eig(kernel1);
%         [e_vec2, e_val2] = eig(kernel2);
%         
%         % Combine the average direction
%         u1 = (e_vec1(1,1)+e_vec1(1,2)) / abs(e_vec1(1,1)+e_vec1(1,2));
%         v1 = (e_vec1(2,2)+e_vec1(2,1)) / abs(e_vec1(2,2)+e_vec1(2,1));
%         u2 = (e_vec2(1,1)+e_vec2(1,2)) / abs(e_vec2(1,1)+e_vec2(1,2));
%         v2 = (e_vec2(2,2)+e_vec2(2,1)) / abs(e_vec2(2,2)+e_vec2(2,1));
%         d1 = diag(e_val1);
%         [d1_sort, id1] = sort(d1, 'descend');
%         d2 = diag(e_val2);
%         [d2, id2] = sort(d2, 'descend');
% 
%         motion_back(1, x, y) = u1;
%         motion_back(2, x, y) = v1;
%         motion_forw(1, x, y) = u2;
%         motion_forw(2, x, y) = v2;
%         
%     end
% end
% 
% save('motion.mat', 'motion_back', 'motion_forw')



load motion.mat


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
X = ones(length(sy), 1) * sx;
Y = sy' * ones(1, length(sx));
n = 10;
quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
  squeeze(motion_forw(1, sx(1 : n : end, 1 : n : end), sy(1 : n : end, 1 : n : end))),...
  squeeze(motion_forw(2, sx(1 : n : end, 1 : n : end), sy(1 : n : end, 1 : n : end))), 0.5, 'r-',...
  'linewidth', 2.5);
% quiver(550, 300, 1, 6.7123e-08, 10, 'r-',...
%   'linewidth', 2.5 )
title('Interpolated image')