function [ids, tarCodes] = ReadGroundtruth( fn )
% function [ids, tarCodes] = ReadGroundtruth( fn )

fid = fopen( fn,'r' );
if( fid < 0 ), error('Cannot read %s\n', fn); end

fgetl(fid); % Skip first line
i=1;
while( ~feof(fid) )
  
  % Get a line
  str = fgetl(fid);
  strs = strsplit( str, ','); % split
  
  % for Lv3
  if( isempty(strs{end} ) ), strs = strs(1:end-1); end
  
  % Check
  for j=2:numel(strs)
    if( ~strncmp( strs{j}, 'U+', 2 ) ), error('Error: the file is NOT groundtruth'); end
  end
  
  % Store
  id = str2double(strs{1});
  codes = strs(2:end);
  
  tarCodes{i} = codes;
  ids(i) = id;
  i = i + 1;
end
fclose(fid);


end