import 'package:flutter/material.dart';

class ImageGridView extends StatefulWidget {
  @override
  _ImageGridViewState createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  bool isGridView = true;

  void toggleView(bool value) {
    setState(() {
      isGridView = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridToggleButton(
          isGridView: isGridView,
          onToggle: toggleView,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: isGridView
                ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1, // Adjust this for image size
              ),
              itemCount: 20,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(5),
                  child: Image.network(
                    'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                  ),
                );
              },
            )
                : Row(
              children: List.generate(20, (index) {
                return Container(
                  width: 150, // Set a width that fits your design
                  margin: EdgeInsets.all(5),
                  child: Image.network(
                    'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}

class GridToggleButton extends StatelessWidget {
  final bool isGridView;
  final ValueChanged<bool> onToggle;

  const GridToggleButton({
    Key? key,
    required this.isGridView,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFECE8E8),
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
        ),
        onPressed: () {
          onToggle(!isGridView);
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
}