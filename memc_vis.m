close all 
clear

data = 'data/';
files = dir(fullfile(data, '*.mat'));

for k = 1:length(files)
    filename = files(k).name;
    full_path = fullfile(data, filename);
    
    start_pos = find(filename == '_', 1, 'last');
    end_pos = find(filename == '.', 1, 'last');
    frame_num = str2num(filename(start_pos+1 : end_pos-1));
    disp(frame_num)
    load(full_path)

    % read in picture
    name = sprintf('./HD_dataset/HD720p_GT/parkrun_frames/frame%03d.png', frame_num-1);
    prev_frame = imread(name);
    name = sprintf('./HD_dataset/HD720p_GT/parkrun_frames/frame%03d.png', frame_num+1);
    next_frame = imread(name);


    % define some place you want to look at
    sy = 300 : 450;
    sx = 550 : 700;

    % optic flow vectors
    forw_motion = squeeze(motion(1,:,:,:));
    u_forward = squeeze(forw_motion(:,:,1)) * 3;
    v_forward = squeeze(forw_motion(:,:,2)) * 3;

    figure()
    overlayed = imfuse(prev_frame, next_frame, 'blend', 'Scaling','joint');
    image(sx, sy, overlayed(sy, sx, :))
    title(sprintf('Frame numnber %d', frame_num));
    % now display the vectors
    hold on;
    X = ones(length(sy), 1) * sx;
    Y = sy' * ones(1, length(sx));
    n = 10;
    quiver(X(1 : n : end, 1 : n : end), Y(1 : n : end, 1 : n : end),...
      u_forward(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)),...
      v_forward(sy(1 : n : end, 1 : n : end), sx(1 : n : end, 1 : n : end)), 0, 'r-',...
      'linewidth', 2.5);


    forw_occl = im2uint8(squeeze(occlusion(2,:,:)));

    figure()
    gray_img = overlayed(:,:,1);
    image(sx, sy, gray_img(sy, sx));
    colormap(gray(256))
    
    covered = forw_occl - 127;
    uncovered = 127 - forw_occl;
    
    rgb = cat(3, gray_img+uncovered, gray_img, gray_img+covered);
    figure()
    image(rgb(sy, sx, :));
    
    pause;
end
