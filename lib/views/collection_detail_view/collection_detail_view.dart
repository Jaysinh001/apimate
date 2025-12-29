import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/collection_detail_bloc/collection_detail_bloc.dart';
import '../../domain/model/collection_detail_model/collection_explorer_node.dart';

class CollectionDetailView extends StatefulWidget {
  final int collectionID;
  const CollectionDetailView({super.key, required this.collectionID});

  @override
  State<CollectionDetailView> createState() => _CollectionDetailViewState();
}

class _CollectionDetailViewState extends State<CollectionDetailView> {
  final CollectionDetailBloc bloc = CollectionDetailBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(LoadCollectionDetails(collectionID: widget.collectionID));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Collection Details'),
        ),
        body: BlocBuilder<CollectionDetailBloc, CollectionDetailState>(
          builder: (context, state) {
            switch (state.status) {
              case CollectionDetailStatus.loading:
                return const Center(child: CircularProgressIndicator());

              case CollectionDetailStatus.loaded:
                if (state.explorerTree.isEmpty) {
                  return const Center(child: Text('No data found'));
                }
                return ListView(
                  children: state.explorerTree
                      .map((node) => _ExplorerNodeWidget(node: node))
                      .toList(),
                );

              case CollectionDetailStatus.error:
                return Center(
                  child: Text(state.message ?? 'Something went wrong'),
                );

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}



class _ExplorerNodeWidget extends StatelessWidget {
  final CollectionExplorerNode node;

  const _ExplorerNodeWidget({required this.node});

  @override
  Widget build(BuildContext context) {
    // 📁 Folder
    if (node.isFolder) {
      return ExpansionTile(
        leading: const Icon(Icons.folder),
        title: Text(node.name),
        children: node.children
            .map((child) => _ExplorerNodeWidget(node: child))
            .toList(),
      );
    }

    // 🔗 Request
    return ListTile(
      leading: _MethodBadge(method: node.method ?? 'UNKNOWN'),
      title: Text(node.name),
      subtitle: Text(
        node.url ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        // Future: Navigate to Request Detail Screen
        // Navigator.push(...)
      },
    );
  }
}



class _MethodBadge extends StatelessWidget {
  final String method;

  const _MethodBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    final Color color = _getMethodColor(method);

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
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.blue;
      case 'PUT':
        return Colors.orange;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

