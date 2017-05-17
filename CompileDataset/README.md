# Quick Start

下記のコマンドを実行してください。  
カレントディレクトリのひとつ上に、datasetのディレクトリを作成します。

```$ ./CompileDataset.sh
```

# datasetの説明

日本古典籍字形データセットは書名ごとにデータを公開しています（http://codh.rois.ac.jp/char-shape/book/）。本データセットは全書名のデータセットを統合したものです。

ディレクトリ構成：  

* characters/  :  文字画像  
* images/      :  文書画像  
* annotations/  :  アノテーションファイル  

* target-Lv1.csv  : レベル1全ターゲット（認識矩形）のデータ  
* target-Lv2.csv  : レベル2全ターゲット（認識対象）のデータ
* groundtruth-Lv1.csv : レベル1全ターゲットの正解データ  
* groundtruth-Lv2.csv : レベル2全ターゲットの正解データ  


* target_lv1_samp_0.9.csv : 全データの9割のデータ（学習用）  
* groundtruth_lv1_samp_0.9.csv : 正解データ  


* target_lv1_test_0.1.csv : 全データの1割のデータ（テスト用）  
* groundtruth_lv1_test_0.1.csv : 正解データ


* target_lv1_samp_5.csv : 各クラス5つのデータ（デバッグなどにどうぞ。学習用）
* groundtruth_lv1_samp_5.csv : 正解データ


* target_lv1_test_5.csv : 各クラス5つのデータ（デバッグなどにどうぞ。テスト用）
* groundtruth_lv1_test_5.csv : 正解データ


* TargetUnicodes_with_Hiragana.txt : 認識対象のUnicodeと対応するひらがな
* TargetUnicodes.txt : 認識対象のひらがな



# Websites

* [日本古典籍字形データセット](http://codh.rois.ac.jp/char-shape/)
