#import "@preview/typewind:0.1.0": *

#set page(
  paper: "a4",
  margin: (x: 22mm, y: 20mm),
  header: [
    #set text(size: 9pt)
    #align(right)[IoP技術者講座]
    #line(length: 100%, stroke: 0.5pt + gray)
  ],
  footer: [
    #set text(size: 9pt)
    #line(length: 100%, stroke: 0.5pt + gray)
    #align(center)[2025 PROMPT-X]
  ],
)
#set text(lang: "ja", font: ("Noto Sans CJK JP", "Noto Sans JP"))
#set par(leading: 1.0em, spacing: 1.0em)
#set heading(numbering: "1.")
#show link: it => underline(text(fill: blue)[#it])
#show heading: it => [#v(2em)#it#v(1em)]
#show figure: it => [#v(2em)#it#v(2em)]
#let note(color, it) = [
#v(1em)
#block(
  fill: color,
  inset: 8pt,
  radius: 4pt,
  stroke: 1pt + color.darken(30%),
)[#it]
#v(1em)
]

#v(30em)
#align(center)[
  #text(size: 24pt, weight: "bold")[
  Arduino IDE\
  インストールマニュアル
  ]
]

#pagebreak()

#outline()
#pagebreak()


// TODO: アイキャッチ画像を挿入する

= 概要

本マニュアルでは講座で使用するアプリケーションと、USB シリアル通信を行うための USB ドライバのインストールを行う手順を説明します。

+ Arduino IDE のインストール
+ Arduino-ESP32 サポート のインストール
+ USB ドライバのインストール

= システム要件（必要スペック）

この講座で使用するソフトウェアを快適に動作させるための推奨PC環境は以下の通りです。

== Arduino IDE
/ 対応OS:
  - Windows 10 (64ビット版) 以降を強く推奨します。
  - Windows 8.1 以前のOSでは、Arduino IDE 1.8.x (レガシーバージョン) の利用を検討してください。ただし、ESP32 Coreの最新バージョンとの互換性に注意が必要です。
/ CPU: 特筆すべき高い要件はありませんが、近年の一般的なプロセッサであれば問題ありません。
/ RAM: 最低4GBを推奨します。より快適な動作のためには8GB以上あると望ましいです。
/ ディスク空き容量:
  - Arduino IDE本体で数百MB。
  - ESP32ボードサポートパッケージとツールチェーンで追加で1GB以上の空き容量が必要になる場合があります。
  - プロジェクトファイルやライブラリの保存領域も考慮してください。
/ その他:
  - USBポート (ESP32ボードとの接続用)
  - インターネット接続 (IDEのダウンロード、ライブラリやボード定義の更新のため)

== Arduino-ESP32 サポート

/ Arduino IDEのバージョン: Arduino IDE 1.8.x 以降。
/ OSとの互換性:
  - ESP32 Core v2.x.x は Windows 7 や Windows 8.x (32ビット) では動作しない可能性があります。これらのOSでは ESP32 Core v1.0.6 などの古いバージョンが必要になる場合があります。

== USBドライバ (Silicon Labs CP210x)

/ 対応OS: Windows 10, Windows 11 (Universal Windows Driverを推奨)。
  - 古いWindowsバージョンでも動作する場合がありますが、Silicon Labsのサイトで最新の対応状況をご確認ください。
/ その他: ドライバのインストールには管理者権限が必要な場合があります。

== 注意事項

- #text(weight: "bold")[PCのユーザー名（ユーザーフォルダ名）:]
  Windowsのユーザー名（ユーザーフォルダ名）に #box(fill:yellow-100)[*日本語、スペース、アクセント記号付き文字などのASCII文字以外の文字（ユニコード文字*] が含まれていると、Arduino IDEや関連ツールが正しく動作しない場合があります。PCのユーザー名は#box(fill:yellow-100)[*半角英数字のみ*]で構成されている環境を推奨します。
- #text(weight: "bold")[社用PCなどでの制限:]
  セキュリティポリシーなどにより、ソフトウェアのインストールやUSBデバイスの接続が制限されている場合があります。事前に情報システム部門にご確認ください。ZIP版のArduino IDEの利用も検討してください。

