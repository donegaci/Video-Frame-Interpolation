close all 
clear

load test.mat

% define coordinates of interest
x = 620;
y = 339;

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

[gx, gy] = gradient(kernel1);
GtG = [sum(sum(gx.^2)), sum(sum(gx.*gy));...
       sum(sum(gx.*gy)), sum(sum(gy.^2))] / (51*51);


% calculate eigenvectors and eigen values
[e_vec1, e_val1] = eig(GtG);
[e_vec2, e_val2] = eig(kernel2);
d1 = diag(e_val1);
[d1_sort, id1] = sort(d1, 'descend');
d2 = diag(e_val2);
[d2, id2] = sort(d2, 'descend');

%plot kernels
figure()
subplot(2,1,1)
image(ker1)
% axis image
colormap(gray(256))
hold on;
contour(ker1)

% % Plot EVERY eigenvector
% for i = 1: length(e_vec1)
%     quiver(x_center, y_center, e_vec1(1,i), e_vec1(2,i), 10, 'LineWidth',3);
% end

% % Plot first two eigen vectors only
quiver(x_center, y_center, e_vec1(1,2), e_vec1(2,2),0,'k', 'LineWidth',3);
quiver(x_center, y_center, e_vec1(1,1), e_vec1(2,1),0,'r', 'LineWidth',3);
% Combine the average direction
u1 = (e_vec1(1,1)+e_vec1(1,2));
v1 = (e_vec1(2,2)+e_vec1(2,1));
quiver(x_center, y_center, u1, v1, 0, 'LineWidth',3);
% title('Kernel_1 (backward)')
subplot(2,1,2)
image(ker2)
colormap(gray(256))
hold on;

% % Plot EVERY eigenvector
% for i = 1: length(e_vec1)
%         quiver(x_center, y_center, e_vec2(1,i), e_vec2(2,i), 10, 'LineWidth',3);
% end

quiver(x_center, y_center, e_vec2(1,id2(2)), e_vec2(2,id2(1)), 10000, 'k', 'LineWidth',3);
% quiver(x_center, y_center, e_vec2(1,1), e_vec2(2,1), 10, 'r', 'LineWidth',3);
% % Combine the average direction
% u2 = (e_vec2(1,1)+e_vec2(1,2));
% v2 = (e_vec2(2,2)+e_vec2(2,1));
% quiver(x_center, y_center, u2, v2,10, 'LineWidth',3);
title('Kernel_2 (forward)')

% define some place you want to look at
% sy = y-25 : y+25;
% sx = x-25 : x+25;
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


% % Read in the previous image
% name = sprintf('./HD_dataset/HD720p_GT/parkrun_frames/frame009.png');
% prev_frame = imread(name);
% 
% % Plot the kernel over the receptive field of the previus image
% figure()
% image(sx, sy, prev_frame(sy, sx, :))
% title('Frame 9 (prev frame)')
% hold on;
% k_overlay = image(sx, sy, ker1);
% set(k_overlay, 'AlphaData', ker1)
