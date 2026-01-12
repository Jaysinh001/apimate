import 'package:apimate/config/components/my_btn.dart';
import 'package:apimate/main.dart';
import 'package:flutter/material.dart';

import '../../config/routes/routes_name.dart';
import '../../domain/model/collection_detail_model/collection_explorer_node.dart';

class SelectApisView extends StatefulWidget {
  final List<CollectionExplorerNode> tree;

  const SelectApisView({super.key, required this.tree});

  @override
  State<SelectApisView> createState() => _SelectApisViewState();
}

class _SelectApisViewState extends State<SelectApisView> {
  final Set<int> _selectedRequestIds = {};
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: const Text('Select APIs')),
      body: Column(
        children: [
          // =============================
          // SEARCH
          // =============================
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
              decoration: InputDecoration(hintText: 'Search APIs...'),
            ),
          ),

          // =============================
          // TREE LIST
          // =============================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children:
                  widget.tree
                      .map(
                        (node) => _TreeNodeWidget(
                          node: node,
                          search: _search,
                          selectedIds: _selectedRequestIds,
                          onToggle: _onToggle,
                        ),
                      )
                      .toList(),
            ),
          ),

          // =============================
          // FOOTER
          // =============================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: currentTheme.selection,
              border: Border(top: BorderSide(color: currentTheme.borderColor)),
            ),
            child: Row(
              children: [
                Text('Selected: ${_selectedRequestIds.length} APIs'),
                const Spacer(),

                MyBtn(
                  onBtnTap:
                      _selectedRequestIds.isEmpty
                          ? null
                          : () => _onContinue(context),
                  isExpanded: false,
                  title: "Continue",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // TOGGLE SELECTION
  // ===============================================================
  void _onToggle(int requestId, bool selected) {
    setState(() {
      if (selected) {
        _selectedRequestIds.add(requestId);
      } else {
        _selectedRequestIds.remove(requestId);
      }
    });
  }

  // ===============================================================
  // CONTINUE → START CONFIG
  // ===============================================================
  void _onContinue(BuildContext context) {
    // You will load RequestExecutionInput from DB using these IDs later
    final selectedIds = _selectedRequestIds.toList();

    // Example: navigate to load test config screen
    // Navigate to Select Apis View
    Navigator.pushNamed(
      context,
      RoutesName.loadTestConfigView,
      arguments: selectedIds,
    );
  }
}

class _TreeNodeWidget extends StatelessWidget {
  final CollectionExplorerNode node;
  final String search;
  final Set<int> selectedIds;
  final void Function(int id, bool selected) onToggle;

  const _TreeNodeWidget({
    required this.node,
    required this.search,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (!_matchesSearch(node, search)) return const SizedBox.shrink();

    if (node.isFolder) {
      return _FolderTile(
        title: node.name,
        children:
            node.children
                .map(
                  (c) => _TreeNodeWidget(
                    node: c,
                    search: search,
                    selectedIds: selectedIds,
                    onToggle: onToggle,
                  ),
                )
                .toList(),
      );
    }

    // =============================
    // API / REQUEST ITEM
    // =============================
    final bool isSelected = selectedIds.contains(node.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),

      child: CheckboxListTile(
        value: isSelected,
        onChanged: (v) => onToggle(node.id, v ?? false),

        title: Text(node.name),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  bool _matchesSearch(CollectionExplorerNode node, String search) {
    if (search.isEmpty) return true;
    if (node.name.toLowerCase().contains(search)) return true;
    return node.children.any((c) => _matchesSearch(c, search));
  }
}

class _FolderTile extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FolderTile({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: ExpansionTile(
        backgroundColor: currentTheme.cardBackground,

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 0, 8),
        children: children,
      ),
    );
  }
}
