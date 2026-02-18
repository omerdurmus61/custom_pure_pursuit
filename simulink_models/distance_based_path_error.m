raw_referance_path = data.ActorSpecifications.Waypoints;
referance_path = raw_referance_path(:,1:2);

tracked_path = out.tracked_path;
distance_sp  = [];
error_indv_point = [];
total_distance_error = [];

kernel_size = 3;

for i = 1:length(tracked_path)

    for j = 1:length(referance_path)
        
        delta_x = referance_path(j,1) - tracked_path(i,1);
        delta_y = referance_path(j,2) - tracked_path(i,2);
        distance = sqrt(delta_x^2 + delta_y^2);
        distance_sp(end+1) = distance;

    end
        [~,starting_index] = min(distance_sp);
        distance_sp = [];
     
        if(starting_index<=kernel_size)
            for offset = 1:(starting_index + kernel_size)
                A = referance_path(offset,:);
                B = referance_path(offset+1,:);
                X = tracked_path(i,:);
                AB = B - A;
                AX = X - A;
    
                t = dot(AX, AB) / dot(AB, AB);
                t = max(0, min(1, t)); 
    
                T = A + t * AB; 
                e = norm(X - T);
                error_indv_point(end+1) = e;                              
            end        
        elseif(length(referance_path) - starting_index <= kernel_size)
            for offset = (starting_index - kernel_size):(length(referance_path)-1)
                A = referance_path(offset,:);
                B = referance_path(offset+1,:);
                X = tracked_path(i,:);
                AB = B - A;
                AX = X - A;
    
                t = dot(AX, AB) / dot(AB, AB);
                t = max(0, min(1, t)); 
    
                T = A + t * AB; 
                e = norm(X - T);
                error_indv_point(end+1) = e;                              
            end
        else
            for offset = -kernel_size : 1 : kernel_size
                A = referance_path(starting_index+offset,:);
                B = referance_path(starting_index+offset+1,:);
                X = tracked_path(i,:);
                AB = B - A;
                AX = X - A;
    
                t = dot(AX, AB) / dot(AB, AB);
                t = max(0, min(1, t)); 
    
                T = A + t * AB; 
                e = norm(X - T);
                error_indv_point(end+1) = e;
            end
        end

        total_distance_error(end+1) = min(error_indv_point);
        error_indv_point = [];
end

path_tracking_error = sum(total_distance_error(:));
disp(path_tracking_error);