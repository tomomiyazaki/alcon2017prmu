function WriteOutput( test_ids, outputs, fnOut, lv )

% File open
fid = fopen( fnOut, 'w' );
if( fid < 0 ), error('Cannot open %s', fnOut); end

% First line
fprintf( fid, 'ID'); 
if( lv==1 ), fprintf(fid, ',Unicode'); 
elseif( lv==2 ), for i=1:3, fprintf(fid, ',Unicode'); end
elseif( lv==3 ), for i=1:16, fprintf(fid, ',Unicode'); end
end
fprintf(fid,'\n');

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
