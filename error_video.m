close all; clear

name = 'sintel_alley2';

gt_path = sprintf('data/ground_truth/%s/', name);
memc_path = sprintf('data/memc/%s/', name);
niklaus_path = sprintf('data/niklaus/%s/', name);
gt_files = dir(fullfile(gt_path, '*.png'));

% define some place you want to look at
sy = 1 : 544;
sx = 1 : 1280;
% sy = 200 : 500; %sintel alley person
% sx = 300 : 450;
% sy = 1 : 500; %sintel alley door
% sx = 1 : 100;
% sy = 320 : 460; %parkrun
% sx = 550 : 675;

for i = 42 : 2 : length(gt_files)
    disp(i)
    
    gt_frame = imread(sprintf('%sframe_%04d.png', gt_path,  i));
    niklaus_frame = imread(sprintf('%sframe_%04d.png', niklaus_path,  i));
    memc_frame = imread(sprintf('%sframe_%04d.png', memc_path,  i));
    gt_gray = rgb2gray(gt_frame);
    
    % display the gt image and interpoalted images
    figure(1)
    subplot(1,3,1)
    image(sx, sy, gt_frame(sy, sx, :))
    title('GT frame')
    axis image
    subplot(1,3,2)
    image(sx, sy, niklaus_frame(sy, sx, :))
    title('Niklaus frame')
    axis image
    subplot(1,3,3)
    image(sx, sy, memc_frame(sy, sx, :))
    title('MEMC frame')
    axis image
    
    % calcualte the interpolation error. Get the absoloute value because
    % I don't want to visualise negative error.
    error_memc = abs(double(memc_frame(:,:,2)) - double(gt_frame(:,:,2)));
    error_niklaus = abs(double(niklaus_frame(:,:,2)) - double(gt_frame(:,:,2)));

    gt_yCbCr = rgb2ycbcr(gt_frame);
    Y = gt_yCbCr(:,:,1);
    Cb = gt_yCbCr(:,:,2);
    Cr = gt_yCbCr(:,:,3);
    
    % constant image of vale 128 (gray)
    const = repmat(128, 544, 1280);
%     const = repmat(128, 720, 1280);
    
    memc_error_vis = cat(3, Y, const, 128 + error_memc);
    figure(4);
    image(sx, sy, ycbcr2rgb(memc_error_vis(sy, sx, :)));
    title('MEMC error vis')
    axis image
    
    niklaus_error_vis = cat(3, Y, 128 + error_niklaus, const);
    figure(5);
    image(sx, sy, ycbcr2rgb(niklaus_error_vis(sy, sx, :)));
    title('Nikalus error vis')
    axis image
    
    ycbcr_error = cat(3, Y, 128 + error_niklaus, 128 + error_memc);
    figure(6);
    image(sx, sy, ycbcr2rgb(ycbcr_error(sy, sx, :)))
    title('Combined error vis')
    axis image     
%     saveas(gcf, sprintf('temp/frame_%04d.png', i));
    pause;
    
end
