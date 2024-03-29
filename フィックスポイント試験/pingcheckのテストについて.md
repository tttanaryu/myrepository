# pingcheckのテストについて

今回作成したプログラムをテストするにあたって、同一ディレクトリにある以下のテキストファイルをテストデータとした。

* pinglog1.txt ... タイムアウトが少ないデータ。設問1、2のテストに使用。
* pinglog2.txt ... タイムアウトが半分近くあるデータ。設問1、2、3のテストに使用。
* pinglog3.txt ... タイムアウトは多くないが、特定のサーバの応答時間が大きいデータ。設問3のテストに使用。
* pinglog4.txt ... 半分以上がタイムアウトしているデータ。設問4のテストに使用。
* pinglog5.txt ... 大半がタイムアウトしており、応答時間が大きいサーバがあるデータ。設問4のテストに使用。

なお、以下で示すテストは設問4のところまでプログラムを拡張してから実行したものなので、前の設問では出力する必要のない情報を出力している。

## 設問1
### テスト結果
```
julia> pingcheck("pinglog1.txt")
サーバーアドレス：10.20.30.1/16, 故障期間：2021年1月1日0時0分24秒 ～ 2021年1月1日0時1分24秒
サーバーアドレス：192.168.1.1/24, 故障期間：2021年1月1日0時1分34秒 ～ 2021年1月1日0時2分34秒
故障中のサーバー
サーバーアドレス：192.168.1.2/24, 故障期間：2021年1月1日0時2分35秒 ～

julia> pingcheck("pinglog2.txt")
サーバーアドレス：192.168.1.1/24, 故障期間：2020年12月31日23時58分34秒 ～ 2021年1月1日0時0分34秒
サーバーアドレス：10.20.30.1/16, 故障期間：2021年1月1日0時0分24秒 ～ 2021年1月1日0時1分24秒
サーバーアドレス：192.168.1.2/24, 故障期間：2021年1月1日0時1分35秒 ～ 2021年1月1日0時2分35秒
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時58分25秒 ～ 2021年1月1日0時1分25秒
サブネット：10.20.30., 故障期間：2021年1月1日0時0分24秒 ～ 2021年1月1日0時1分24秒
サブネット：192.168.1., 故障期間：2021年1月1日0時1分35秒 ～ 2021年1月1日0時0分34秒
故障中のサーバー
サーバーアドレス：10.20.30.1/16, 故障期間：2021年1月1日0時2分24秒 ～
サーバーアドレス：192.168.1.1/24, 故障期間：2021年1月1日0時2分34秒 ～
```
一度故障が直ってからまた故障したサーバについても問題なく故障を検出している。

## 設問2
### テスト結果
```
julia> pingcheck("pinglog1.txt", 3)

julia> pingcheck("pinglog2.txt", 3)
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時58分25秒 ～ 2021年1月1日0時1分25秒

julia> pingcheck("pinglog2.txt", 2)
サーバーアドレス：192.168.1.1/24, 故障期間：2020年12月31日23時58分34秒 ～ 2021年1月1日0時0分34秒
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時58分25秒 ～ 2021年1月1日0時1分25秒
```
引数のNを変更することで故障していると判定されたサーバが変わることが確認できた。

## 設問3
### テスト結果
```
julia> pingcheck("pinglog2.txt", 3, 3, 5)
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時58分25秒 ～ 2021年1月1日0時1分25秒
過負荷だったサーバー
サーバーアドレス：10.20.30.1/16, 過負荷期間：2020年12月31日23時58分24秒 ～ 2021年1月1日0時1分24秒
サーバーアドレス：192.168.1.2/24, 過負荷期間：2020年12月31日23時58分35秒 ～ 2021年1月1日0時2分35秒

julia> pingcheck("pinglog2.txt", 3, 3, 200)
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時58分25秒 ～ 2021年1月1日0時1分25秒

julia> pingcheck("pinglog3.txt", 3, 3, 20)
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時59分25秒 ～ 2021年1月1日0時2分25秒
過負荷だったサーバー
サーバーアドレス：10.20.30.1/16, 過負荷期間：2020年12月31日23時58分24秒 ～ 2021年1月1日0時2分24秒
サーバーアドレス：192.168.1.1/24, 過負荷期間：2021年1月1日0時0分34秒 ～ 2021年1月1日0時2分34秒

julia> pingcheck("pinglog3.txt", 3, 5, 20)
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時59分25秒 ～ 2021年1月1日0時2分25秒
過負荷だったサーバー
サーバーアドレス：10.20.30.1/16, 過負荷期間：2020年12月31日23時58分24秒 ～ 2021年1月1日0時2分24秒

julia> pingcheck("pinglog3.txt", 3, 3, 200)
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時59分25秒 ～ 2021年1月1日0時2分25秒
過負荷だったサーバー
サーバーアドレス：10.20.30.1/16, 過負荷期間：2020年12月31日23時58分24秒 ～ 2021年1月1日0時2分24秒
```
サーバーが過負荷状態だったかの判定がmとtに入れた値で変わっていることが確認できた。

## 設問4
### テスト結果
```
julia> pingcheck("pinglog4.txt", 3, 3, 200)
サーバーアドレス：10.20.30.1/16, 故障期間：2020年12月31日23時59分24秒 ～ 2021年1月1日0時2分24秒
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時58分25秒 ～ 2021年1月1日0時2分25秒
サブネット：10.20.30., 故障期間：2020年12月31日23時59分24秒 ～ 2021年1月1日0時2分24秒
過負荷だったサーバー
サーバーアドレス：10.20.30.1/16, 過負荷期間：2020年12月31日23時58分24秒 ～ 2021年1月1日0時2分24秒

julia> pingcheck("pinglog4.txt", 4, 3, 200)
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時58分25秒 ～ 2021年1月1日0時2分25秒
過負荷だったサーバー
サーバーアドレス：10.20.30.1/16, 過負荷期間：2020年12月31日23時58分24秒 ～ 2021年1月1日0時2分24秒

julia> pingcheck("pinglog5.txt", 3, 3, 200)
サーバーアドレス：10.20.30.2/16, 故障期間：2020年12月31日23時58分25秒 ～ 2021年1月1日0時2分25秒
故障中のサーバー
サーバーアドレス：192.168.1.1/24, 故障期間：2021年1月1日0時0分34秒 ～
サーバーアドレス：10.20.30.1/16, 故障期間：2020年12月31日23時59分24秒 ～
サーバーアドレス：192.168.1.2/24, 故障期間：2020年12月31日23時58分35秒 ～
故障中のサブネット
サブネット：192.168.1., 故障期間：2021年1月1日0時0分34秒 ～
過負荷だったサーバー
サーバーアドレス：192.168.1.1/24, 過負荷期間：2020年12月31日23時59分34秒 ～ 2020年12月31日23時59分34秒
```
Nの値を変えることでサブネットの故障判定が変化することが確認できた。

pinglog5.txtでのテストで、10.20.30.1/16と10.20.30.2/16のサーバは同一サブネット内のサーバで、かつ両方同時に故障している回数がNを超えているにもかかわらずサブネットの故障を検出できていない。これについては[README](https://github.com/tttanaryu/myrepository/blob/main/%E3%83%95%E3%82%A3%E3%83%83%E3%82%AF%E3%82%B9%E3%83%9D%E3%82%A4%E3%83%B3%E3%83%88%E8%A9%A6%E9%A8%93/README.md)のその他の項を参照。
