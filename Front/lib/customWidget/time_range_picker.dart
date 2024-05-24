
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

class TimeRangePicker extends StatefulWidget {
  const TimeRangePicker({super.key});

  @override
  State<TimeRangePicker> createState() => _TimeRangePickerState();
}

class _TimeRangePickerState extends State<TimeRangePicker> {
  late TextEditingController _controller;
  TimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onRangeSelected(TimeRange range) {
    setState(() {
      _selectedRange = range;
      if (range != null) {
        final dayInSeconds = const Duration(days: 1).inSeconds;
        final durationEndTime = Duration(hours: range.endTime.hour, minutes: range.endTime.minute).inSeconds;
        final durationStartTime = Duration(hours: range.startTime.hour, minutes: range.startTime.minute).inSeconds;
        int totalDurationInSeconds;

        if (durationEndTime - durationStartTime < 0) {
          totalDurationInSeconds = (durationEndTime + dayInSeconds) - durationStartTime;
        }
        else {
          totalDurationInSeconds = durationEndTime - durationStartTime;
        }

        var hours = '${(Duration(seconds: totalDurationInSeconds))}'.split('.')[0].split(':')[0];
        var minutes = '${(Duration(seconds: totalDurationInSeconds))}'.split('.')[0].split(':')[1];

        _controller.text = '$hours:$minutes';
      } else {
        _controller.text = '';
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Center(
        child: TextField(
          controller: _controller,
          readOnly: true, // Prevent manual editing
          onTap: () async {
            TimeRange result = await showTimeRangePicker(
              context: context,
            );
            _onRangeSelected(result);
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Temps passé',
          ),
        ),
      ),
    );
  }
}
