function WriteOutput( test_ids, outputs, fnOut )

% File open
fid = fopen( fnOut, 'w' );
if( fid < 0 ), error('Cannot open %s', fnOut); end

fprintf( fid, 'ID,Unicode\n'); % first line
for i=1:numel(test_ids)
  
  % write ID
  fprintf( fid, '%d,', test_ids(i) );
  
  % write codes
  out = outputs{i}; % cell str
  for j=1:numel(out)
    if( j~= numel(out) ), fprintf( fid, '%s,', out{j} );
    else, fprintf( fid, '%s\n', out{j} ); end
  end
  
end

fclose( fid );

end
