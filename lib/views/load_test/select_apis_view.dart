import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../domain/model/collection_detail_model/collection_explorer_node.dart';
import 'load_test_config_view.dart';

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
      backgroundColor: const Color(0xFF0F1220),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F1220),
        title: const Text('Select APIs'),
      ),
      body: Column(
        children: [
          // =============================
          // SEARCH
          // =============================
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search APIs...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: const Color(0xFF141834),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // =============================
          // TREE LIST
          // =============================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: widget.tree
                  .map((node) => _TreeNodeWidget(
                        node: node,
                        search: _search,
                        selectedIds: _selectedRequestIds,
                        onToggle: _onToggle,
                      ))
                  .toList(),
            ),
          ),

          // =============================
          // FOOTER
          // =============================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFF141834),
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              children: [
                Text(
                  'Selected: ${_selectedRequestIds.length} APIs',
                  style: const TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _selectedRequestIds.isEmpty
                      ? null
                      : () => _onContinue(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C9CFF),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Continue'),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoadTestConfigView(
          selectedRequestIds: selectedIds,
        ),
      ),
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
        children: node.children
            .map((c) => _TreeNodeWidget(
                  node: c,
                  search: search,
                  selectedIds: selectedIds,
                  onToggle: onToggle,
                ))
            .toList(),
      );
    }

    // =============================
    // API / REQUEST ITEM
    // =============================
    final bool isSelected = selectedIds.contains(node.id);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF141834),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: (v) => onToggle(node.id, v ?? false),
        activeColor: const Color(0xFF6C9CFF),
        title: Text(
          node.name,
          style: const TextStyle(color: Colors.white),
        ),
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

  const _FolderTile({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: const Color(0xFF141834),
      backgroundColor: const Color(0xFF141834),
      iconColor: Colors.white70,
      collapsedIconColor: Colors.white54,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      children: children,
    );
  }
}
