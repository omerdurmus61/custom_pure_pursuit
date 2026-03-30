plot(xRef,yRef);
hold on;
plot(out.tracked_path_x,out.tracked_path_y,'LineWidth',0.7);
axis equal;
%%
hold on
plot(out.tracked_path_x2,out.tracked_path_y2,'LineWidth',0.7);
legend("ref","regulated pp path","pp");
axis equal;
