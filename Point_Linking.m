function varargout = Point_Linking(point_cell,radius)


% gap = 0;
uncertainty = radius^2;
img_num = size(point_cell,2);

trackInfos = cell(img_num,1);
point_set = point_cell;
track_info = zeros(1,5);%[start_fram,stop_fram,x_center,y_center,peak_intensity]
for ii = 1:img_num
    point_num = length(point_set{ii}(:,1));
    for jj = 1: point_num
        track_info(1) = ii; %start frame
        track_info(3:5) = point_set{ii}(jj,1:3);
        next_fram = ii + 1;
        while 1
            if next_fram <= img_num               
                next_points = point_set{next_fram};
                xx = track_info(3);
                yy = track_info(4);
                points_xx = next_points(:,1);
                points_yy = next_points(:,2);
                distance = (points_xx - xx).^2 + (points_yy - yy).^2;
                min_dis = min(distance(:));
                
                if(min_dis < uncertainty)
                    index = find(distance == min_dis,1);
                    if next_points(index,3) > track_info(5)
                        %update the intensity and location of the peak
                        track_info(3:5) = next_points(index,1:3);
                    end
                    track_info(2) = next_fram;%update the stop_fram
                    point_set{next_fram}(index,:) = [];
                    next_fram = next_fram + 1;
                else
                    break;
                end
            else
                break;
            end
        end
        trackInfos{ii}(jj,:) = track_info;
    end
    
end
varargout{1} = cell2struct(trackInfos,'trackInfo',2);
end


