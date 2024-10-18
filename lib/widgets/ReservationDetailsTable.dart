import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/ReservationDetailsDialog.dart';

class ReservationDetailsTable extends StatelessWidget {
  final List<Map<String, dynamic>> reservations;

  const ReservationDetailsTable({
    Key? key,
    required this.reservations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
          columnWidths: const {
            0: FlexColumnWidth(2), // More space for reservation number
            1: FlexColumnWidth(3), // More space for usage period
            2: FlexColumnWidth(1), // Less space for quantity
            3: FlexColumnWidth(1), // Space for the button
          },
        children: [
          // Header Row
          TableRow(
            children: [
              _buildHeaderCell('予約No.'),
              _buildHeaderCell('利用期間'),
              _buildHeaderCell('数量'),
              _buildHeaderCell('詳細'),
            ],
          ),
          ..._buildDataRows(context), // Build data rows from reservations list
        ],
    );
  }

  List<TableRow> _buildDataRows(BuildContext context) {
    return reservations.map((reservation) {
      return TableRow(
        children: [
          _buildTableCell(reservation['id'].toString()),
          _buildTableCell(_formatUsagePeriod('${reservation['start_date']} ~ \n${reservation['end_date']}')),
          _buildTableCell(reservation['quantity'].toString()),
          _buildButtonCell(context, reservation), 
        ],
      );
    }).toList();
  }

  Widget _buildHeaderCell(String header) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Center(
        child: Text(
          header,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildTableCell(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildButtonCell(BuildContext context, Map<String, dynamic> reservation) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2.0),
          ),
          child: GestureDetector(
            onTap: () {
              // Open dialog with reservation details
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ReservationDetailsDialog(
                    reservationNumber: reservation['id'],
                    usagePeriod: '${reservation['start_date']} ~ \n${reservation['end_date']}',
                    quantity: reservation['quantity'].toString(),
                    total: '¥${reservation['price']}',
                    consumptionTax: '¥${reservation['tax']}',
                    machineName: reservation['device_name'],
                    numberOfDays: reservation['duration'],
                    period: 'Daily',
                    reservationDate: DateTime.parse(reservation['reserve_date']),
                    subTotal: '¥${reservation['sub_total']}',
                    unitPrice: '¥${reservation['unit_price']}',
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.more_horiz),
            ),
          ),
        ),
      ),
    );
  }

  String _formatUsagePeriod(String period) {
    return period.replaceAll('-', '/');
  }
}
