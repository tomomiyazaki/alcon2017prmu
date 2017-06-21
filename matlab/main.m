
dirData = '/Users/tomo/src/alcon2017/dataset/';
lv = 3;

% �e�X�g�f�[�^��ǂݍ���
% �T���v���ł͏������f�[�^�Z�b�g��ǂݍ���ł��܂��B
fn_test_target = [ dirData, 'annotations/lv',num2str(lv),'/for_sample/target_lv',num2str(lv),'_test.csv' ];
[ test_ids, test_dids, test_rects] = ReadTargets( fn_test_target );

% Process each testdata
N = numel(test_ids);
outouts = cell( numel(test_ids), 1 );
for i=1:N
  
  % Get document image
  fnDoc = fullfile( dirData, 'images/', [test_dids{i}, '.jpg'] );
  if( ~exist(fnDoc,'file') ), error('Error: please check document file, %s', fnDoc); end
  img = imread( fnDoc );
  
  % �Ǝ��̃A���S���Y�������s���܂�
  rect = test_rects(i,:);
  out = user_function( img, rect, dirData, lv );
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
[count, total, oxs] = Evaluation( fn_test_target, outputs, test_ids );
fprintf(1,'Result: %f\n', count / total );

% write Output
fnOut = './myOutputs.csv';
WriteOutput( test_ids, outputs, fnOut, lv );