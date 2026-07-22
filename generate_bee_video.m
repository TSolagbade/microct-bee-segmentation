% =========================================================================
% MICRO-CT SLICE VIDEO GENERATOR (JET 256 / MPEG-4)
% =========================================================================
% Description: Processes 1,300+ micro-CT scan slices of Apis mellifera morphology.
%              Renders intensity slices in 256-level Jet colormaps and exports
%              an accelerated MPEG-4 sequence.
% =========================================================================

clear; clc; close all;

% -------------------------------------------------------------------------
% 1. PATHS & CONFIGURATION
% -------------------------------------------------------------------------
input_folder  = 'E:\260616_BeeResin1412END [2026-06-16 14.14.57]\zmatlab_data';
output_folder = 'E:\First undried bee segmentation';
total_slices  = 1385;
step_size     = 5; % Stepping increment (processes every 5th slice to optimize time)

if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

output_video_path = fullfile(output_folder, 'raw_undried_bee_every5th_slice.mp4');

% Setup Video Writer (MPEG-4 at 15 FPS)
v = VideoWriter(output_video_path, 'MPEG-4');
v.FrameRate = 15;
v.Quality   = 90;

% Create off-screen figure window for stable rendering
fig = figure('Visible', 'off', 'Color', 'w', 'Position', [100, 100, 800, 800]);

open(v);

% Define slice indexing sequence
slice_indices = 1:step_size:total_slices;
total_frames  = length(slice_indices);

fprintf('============================================================\n');
fprintf('  STARTING MICRO-CT VIDEO RENDER (EVERY %dTH SLICE)\n', step_size);
fprintf('  Total Frames: %d\n', total_frames);
fprintf('============================================================\n');

task_tic = tic;

% -------------------------------------------------------------------------
% 2. PROCESSING & RENDERING LOOP
% -------------------------------------------------------------------------
for f = 1:total_frames
    s = slice_indices(f);
    slice_file = fullfile(input_folder, sprintf('Slice_No_%d.mat', s));
    
    if exist(slice_file, 'file')
        % Load slice data frame
        data = load(slice_file, 'Frame');
        img = double(data.Frame);
        
        % Render slice image in jet(256)
        clf(fig);
        imagesc(img);
        colormap(jet(256));
        colorbar;
        axis image; axis off;
        
        % Title overlay
        title(sprintf('Raw Undried Bee | Slice %d of %d', s, total_slices), ...
              'FontSize', 12, 'FontWeight', 'bold');
        
        drawnow;
        
        % Write captured frame to disk
        frame = getframe(fig);
        writeVideo(v, frame);
    else
        warning('Missing slice file: %s', slice_file);
    end
    
    % --- EARLY TIME PROFILER AT FRAME 3 ---
    if f == 3
        bench_time = toc(task_tic);
        avg_per_frame = bench_time / 3;
        est_total = avg_per_frame * total_frames;
        
        fprintf('\n------------------------------------------------------------\n');
        fprintf('  [PROFILER] 3 frames processed in %.2f s.\n', bench_time);
        fprintf('  [PROFILER] Projected render time: %.2f mins (%.1f s).\n', est_total/60, est_total);
        fprintf('------------------------------------------------------------\n\n');
    end
    
    % Console progress logger
    if mod(f, 50) == 0 || f == total_frames
        fprintf('  Progress: %d / %d frames written (Slice %d)...\n', f, total_frames, s);
    end
end

close(v);
close(fig);

total_time = toc(task_tic);

fprintf('\n============================================================\n');
fprintf('  SUCCESS: Generated video in %.2f minutes!\n', total_time / 60);
fprintf('  Saved to: %s\n', output_video_path);
fprintf('============================================================\n');