#note(red-100)[
  #text(weight: "bold", fill: red.darken(30%))[重要: PCのユーザー名（ユーザーフォルダ名）について]

  Windowsのユーザー名（ユーザーフォルダ名）に 日本語、スペース、アクセント記号付き文字などのASCII文字以外の文字（ユニコード文字）が含まれている場合、Arduino IDEや関連ツール（特にESP32開発ツール）が正しく動作せず、コンパイルエラーやツールの起動失敗などの問題が発生することがあります。

  可能な限り、PCのユーザー名は #box(fill:yellow-100)[*半角英数字のみ*]で構成されている環境で作業することを推奨します。

  もし該当する場合は、以下のいずれかの対策をご検討ください:
  - 半角英数字のみの新しいローカルユーザーアカウントを作成して作業する。
  - Arduino IDEやプロジェクトファイル、ツールチェーンなどを、ユーザーフォルダパスを含まない場所（例: *C:\Arduino* など）に配置・インストールする（ただし、ツールによっては完全に問題を回避できない場合があります）。
]

#pagebreak()

= Arduino IDE のインストール

Arduino IDE とは Arduino ボード上で動作するソフトウェアを開発するために作られた統合開発環境です。ソースコードの編集、マイコンへの書き込み機能などの機能を有します。C 言語と C++をベースとした「Arduino 言語」によってプログラムを作成できます。

#note(yellow-100)[
  #text(weight: "bold")[Arduino とは]

  Arduino ボード（ハードウェア）と Arduino IDE（ソフトウェア）から構成されるシステムです。ワンボードマイコンの一種であり、I/O ポートを備えることで拡張性に富んだ装置として使用できます。
  オープンソースのハードウェアとソフトウェアであり、簡単な規定さえ守れば誰でも自由に使用できます。
]

プログラムを開発し、マイコンに書き込む Arduino IDE のインストールを行います。

#link("https://www.arduino.cc/en/software")[Arduino IDE 公式サイト]より、インストールファイルをダウンロードします。

#figure(
  caption: "Arduino IDE ダウンロードページ",
)[
  #image("images/0001_arduino.jpg", width: 50%)
]

#note(emerald-100)[
  #text(weight: "bold")[ZIP ファイルも選択できます]

  インストーラー（exe, msi）だけでなく、インストール不要の zip 圧縮ファイルも選択できます。社用 PC などインストールできない場合にはこちらを選択してください。
  エクスプローラーでファイルを右クリックし「すべて展開」することで解凍され、実行可能になります。
]

#pagebreak()

#figure(
  caption: [寄付やメール登録を促す画面が表示されます。\
  *Just Download* を選択することでパスできます。],
)[
  #image("images/0002_arduino.jpg", width: 50%)
]

// 画像: /images/0003_arduino.jpg
// #image("images/0003_arduino.jpg", width: 70%)
// 説明: 「JUST DOWNLOAD」ボタンが表示された画面。

ダウンロードしたインストーラーを実行し、画面の指示に従ってインストールを進めます。
//（以下、一般的なインストーラーの進行画面を想定したテキスト）
+ *ライセンス契約*: 表示されたライセンス契約を読み、「I Agree」または「同意する」をクリックします。
+  *インストールオプション*: インストールするコンポーネントを選択します。通常はデフォルト設定のままで問題ありません。「Next」または「次へ」をクリックします。
+  *インストール先フォルダ*: Arduino IDEをインストールするフォルダを指定します。通常はデフォルトのままで問題ありません。「Install」または「インストール」をクリックします。
+  *インストール中*: インストールが進行します。完了するまで待ちます。
+  *完了*: インストールが完了したら、「Close」または「完了」をクリックします。

#figure(
caption: "展開先の選択",
)[
#image("images/0004_arduino.jpg", width: 50%)
]

#pagebreak()

= Arduino-ESP32 サポートのインストール

// TODO: ESP32の画像を挿入する

講座では#link("https://ja.wikipedia.org/wiki/ESP32")[ESP32]という Arduino と互換性のあるマイクロコントローラを使用します。

Arduino IDE で ESP32 を開発するためのサポート (#link("https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html")[Arduino-ESP32 support])をインストールします。

まず、Arduino IDE を起動します。

#figure(
caption: "インストールオプション",
)[
#image("images/0005_arduino.jpg", width: 50%)
]

#figure(
caption: "Arduino IDE 起動後の初期画面",
)[
#image("images/0006_arduino.jpg", width: 50%)
]


*ファイル* > *基本設定* (または*File* > *Preferences*) の順にクリックします。

#figure(
caption: "環境設定",
)[
#image("images/0007_esp32.jpg", width: 50%)
]

#figure(
caption: "環境設定",
)[
#image("images/0008_esp32.jpg", width: 50%)
]

下にある #text(weight: "bold")[追加のボードマネージャの URL] に注目してください。ここに下記の URL を貼り付けます。

#block(
  inset: 8pt,
  fill: gray-100,
  radius: 2pt,
)[`https://espressif.github.io/arduino-esp32/package_esp32_index.json`]


*OK* ボタンをクリックします。

