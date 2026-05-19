plot(xRef,yRef);
hold on;
plot(tracked_path_x_pp,tracked_path_y_pp,'LineWidth',0.7);
axis equal;
%%
hold on
plot(out.tracked_path_x_nn,out.tracked_path_y_nn,'LineWidth',0.7);
legend("ref","regulated pp path","NN");
axis equal;
