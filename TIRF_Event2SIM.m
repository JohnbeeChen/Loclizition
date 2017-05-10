function varargout = TIRF_Event2SIM(tirfEventInfos)
% the events found in TIRF images trans to in SIM

in_infos = tirfEventInfos;
out_infos = tirfEventInfos;

num = length(in_infos);
parfor ii = 1:num
    tem_info = in_infos{ii};
    tem = 3 * tem_info;
    tem(:,3) = tem(:,2) - tem(:,1) + 1;
    out_infos{ii} = tem;
end
varargout{1} = out_infos;