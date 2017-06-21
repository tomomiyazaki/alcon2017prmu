function [count, total, oxs] = Evaluation( fn_test_target, outputs, ids )

% Filename of Groundtruth
[ pathto, fn, ext ] = fileparts( fn_test_target );
fn_test_ground = fullfile( pathto, [ 'groundtruth', fn(7:end), ext] );

% Read groundtruth
[ test_ids, test_codes ] = ReadGroundtruth( fn_test_ground );


count = 0;
total = 0;
for i=1:numel(ids)
  
  % Check
  if( ids(i) ~= test_ids(i) ), error('Error: target id is different'); end
  
  % Compare
  answer = test_codes{i}; % cell str, groundtruth
  guess = outputs{i}; % cell str, output
  
  % Total of groundtruth
  total = total + numel(answer);
  
  % Take elements
  if( numel(answer) <= numel(guess) ), n = numel( answer );
  elseif( numel(answer) > numel(guess) ), n = numel( guess );
  else, error('Error: stop'); 
  end
  answer = answer(1:n);
  guess = guess(1:n);
  
  % Compare
  ox = strcmp( answer, guess );
  count = count + sum( ox );
  
  % store
  oxs{i} = ox;
end


end