import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gh_stock/stock_item.dart';
import 'package:gh_stock/stock_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '목표 주가 계산기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GhStock(),
    );
  }
}

class GhStock extends StatefulWidget {
  const GhStock({Key? key}) : super(key: key);

  @override
  State<GhStock> createState() => _GhStockState();
}

class _GhStockState extends State<GhStock> {
  /// 현재주가
  TextEditingController stockPrice = TextEditingController();

  // /// 매출액
  // TextEditingController take = TextEditingController();

  /// 당기 순이익
  TextEditingController netProfit = TextEditingController();

  /// 발행 주식수
  TextEditingController stockCnt = TextEditingController();

  double get _stockPrice => textToDouble(stockPrice.text);

  // double get _take => textToDouble(take.text) * 1000000000;
  double get _netProfit => textToDouble(netProfit.text);

  double get _stockCnt => textToDouble(stockCnt.text);

  double? currentPER;
  double? currentEPS;

  List<StockItem> resultList = [];

  List<int> examplePERList = [5, 10, 15, 20, 25, 30, 40];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(40),
      constraints: const BoxConstraints(
        maxWidth: 500,
        minWidth: 300,
      ),
      child: Column(
        children: [
          const Text('목표 주가 계산기'),
          const SizedBox(height: 10),
          StockTextField(
            textController: stockPrice,
            labelText: '현재 주가',
            hintText: '현재 주가를 입력하세요',
          ),
          // const SizedBox(height: 10),
          // StockTextField(
          //   textController: take,
          //   labelText: '매출액(십억)',
          //   hintText: '매출액을 입력하세요',
          // ),
          const SizedBox(height: 10),
          StockTextField(
            textController: netProfit,
            labelText: '당기 순이익',
            hintText: '당기 순이익을 입력하세요',
          ),
          const SizedBox(height: 10),
          StockTextField(
            textController: stockCnt,
            labelText: '발행 주식수',
            hintText: '발행 주식수를 입력하세요',
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onTapCalc,
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: const Text('계산하기'),
            ),
          ),
          const SizedBox(height: 10),
          _resultArea(),
        ],
      ),
    );
  }

  Widget _resultArea() {
    if (currentEPS == null || currentPER == null) {
      return const SizedBox();
    }
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text('PER : $currentPER'),
            Text('EPS : $currentEPS'),
            _examplePERList(),
          ],
        ),
      ),
    );
  }

  Widget _examplePERList() {
    return ListView.builder(
      itemCount: resultList.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (_, index) {
        return _exampleListItem(resultList[index]);
      },
    );
  }

  Widget _exampleListItem(StockItem item) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Target PER : ${item.per}'),
          Text('주가 : ${item.price!.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  double textToDouble(String value) {
    var convert = double.tryParse(value);
    if (convert == null) {
      Fluttertoast.showToast(msg: '계산에 오류가 발생했습니다.');
      return 1.0;
    }
    return convert;
  }

  /// 계산하기 클릭 이벤트
  void onTapCalc() {
    resultList.clear();
    if (stockPrice.text.isEmpty ||
        // take.text.isEmpty ||
        netProfit.text.isEmpty ||
        stockCnt.text.isEmpty) {
      Fluttertoast.showToast(msg: '필수 정보를 입력하세요.');
      return;
    }
    currentEPS = double.parse((_netProfit / _stockCnt).toStringAsFixed(1));
    currentPER = double.parse((_stockPrice / currentEPS!).toStringAsFixed(1));

    /// PER 1당 가격
    double perPrice = _stockPrice / currentPER!;

    for (var i in examplePERList) {
      resultList.add(StockItem(per: i, price: perPrice * i));
    }

    setState(() {});
  }
}
