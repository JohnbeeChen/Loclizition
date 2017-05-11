
inde = 5;
one_event = sim_event_info{inde};
one_box = struct2cell(boxs(inde));
one_box = cell2mat(one_box);
start_p = one_box(1:2) - 0.5;
stop_p = start_p + one_box(3:4);
id_x = start_p(1):stop_p(1);
id_y = start_p(2):stop_p(2);
% tem_region = img_sim(id_y,id_x,:);
duration = one_event(1,1):one_event(1,2);
event_frams = img_sim(:,:,duration);
event_frams_roi = KeepROI(event_frams,one_box);

% imshow(event_frams_roi(:,:,1),[]);
% img_num = size(tem_region,3);
particles = FindParticles(event_frams_roi,3,3);
least_fram = 4;
DV = Point_Linking(particles, 1.5,least_fram);
event_fit_result = Point_Fitting(event_frams,DV,2);
recon_result = FittingResult_Reconstru(event_fit_result);
%% display
% figure(1)
% imshow(img_sim(:,:,1),[]);
% hold on
% plot(start_p(1),start_p(2),'b*');
% hold on
% plot(stop_p(1),stop_p(2),'r*');
% hold off
% figure(2)
% colormap(gray);
% imagesc(tem_region(:,:,1));


nmb =1;