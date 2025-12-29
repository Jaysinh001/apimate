import 'package:flutter/material.dart';

class CollectionVariablesView extends StatefulWidget {
  final int collectionID;

  const CollectionVariablesView({
    super.key,
    required this.collectionID,
  });

  @override
  State<CollectionVariablesView> createState() =>
      _CollectionVariablesViewState();
}

class _CollectionVariablesViewState extends State<CollectionVariablesView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Variables'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Collection'),
            Tab(text: 'Folder'),
            Tab(text: 'Environment'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Collection Variables (active)
          _CollectionVariablesTab(collectionID: widget.collectionID),

          // Folder Variables (disabled for now)
          const _ComingSoonTab(),

          // Environment Variables (disabled for now)
          const _ComingSoonTab(),
        ],
      ),
    );
  }
}




class _CollectionVariablesTab extends StatelessWidget {
  final int collectionID;

  const _CollectionVariablesTab({required this.collectionID});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add Variable button
        Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Add Variable action
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Variable'),
            ),
          ),
        ),

        // Variable list (placeholder)
        const Expanded(
          child: Center(
            child: Text(
              'Collection variables will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}



class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Coming soon',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
