import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart' show NumberFormat;
import '../const.dart';

SfSliderTheme slider(overlayRadius, max, min, stepSize, value, onChange) {
  return SfSliderTheme(
      data: SfSliderThemeData(
        overlayRadius: overlayRadius,
        thumbRadius: 8,
        activeTrackColor: kPurple,
        inactiveTrackColor: kPurple.withOpacity(0.25),
        thumbColor: kPurple,
        overlayColor: kPurple.withOpacity(0.25),
        tooltipBackgroundColor: kPurple,
        activeTickColor: kPurple,
        inactiveTickColor: kPurple.withOpacity(0.25),
        activeLabelStyle: textStyle.copyWith(color: kPurple, fontSize: 15),
        inactiveLabelStyle:
            textStyle.copyWith(color: kPurple.withOpacity(0.25), fontSize: 15),
      ),
      child: SfSlider(
          showLabels: true,
          showTicks: true,
          interval: 10,
          stepSize: 1,
          min: min - 1,
          max: max,
          value: value,
          onChanged: (dynamic values) {
            onChange(values);
          },
          enableTooltip: true,
          numberFormat: NumberFormat('#')));
}
