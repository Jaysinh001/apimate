import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoDataWidget extends StatelessWidget {
  final String? title;
  final String? iconPath;
  final double? iconSize;

  const NoDataWidget({super.key, this.title, this.iconPath, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final double actualIconSize = iconSize ?? 100.0;

    // Use a LayoutBuilder to get the constraints of the parent widget.
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          // Use SingleChildScrollView as the child of RefreshIndicator
          physics:
              const AlwaysScrollableScrollPhysics(), // Make it always scrollable
          child: ConstrainedBox(
            // Constrain the height of the Column
            constraints: BoxConstraints(
              minHeight:
                  constraints
                      .maxHeight, // Ensure the Column takes up the entire available height.
              minWidth: constraints.maxWidth,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (iconPath != null)
                    SvgPicture.asset(
                      iconPath!,
                      height: actualIconSize,
                      width: actualIconSize,
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.srcIn,
                      ),
                    )
                  else
                    Icon(
                      Icons.search_off,
                      size: actualIconSize,
                      color: Colors.grey,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    title ?? "No Data Available",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
