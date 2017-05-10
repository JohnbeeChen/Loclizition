function varargout = SIM_Handle(imgSIM,eventSIM,boxsSIM)
% handle the SIM's images

region_num = length(boxsSIM);
box_mat = struct2cell(boxsSIM)';
box_mat = cell2mat(box_mat);
start_p = box_mat(:,1:2) - 0.5;
stop_p = start_p + box_mat(:,3:4);
for ii = 1:region_num
    id_x = start_p(ii,1):stop_p(ii,1);
    id_y = start_p(ii,2):stop_p(ii,2);
    tem_region = imgSIM(id_y,id_x,:);
    tem_event = eventSIM{ii};
    event_num = size(tem_event,1);
    for jj = 1:event_num
        event_duration = tem_event(jj,1):tem_event(jj,2);
        event_frams = tem_region(:,:,event_duration);
        particles = FindParticles(event_frams,3,3);
        least_fram = 4;
        DV = Point_Linking(particles, 1.5,least_fram);
        FitResult = Point_Fitting(img_SIM,DV,2);
    end
end


