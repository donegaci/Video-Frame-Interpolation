close all; clear

gt_path = 'data/ground_truth/parkrun/';
memc_path = 'data/memc/parkrun/';
niklaus_path = 'data/niklaus/parkrun/';
gt_files = dir(fullfile(gt_path, '*.png'));

% define some place you want to look at
sy = 320 : 450;
sx = 575 : 700;
% sy = 150 : 350;
% sx = 400 : 900;

for i = 4 : 2 : length(gt_files)
    disp(i)
    
    gt_frame = imread(sprintf('%sframe_%04d.png', gt_path,  i));
    niklaus_frame = imread(sprintf('%sframe_%04d.png', niklaus_path,  i));
    memc_frame = imread(sprintf('%sframe_%04d.png', memc_path,  i));
    gt_gray = rgb2gray(gt_frame);
    
%     % display the gt image and interpoalted images
%     figure(1)
%     subplot(3,1,1)
%     image(gt_frame)
%     axis image
%     subplot(3,1,2)
%     image(niklaus_frame)
%     axis image
%     subplot(3,1,3)
%     image(memc_frame)
%     axis image
    
    % calcualte the interpolation error
    diff_memc = rgb2gray(abs(memc_frame - gt_frame));
    diff_niklaus = rgb2gray(abs(niklaus_frame - gt_frame));
    
%     figure(2);
%     subplot(2,1,1)
%     image(diff_memc + 128);
%     colormap(gray(256));
%     title('MEMC error');
%     subplot(2,1,2)
%     image(diff_niklaus + 128);
%     colormap(gray(256));
%     title('Niklaus error');


    
%     memc_error_vis = cat(3, gt_gray + (diff_memc*2.5), gt_gray, gt_gray);
%     figure(3);
%     image(sx, sy, memc_error_vis(sy, sx, :));
%     title('MEMC error vis')
%     axis image
%     
%     niklaus_error_vis = cat(3, gt_gray, gt_gray, gt_gray + (diff_niklaus*2.5));
%     figure(4);
%     image(sx, sy, niklaus_error_vis(sy, sx, :));
%     title('Nikalus error vis')
%     axis image
%     
%     combined_error = cat(3, gt_gray, gt_gray+ (diff_memc*2.5) , gt_gray + (diff_niklaus*2.5));
%     figure(5);
%     image(sx, sy, combined_error(sy, sx, :));
%     title('Combined error vis')
%     axis image

    gt_yCbCr = rgb2ycbcr(gt_frame);
    Y = gt_yCbCr(:,:,1);
    Cb = gt_yCbCr(:,:,2);
    Cr = gt_yCbCr(:,:,3);
    
    const = repmat(128, 720, 1280);
    
    memc_error_vis = cat(3, Y, const, 128 + diff_memc);
    figure(3);
    image(sx, sy, ycbcr2rgb(memc_error_vis(sy, sx, :)));
    title('MEMC error vis')
    axis image
    
    niklaus_error_vis = cat(3, Y, 128 + diff_niklaus, const);
    figure(4);
    image(sx, sy, ycbcr2rgb(niklaus_error_vis(sy, sx, :)));
    title('Nikalus error vis')
    axis image
    
    ycbcr_error = cat(3, Y, 128 + diff_niklaus, 128 + diff_memc);
    figure(5);
    image(sx, sy, ycbcr2rgb(ycbcr_error(sy, sx, :)))
    title('Combined error vis')
    axis image     
    saveas(gcf, sprintf('temp/frame_%04d.png', i));
%     pause;
    
end
