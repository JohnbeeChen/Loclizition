function varargout = SIM_Handle(imgSIM,eventSIM,boxsSIM)
% handle the SIM's images

pixe_size = 32.5; %nanometer
region_num = length(boxsSIM);
box_mat = struct2cell(boxsSIM)';
box_mat = cell2mat(box_mat);
start_p = box_mat(:,1:2) - 0.5;
stop_p = start_p + box_mat(:,3:4);
regoin_fit_result  = cell(region_num,1);
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
        event_fit_result{jj} = Point_Fitting(event_frams,DV,2);

%         precise =  Localization_Precise(event_fit_result{jj},pixe_size);
%         recon_result = FittingResult_Reconstru(event_fit_result{jj});
    end
    regoin_fit_result{ii} = event_fit_result;
end
varargout{1} = regoin_fit_result;

