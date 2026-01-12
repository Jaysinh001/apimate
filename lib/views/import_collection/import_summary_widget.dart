import 'package:apimate/config/theme/color/colors.dart';
import 'package:flutter/material.dart';

import '../../config/utility/utility.dart';
import '../../domain/model/import_collection_model/preview_node_model.dart';
import '../../main.dart';

class ImportSummary extends StatelessWidget {
  final int folderCount;
  final int requestCount;

  const ImportSummary({
    super.key,
    required this.folderCount,
    required this.requestCount,
  });

  @override
  Widget build(BuildContext context) {
    Utility.showLog("build ImportSummary");
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: currentTheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SummaryItem(label: "Folders", value: folderCount),
          _SummaryItem(label: "Requests", value: requestCount),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final int value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: currentTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class PreviewTreeNode extends StatelessWidget {
  final ImportPreviewNode node;

  const PreviewTreeNode({super.key, required this.node});

  @override
  Widget build(BuildContext context) {
    // 📁 Folder
    if (node.type == PreviewNodeType.folder) {
      return ExpansionTile(
        leading: const Icon(Icons.folder),
        title: Text(node.name),
        children:
            node.children
                ?.map((child) => PreviewTreeNode(node: child))
                .toList() ??
            [],
      );
    }

    // 🔗 Request
    return ListTile(
      leading: _MethodBadge(method: node.method ?? 'UNKNOWN'),
      title: Text(node.name),
      dense: true,
    );
  }
}

class _MethodBadge extends StatelessWidget {
  final String method;

  const _MethodBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    Color color;

    color = Utility.getMethodColor(method);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        method,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
