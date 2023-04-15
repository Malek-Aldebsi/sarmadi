import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../const/colors.dart';

class CircularChart extends StatelessWidget {
  final double label;
  final Color? activeColor;
  final Color inActiveColor;
  final Color labelColor;
  final double width;

  const CircularChart({
    super.key,
    required this.label,
    this.activeColor,
    required this.inActiveColor,
    required this.labelColor,
    required this.width,
  });

  Color getActiveColor(double label) {
    if (label > 75) {
      return kGreen;
    } else if (label > 25) {
      return kOrange;
    } else {
      return kRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<RadialBarSeries<ChartData, String>> getRadialBarSeries() {
      final List<RadialBarSeries<ChartData, String>> list =
          <RadialBarSeries<ChartData, String>>[
        RadialBarSeries<ChartData, String>(
          animationDuration: 1200,
          trackColor: inActiveColor,
          maximumValue: 100,
          radius: '100%',
          innerRadius: '80%',
          dataSource: <ChartData>[
            ChartData(
                x: 'Avg',
                y: label,
                pointColor: activeColor ?? getActiveColor(label)),
          ],
          cornerStyle: CornerStyle.bothCurve,
          xValueMapper: (ChartData data, _) => data.x as String,
          yValueMapper: (ChartData data, _) => data.y,
          pointColorMapper: (ChartData data, _) => data.pointColor,
        )
      ];
      return list;
    }

    return SizedBox(
      width: width,
      height: width,
      child: SfCircularChart(
        margin: const EdgeInsets.all(0),
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
              widget: Text('${label.roundToDouble()}%',
                  style: TextStyle(color: labelColor, fontSize: width * 0.2)))
        ],
        series: getRadialBarSeries(),
      ),
    );
  }
}

class ChartData {
  ChartData({
    this.x,
    this.y,
    this.pointColor,
  });

  final dynamic x;

  final double? y;

  final Color? pointColor;
}
