function varargout = atrous_threshold(img)

W3_TRIF = Detection(img,0);
bw = global_threshold(W3_TRIF,0.01);
SE = strel('disk',2);
bw = imopen(bw,SE);
SE = strel('disk',2);
bw = imclose(bw,SE);
bw = imclearborder(bw,4);
varargout{1} = bw;
end