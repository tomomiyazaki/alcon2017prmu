%% This sample uses NN method
%
% 出力はN行1列のセル配列でお願いします。
% セルの要素は、Uniocdeを格納したセル配列とします。
%   レベル１の例（出力個数：１）
%     outputs{1} = {'U+1111'};
%     outputs{2} = {'U+2222'};
%
%   レベル２の例（出力個数：３）
%     outputs{1} = {'U+1111', 'U+1111', 'U+1111'};
%     outputs{2} = {'U+2222', 'U+2222', 'U+2222'};
%
%   レベル３の例（出力個数：３以上）
%     outputs{1} = {'U+1111', 'U+1111', 'U+1111', 'U+1111'};
%     outputs{2} = {'U+2222', 'U+2222', 'U+2222', 'U+2222', 'U+2222'};

function out = user_function( img, rect, dirData, lv )

% Construct model
model = construct_model( dirData, lv );


% Get target image
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);
test_img = rgb2gray( img( y:y+h, x:x+w, : ) ); % gray scale
test_img = imresize( test_img, [32,32] ); % resize
test_feature = double( test_img(:) ); % feature

% Calculate distance
n = size( model.train_features, 1 );
fs = repmat( test_feature', n, 1 );
dists = sqrt( sum( ( model.train_features - fs ) .^ 2, 2 ) );

% Find the nearest class
[ ~, idx ] = min( dists );
out = model.train_classes( idx );


end



function model = construct_model( dirData, lv )

fnModel = sprintf( './model_lv%d.mat', lv );
if( exist( fnModel, 'file' ) )
  model = load(fnModel,'train_features', 'train_classes');
  return;
end

% Get training data
fn = [ dirData, 'annotations/lv',num2str(lv),'/for_sample/groundtruth_lv',num2str(lv),'_train.csv' ];
[ train_ids, train_codes ] = ReadGroundtruth( fn );

fn = [ dirData, 'annotations/lv',num2str(lv),'/for_sample/target_lv',num2str(lv),'_train.csv' ];
[ ~, train_dids, train_rects] = ReadTargets( fn );

% Extract features
n_train = numel( train_ids );
train_features = zeros( n_train, 32*32 );
train_classes = cell( n_train, 1 );
for i=1:n_train
  
  % Get document image in training data
  fnDoc = fullfile( dirData, 'images/', [train_dids{i}, '.jpg'] );
  if( ~exist(fnDoc,'file') ), error('Error: please check document file, %s', fnDoc); end
  img_train = imread( fnDoc ); % document image
  
  % Get featuires
  x = train_rects(i,1);
  y = train_rects(i,2);
  w = train_rects(i,3);
  h = train_rects(i,4);
  if( size(img_train,3)>1 ), train_img = rgb2gray( img_train( y:y+h, x:x+w, : ) ); 
  else, train_img = img_train; end% gray scale
  train_img = imresize( train_img, [32,32] ); % resize
  train_features(i,:) = double( train_img(:) );
  
  % Get class
  train_classes{i} = train_codes{i};
  
end

model.train_features = train_features;
model.train_classes = train_classes;
if( ~exist(fnModel,'file') ), save( fnModel, 'train_features', 'train_classes'); end

end