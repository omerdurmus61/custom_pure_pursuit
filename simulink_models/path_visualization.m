plot(xRef,yRef);
hold on;
plot(out.tracked_path_x,out.tracked_path_y);
hold on
plot(out.tracked_path_x2,out.tracked_path_y2);
legend("ref","regulated pp path","pp");

