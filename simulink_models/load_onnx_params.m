load("scaler_params.mat")

x_mean = x_mean(:);
x_std  = x_std(:);
y_mean = y_mean(:);
y_std  = y_std(:);

%%
tracked_path_x_nn = out.tracked_path_x_nn;
tracked_path_y_nn = out.tracked_path_y_nn;
tracked_path_nn = out.tracked_path_nn;
%%
tracked_path_pp = out.tracked_path;
tracked_path_x_pp = out.tracked_path_x;
tracked_path_y_pp = out.tracked_path_y;