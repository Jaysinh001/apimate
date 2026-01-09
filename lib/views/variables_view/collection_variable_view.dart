import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/variable_bloc/variable_bloc.dart';
import '../../domain/model/variable_model/collection_variable_model.dart';
import '../../domain/repository/variable_repo/variable_repo.dart';

class CollectionVariablesView extends StatefulWidget {
  final int collectionID;

  const CollectionVariablesView({super.key, required this.collectionID});

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
    return BlocProvider(
      create:
          (_) => CollectionVariablesBloc(repo: CollectionVariablesRepo())
            ..add(LoadCollectionVariables(collectionID: widget.collectionID)),
      child: Scaffold(
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
            _CollectionVariablesTab(collectionID: widget.collectionID),
            const _ComingSoonTab(),
            const _ComingSoonTab(),
          ],
        ),
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
                _showAddVariableDialog(context, collectionID);
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Variable'),
            ),
          ),
        ),

        // Variables list
        Expanded(
          child: BlocBuilder<CollectionVariablesBloc, CollectionVariablesState>(
            builder: (context, state) {
              if (state.status == CollectionVariablesStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == CollectionVariablesStatus.error) {
                return Center(
                  child: Text(state.message ?? 'Something went wrong'),
                );
              }

              if (state.variables.isEmpty) {
                return const Center(child: Text('No variables added yet'));
              }

              return ListView.separated(
                itemCount: state.variables.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final variable = state.variables[index];
                  return _VariableRow(variable: variable);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VariableRow extends StatefulWidget {
  final CollectionVariable variable;

  const _VariableRow({required this.variable});

  @override
  State<_VariableRow> createState() => _VariableRowState();
}

class _VariableRowState extends State<_VariableRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.variable.value ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.variable.key,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Value',
        ),
        onSubmitted: (value) {
          context.read<CollectionVariablesBloc>().add(
            UpdateCollectionVariable(
              variableID: widget.variable.id,
              value: value,
            ),
          );
        },
      ),
      trailing: Switch(
        value: widget.variable.isActive,
        onChanged: (value) {
          context.read<CollectionVariablesBloc>().add(
            ToggleCollectionVariable(
              variableID: widget.variable.id,
              isActive: value,
            ),
          );
        },
      ),
    );
  }
}

void _showAddVariableDialog(BuildContext context, int collectionID) {
  final keyController = TextEditingController();
  final valueController = TextEditingController();

  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text('Add Variable'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: keyController,
                decoration: const InputDecoration(labelText: 'Key'),
              ),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(labelText: 'Value'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (keyController.text.trim().isEmpty) return;

                context.read<CollectionVariablesBloc>().add(
                  AddCollectionVariable(
                    collectionID: collectionID,
                    key: keyController.text.trim(),
                    value: valueController.text,
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
  );
}

class _ComingSoonTab extends StatelessWidget {
  const _ComingSoonTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Coming soon', style: TextStyle(fontSize: 16)),
    );
  }
}
