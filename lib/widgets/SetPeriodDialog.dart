import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class SetPeriodDialog extends StatefulWidget {
  final String machineName;

  const SetPeriodDialog({Key? key, required this.machineName}) : super(key: key);

  @override
  _SetPeriodDialogState createState() => _SetPeriodDialogState();
}

class _SetPeriodDialogState extends State<SetPeriodDialog> {
  DateTime? _fromDate;
  DateTime? _toDate;
  List<DateTime> _bookedDates = [
    DateTime(2024, 10, 30),
    DateTime(2024, 11, 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text('個別に期間を設定する'),
          ],
        ),
        automaticallyImplyLeading: false, // Removes the back arrow
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Set background color to white
          borderRadius: BorderRadius.circular(16), // Set the border radius
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
              const SizedBox(height: 4), // Space between title and container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light grey background for the machine name
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
              const SizedBox(height: 4), // Reduced space before legend
              _buildLegend(), // Add the legend row
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Background color
                    foregroundColor: Colors.white, // Text color
                  ),
                  onPressed: () {
                    // Handle Add to cart action here
                  },
                  child: const Text('カートに入れる'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
            '$label: ${date != null ? DateFormat.yMd().format(date) : '未選択'}',
            style: const TextStyle(fontSize: 14),
          ),
          Icon(Icons.calendar_today),
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
        defaultDecoration: BoxDecoration(
          color: Colors.lightBlue,
          shape: BoxShape.rectangle,
        ),
        weekendDecoration: BoxDecoration(
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
      color: Colors.grey[850], // Dark grey background
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Minimized vertical padding
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
          width: 14, // Minimized size
          height: 14, // Minimized size
          color: color,
        ),
        const SizedBox(width: 4), // Reduced space between color box and text
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}