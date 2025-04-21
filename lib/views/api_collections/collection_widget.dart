import 'package:apimate/config/utility/screen_config.dart';
import 'package:flutter/material.dart';

class CollectionTile extends StatelessWidget {
  final VoidCallback? onCollectionTap;
  final String name;

  const CollectionTile({super.key, this.onCollectionTap, required this.name});

  @override
  Widget build(BuildContext context) {
    final ScreenConfig screenConfig = ScreenConfig(context);
    return Padding(
      padding: screenConfig.padding,
      child: GestureDetector(
        onTap: onCollectionTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
