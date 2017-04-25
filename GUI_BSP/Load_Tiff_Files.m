function varargout = Load_Tiff_Files(varargin)

if nargin == 1
    pathname = varargin{1};
else
pathname = cd;
end

[filename, pathname] = uigetfile( ...
    {'*.tif;*.tiff', 'All TIF-Files (*.tif,*.tiff)'; ...
        '*.*','All Files (*.*)'}, ...
    'Select Image File',pathname);
if isequal([filename,pathname],[0,0])
    varargout{1} = -1;
    return
else
    File = fullfile(pathname,filename);
    if ~isempty(File)
        t=strfind(filename,'.tif');
        filebase=filename(1:t-1);
        filebase = filebase;
        pathname = pathname;        
    end
varargout{1} = File;
end