import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class SetPeriodDialog extends StatefulWidget {
  final String machineName;
  final int deviceId;
  final double price;
  final int quantity;

  const SetPeriodDialog({
    Key? key,
    required this.machineName,
    required this.deviceId,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  _SetPeriodDialogState createState() => _SetPeriodDialogState();
}

class _SetPeriodDialogState extends State<SetPeriodDialog> {
  DateTime? _fromDate;
  DateTime? _toDate;
  final List<DateTime> _bookedDates = [
    DateTime(2024, 10, 30),
    DateTime(2024, 11, 5),
  ];

  bool get _canAddToCart => _fromDate != null && _toDate != null;

  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildDateContainer('Rental Date', _fromDate),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDateContainer('Return Date', _toDate),
        ),
      ],
    );
  }

  Widget _buildDateContainer(String label, DateTime? date) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date != null ? DateFormat.yMd().format(date) : '未選択',
            style: const TextStyle(fontSize: 14),
          ),
          const Icon(Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      focusedDay: DateTime.now(),
      selectedDayPredicate: (day) {
        return day == _fromDate || day == _toDate ||
            (day.isAfter(_fromDate ?? day) && day.isBefore(_toDate ?? day));
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          if (_fromDate == null || (_toDate != null && selectedDay.isBefore(_fromDate!))) {
            _fromDate = selectedDay;
            _toDate = null;
          } else if (_toDate == null || selectedDay.isAfter(_fromDate!)) {
            _toDate = selectedDay;
          } else {
            _fromDate = selectedDay;
            _toDate = null;
          }
        });
      },
      calendarStyle: CalendarStyle(
        rangeHighlightColor: Colors.red.withOpacity(0.3),
        todayDecoration: BoxDecoration(
          color: Colors.blue.shade100,
          shape: BoxShape.rectangle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.red.shade100,
          shape: BoxShape.rectangle,
        ),
        defaultDecoration: const BoxDecoration(
          color: Colors.lightBlue,
          shape: BoxShape.rectangle,
        ),
        weekendDecoration: const BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.rectangle,
        ),
      ),
      eventLoader: (day) {
        return _bookedDates.contains(day) ? [1] : [];
      },
      rangeStartDay: _fromDate,
      rangeEndDay: _toDate,
    );
  }

  Widget _buildLegend() {
    return Container(
      color: Colors.grey[850],
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(Colors.lightBlue, '空きあり'),
          _buildLegendItem(Colors.red.shade100, '空きなし'),
          _buildLegendItem(Colors.grey, '予約不可'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          color: color,
        ),
        const SizedBox(width: 4), 
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('個別に期間を設定する'),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const Text(
                '数量',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4), 
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.machineName,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              _buildDateRow(),
              const SizedBox(height: 20),
              Expanded(child: _buildCalendar()),
              const SizedBox(height: 4),
              _buildLegend(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  onPressed: _canAddToCart ? () {
                    // Return the selected dates and cart item details
                    Navigator.of(context).pop({
                      'deviceId': widget.deviceId,
                      'name': widget.machineName,
                      'price': widget.price,
                      'quantity': widget.quantity,
                      'startDate': _fromDate,
                      'endDate': _toDate,
                      'duration': _toDate!.difference(_fromDate!).inDays + 1,
                    });
                  } : null,
                  child: const Text('カートに入れる'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}