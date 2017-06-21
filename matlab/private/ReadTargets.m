function [ids, dids, rects] = ReadTargets( fn )


fid = fopen( fn,'r' );
if( fid < 0 ), error('Cannot read %s\n', fn); end

fgetl(fid); % Skip first line
i=1;
while( ~feof(fid) )
  
  % Get a line
  str = fgetl(fid);
  
  % Divide the line into elements
  strs = strsplit( str, ','); 
  if( numel(strs) ~= 6 ), error('Error: make sure the filename'); end
  
  id = str2double(strs{1});
  d = strs{2}; % document file id
  r = [ str2double( strs{3} ); ... % X
    str2double( strs{4} ); ... % Y
    str2double( strs{5} ); ... % W
    str2double( strs{6} ) ]; % H
  
  % Store
  ids(i) = id;
  dids{i} = d;
  rects(i,:) = r;
  
  i = i + 1;
end
fclose(fid);


end