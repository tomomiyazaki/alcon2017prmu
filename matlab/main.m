
dirData = '/Users/tomo/src/alcon2017/dataset/';

% テストデータを読み込む
% サンプルでは小さいデータセットを読み込んでいます。
fn_test_target = [ dirData, 'annotations/target_lv1_test_1.csv' ];
[ test_ids, test_dids, test_rects] = ReadTargets( fn_test_target );

% Process each testdata
N = numel(test_ids);
outouts = cell( numel(test_ids), 1 );
for i=1:N
  
  % Get document image
  fnDoc = fullfile( dirData, 'images/', [test_dids{i}, '.jpg'] );
  if( ~exist(fnDoc,'file') ), error('Error: please check document file, %s', fnDoc); end
  img = imread( fnDoc );
  
  % 独自のアルゴリズムを実行します
  rect = test_rects(i,:);
  out = user_function( img, rect, dirData );
  outputs(i) = out;
  
  % Print
  fprintf(1,'Testing: id = %7d, out = ', test_ids(i) );
  out = out{1};
  for j=1:numel(out)
    if( j~= numel(out) ), fprintf( 1, '%s, ', out{j} );
    else, fprintf(1,'%s\n', out{j} ); end
  end
  
end

% Evaluation
[count, total] = Evaluation( fn_test_target, outputs, test_ids );
fprintf(1,'Result: %f\n', count / total );

% write Output
fnOut = './myOutputs.csv';
WriteOutput( test_ids, outputs, fnOut );