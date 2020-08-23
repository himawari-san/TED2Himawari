# TED 字幕テキスト　→　『ひまわり』変換スクリプト
　TEDの字幕テキスト([WIT3](https://wit3.fbk.eu/))を全文検索システム『ひまわり』用のXMLファイルへ変換します。

　なお，より手軽に変換したい方は，『ひまわり』の「[TED字幕テキストの利用](https://www2.ninjal.ac.jp/lrc/index.php?%C1%B4%CA%B8%B8%A1%BA%F7%A5%B7%A5%B9%A5%C6%A5%E0%A1%D8%A4%D2%A4%DE%A4%EF%A4%EA%A1%D9/TED%BB%FA%CB%EB%A5%C6%A5%AD%A5%B9%A5%C8%A4%CE%CD%F8%CD%D1)」のページを参照してください。

## 変換方法

``` shell
 $ perl ted2himawari.pl ted_lang1.xml ted_lang2.xml > corpus.xml
```

- ted_lang1.xml, ted_lang2.xml は，[WIT3](https://wit3.fbk.eu/)の[Latest version of XML files of the TED Talks (April 2016)](https://wit3.fbk.eu/mono.php?release=XML_releases&tinfo=cleanedhtml_ted)から２言語分のファイルをダウンロードしてください。
- ted_lang1.xml が全文検索の対象となります。

## 『ひまわり』へのインストール方法
1. Package/Corpora/TED/ に corpus.xml をコピーしてください。
2. 『ひまわり』を起動し，Package フォルダを『ひまわり』にドラッグ＆ドロップしてください。
3. [ツール]→[構築]→[インデックス生成]を実行してください。
4. 以上で終了です。使い方は，『ひまわり』の「[TED字幕テキストの利用](https://www2.ninjal.ac.jp/lrc/index.php?%C1%B4%CA%B8%B8%A1%BA%F7%A5%B7%A5%B9%A5%C6%A5%E0%A1%D8%A4%D2%A4%DE%A4%EF%A4%EA%A1%D9/TED%BB%FA%CB%EB%A5%C6%A5%AD%A5%B9%A5%C8%A4%CE%CD%F8%CD%D1#v23210fa)」のページを参照してください。