*ツール* > *ボード* > *ボードマネージャ* の順にクリックします。
(左側のメニューの上から 2 番目のアイコンをクリックしても開けます)

#figure(
caption: "ボードマネージャを開く",
)[
#image("images/0009_esp32.jpg", width: 50%)
]

#figure(
caption: "ボードマネージャの追加",
)[
#image("images/0010_esp32.jpg", width: 50%)
]

検索フォームで #box(fill:yellow-100)[*esp32*] と検索すると #box(fill: yellow-100)[*esp32 by Espressif Systems*] がヒットします。複数表示された場合は 開発元が ESP32 の#box(fill:yellow-100)[*Espressif Systems*] になっているか確認してください。

*インストール*ボタンをクリックしてインストールします。（インストールには時間がかかります）

*ツール* > *ボード* > *ESP32 Arduino* > *ESP32 Wrover Module* の順にクリックします。

#figure(
caption: "ボードの選択",
)[
#image("images/0011_esp32.jpg", width: 50%)
]


#figure(
caption: "設定の確認",
)[
#image("images/0012_esp32.jpg", width: 50%)
]

#heading[USB ドライバのインストール]

ArduinoIDE を使用して ESP32 にプログラムを書き込む際には、USB ケーブルで接続して通信します。この際に必要なドライバのインストールです。

[参考: #link("https://docs.espressif.com/projects/esp-idf/en/v4.3.4/esp32/get-started/establish-serial-connection.html")]

※ 使用する PC や OS のバージョンによっては必要ありません。不明でしたら講座当日のインストールでも構いません。

#note(luma(240))[
  #text(weight: "bold")[UART とは]

  PC と ESP32 との間の通信に使われるプロトコルです。通信は特定のビットレート（#text(weight: "bold")[Baud Rate: ボーレート]）で行われます。
  ESP32 にプログラムを書き込んだり、ESP32 からのデータをリアルタイムで表示(ArduinoIDE のシリアルモニタ機能)できます。
]

#text(weight: "bold")[インストール]

#link("https://www.silabs.com/developer-tools/usb-to-uart-bridge-vcp-drivers?tab=downloads")[Silicon LabsのUSB to UART Bridge VCP Driversダウンロードページ] からドライバをダウンロードします。

#figure(
caption: "Silicon LabsのUSB to UART Bridge VCP Driversダウンロードページ",
)[
#image("images/0013_cp210x.jpg", width: 50%)
]

#figure(
caption: "ダウンロードしたファイルの選択",
)[
#image("images/0014_cp210x.jpg", width: 50%)
]


ダウンロードしたファイルを実行してインストールします。
（以下、一般的なインストーラーの進行画面を想定したテキスト）

1.  *インストーラー起動*: ダウンロードしたドライバのインストーラーを起動します。「Next」または「次へ」をクリックします。

#figure(
caption: "CP210xドライバインストーラーの開始画面"
)[
#image("images/0015_cp210x.jpg", width: 50%)
]

2.  *ライセンス同意*: ライセンス契約を読み、「I accept the agreement」または「同意する」を選択し、「Next」または「次へ」をクリックします。

#figure(
caption: "ライセンス同意画面"
)[
#image("images/0016_cp210x.jpg", width: 50%)
]

3.  *インストール完了*: インストールが完了したら、「Finish」または「完了」をクリックします。

#figure(
caption: "インストール完了画面"
)[
#image("images/0017_cp210x.jpg", width: 50%)
]

#text(weight: "bold")[デバイスマネージャで確認]

#box(fill:yellow-100)[*Windows のスタートボタンを右クリック*]し、 #box(fill:yellow-100)[*デバイスマネージャ*] をクリックして開きます。

#figure(
caption: "デバイスマネージャを開きます"
)[
#image("images/0018_cp210x.png", width: 50%)
]

#figure(
caption: "デバイスマネージャ",
)[
#image("images/0019_cp210x.png", width: 50%)
]

#box(fill:yellow-100)[*ポート（COM と LPT)*] をクリックして展開します。\
ここに#box(fill:yellow-100)[*「Silicon Labs CP210x USB to UART Bridge (COMx)」*(xは数字)] のように表示されていれば、ドライバは正しくインストールされています。

#pagebreak()

= 変更履歴

#set text(size: 8pt)
#table(
  columns: (3cm, 10cm, 3cm),
  align: (center, left, center),
  stroke: 0.5pt + gray,
  [*変更日*], [*変更内容*], [*担当者*],
  [2024/06/01], [Markdownに移植、図の追加], [PTX 中平],
  [2025/05/07], [Typstに移植、cp210xのダウンロードURLの修正], [PTX 中平],
)
