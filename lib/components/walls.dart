import 'package:flutter/material.dart';
import 'package:flutter_wall_layout/flutter_wall_layout.dart';
import '../models/wall_dim.dart';

class Wall extends StatefulWidget {
  const Wall({Key? key}) : super(key: key);

  @override
  _WallState createState() => _WallState();
}

class _WallState extends State<Wall> {
  late List<WallDim> _picturesData;

  @override
  void initState() {
    super.initState();
    _picturesData = _createPicturesData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black87,
            blurRadius: 20.0,
            offset: Offset(1.0, 5.0),
          ),
        ],
      ),
      child: WallLayout(
        stones: _buildList(),
        layersCount: 5,
        stonePadding: 0.5,
      ),
    );
  }

  List<WallDim> _createPicturesData() {
    final data = [
      {"width": 1, "height": 1},
      {"width": 2, "height": 1},
      {"width": 3, "height": 1},
      {"width": 2, "height": 1},
      {"width": 2, "height": 1},
      {"width": 1, "height": 1},
      {"width": 2, "height": 1},
      {"width": 3, "height": 1},
      {"width": 1, "height": 1},
      {"width": 2, "height": 1},
      {"width": 1, "height": 1},
      {"width": 1, "height": 1},
      {"width": 1, "height": 1},
      {"width": 3, "height": 1},
    ];

    return data.map((d) {
      return WallDim(
        width: int.parse(d["width"].toString()),
        height: int.parse(d["height"].toString()),
      );
    }).toList();
  }

  List<Stone> _buildList() {
    return _picturesData.map((d) {
      return Stone(
        id: _picturesData.indexOf(d),
        width: d.width,
        height: d.height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.0),
            color: Colors.grey.shade700,
          ),
        ),
      );
    }).toList();
  }
}
