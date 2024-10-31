import 'package:flutter/material.dart';

class GridToggleButton extends StatefulWidget {
  final bool isGridView;
  final ValueChanged<bool> onToggle;

  const GridToggleButton({
    super.key,
    required this.isGridView,
    required this.onToggle,
  });

  @override
  _GridToggleButtonState createState() => _GridToggleButtonState();
}

class _GridToggleButtonState extends State<GridToggleButton> {
  @override
  Widget build(BuildContext context) {
    // Return an empty widget for now to hide the button
    return const SizedBox.shrink();
  }
}

/*return Container(
      decoration: BoxDecoration(
        color: Color(0xFFECE8E8),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
        ),
        onPressed: () {
          widget.onToggle(!widget.isGridView);
        },
        child: Text(
          '表示切替',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black, // Text color
          ),
        ),
      ),
    );
  }
}*/
