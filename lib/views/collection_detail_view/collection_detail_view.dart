import 'dart:developer';

import 'package:apimate/config/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/collection_detail_bloc/collection_detail_bloc.dart';
import '../../config/utility/file_export_helper.dart';
import '../../domain/model/collection_detail_model/collection_explorer_node.dart';
import '../../domain/repository/export/postman_export_repo.dart';
import '../variables_view/collection_variable_view.dart';

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
          actions: [
            BlocBuilder<CollectionDetailBloc, CollectionDetailState>(
              builder: (context, state) {
                return PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'add_folder') {
                      showFolderSheet(
                        context: context,
                        collectionId: widget.collectionID,
                        parentFolderId: null,
                      );
                    } else if (v == 'add_request') {
                      showRequestSheet(
                        context: context,
                        collectionId: widget.collectionID,
                        folderId: null,
                      );
                    } else if (v == 'variables') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CollectionVariablesView(
                                collectionID: widget.collectionID,
                              ),
                        ),
                      );
                    } else if (v == 'export_collection') {
                      try {
                        final exportRepo = PostmanExportRepo();

                        // 1️⃣ Generate Postman JSON
                        final json = await exportRepo.exportCollection(
                          widget.collectionID,
                        );

                        // 2️⃣ Save + Share
                        await FileExportHelper.saveAndShareFile(
                          fileName:
                              'collection_${widget.collectionID}.postman_collection.json',
                          content: json,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Export successful')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Export failed: $e')),
                        );
                      }
                    } else if (v == 'load_testing') {
                      // Navigate to Select Apis View
                      Navigator.pushNamed(
                        context,
                        RoutesName.selectApisView,
                        arguments: state.explorerTree,
                      );
                    }
                  },
                  icon: Icon(Icons.settings_rounded),
                  itemBuilder:
                      (_) => const [
                        PopupMenuItem(
                          value: 'add_folder',
                          child: ListTile(
                            leading: Icon(Icons.folder_rounded),
                            title: Text("Add Folder At Root"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'add_request',
                          child: ListTile(
                            leading: Icon(Icons.add_link_rounded),

                            title: Text('Add Request At Root'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'variables',
                          child: ListTile(
                            leading: Icon(Icons.tune_rounded),
                            title: Text("Variables"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'export_collection',
                          child: ListTile(
                            leading: Icon(Icons.sim_card_download_rounded),
                            title: Text("Export Collection"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'load_testing',
                          child: ListTile(
                            leading: Icon(Icons.speed_rounded),
                            title: Text("Load Testing"),
                          ),
                        ),
                      ],
                );
              },
            ),
          ],
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
                  children:
                      state.explorerTree
                          .map(
                            (node) => _ExplorerNodeWidget(
                              node: node,
                              collectionID: widget.collectionID,
                            ),
                          )
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
  final int collectionID;
  // padding field is used for generating the tab space at every level. We have used the Recursive method by adding 12 in previous value
  final double padding;

  const _ExplorerNodeWidget({
    required this.node,
    required this.collectionID,
    this.padding = 12,
  });

  @override
  Widget build(BuildContext context) {
    // 📁 Folder
    if (node.isFolder) {
      return ExpansionTile(
        tilePadding: EdgeInsets.only(left: padding),
        leading: const Icon(Icons.folder),
        title: Text(node.name),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'add_folder') {
              showFolderSheet(
                context: context,
                collectionId: collectionID,
                parentFolderId: node.id,
              );
            } else if (v == 'add_request') {
              showRequestSheet(
                context: context,
                collectionId: collectionID,
                folderId: node.id,
              );
            } else if (v == 'edit') {
              showFolderSheet(
                context: context,
                collectionId: collectionID,
                folderId: node.id,
                initialName: node.name,
              );
            }
          },
          icon: Icon(Icons.more_vert_rounded),
          itemBuilder:
              (_) => const [
                PopupMenuItem(value: 'add_folder', child: Text('Add Folder')),
                PopupMenuItem(value: 'add_request', child: Text('Add Request')),
                PopupMenuItem(value: 'edit', child: Text('Edit')),
              ],
        ),

        children:
            node.children
                .map(
                  (child) => _ExplorerNodeWidget(
                    node: child,
                    collectionID: collectionID,
                    padding: padding + 12,
                  ),
                )
                .toList(),
      );
    }

    // 🔗 Request
    return ListTile(
      contentPadding: EdgeInsets.only(left: padding , right: 12),
      leading: _MethodBadge(method: node.method ?? 'UNKNOWN'),
      title: Text(node.name),
      subtitle: Text(
        node.url ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: InkWell(
        onTap: () {
          showRequestSheet(
            context: context,
            collectionId: collectionID,
            requestId: node.id,
            initialName: node.name,
            initialMethod: node.method,
            initialUrl: node.url,
          );
        },
        child: Icon(Icons.edit_rounded, size: 18),
      ),

      onTap: () {
        // Navigate to Request Detail Screen
        Navigator.pushNamed(
          context,
          RoutesName.requestClientView,
          arguments: node.id,
        );
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

void showFolderSheet({
  required BuildContext context,
  required int collectionId,
  int? parentFolderId,
  int? folderId,
  String? initialName,
}) {
  final controller = TextEditingController(text: initialName ?? '');

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (_) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                folderId == null ? 'New Folder' : 'Edit Folder',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Folder Name'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (folderId != null)
                    TextButton(
                      onPressed: () {
                        context.read<CollectionDetailBloc>().add(
                          DeleteFolder(
                            folderId: folderId,
                            collectionID: collectionId,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      final name = controller.text.trim();
                      if (name.isEmpty) return;

                      if (folderId == null) {
                        context.read<CollectionDetailBloc>().add(
                          AddFolder(
                            collectionId: collectionId,
                            parentFolderId: parentFolderId,
                            name: name,
                          ),
                        );
                      } else {
                        context.read<CollectionDetailBloc>().add(
                          EditFolder(
                            folderId: folderId,
                            newName: name,
                            collectionID: collectionId,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Text(folderId == null ? 'Create' : 'Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
  );
}

void showRequestSheet({
  required BuildContext context,
  required int collectionId,
  int? folderId,
  int? requestId,
  String? initialName,
  String? initialMethod,
  String? initialUrl,
}) {
  final nameCtrl = TextEditingController(text: initialName ?? '');
  final urlCtrl = TextEditingController(text: initialUrl ?? '');
  String method = initialMethod ?? 'GET';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (_) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                requestId == null ? 'New Request' : 'Edit Request',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: urlCtrl,
                decoration: const InputDecoration(labelText: 'URL'),
              ),
              DropdownButtonFormField<String>(
                value: method,
                items:
                    ['GET', 'POST', 'PUT', 'DELETE']
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                onChanged: (v) => method = v!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (requestId != null)
                    TextButton(
                      onPressed: () {
                        context.read<CollectionDetailBloc>().add(
                          DeleteRequest(
                            requestId: requestId,
                            collectionID: collectionId,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (requestId == null) {
                        context.read<CollectionDetailBloc>().add(
                          AddRequest(
                            collectionId: collectionId,
                            folderId: folderId,
                            name: nameCtrl.text.trim(),
                            method: method,
                            url: urlCtrl.text.trim(),
                          ),
                        );
                      } else {
                        context.read<CollectionDetailBloc>().add(
                          EditRequest(
                            requestId: requestId,
                            name: nameCtrl.text.trim(),
                            method: method,
                            url: urlCtrl.text.trim(),
                            collectionID: collectionId,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Text(requestId == null ? 'Create' : 'Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
  );
}
