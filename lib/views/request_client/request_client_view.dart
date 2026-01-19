import 'package:apimate/views/request_client/tabs/auth_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/request_client_bloc/request_client_bloc.dart';
import '../../config/utility/pretty_json_helper.dart';
import '../../main.dart';
import 'request_actionbar_widget.dart';

class RequestClientView extends StatefulWidget {
  final int requestId;

  const RequestClientView({super.key, required this.requestId});

  @override
  State<RequestClientView> createState() => _RequestClientViewState();
}

class _RequestClientViewState extends State<RequestClientView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final RequestClientBloc bloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    bloc =
        RequestClientBloc()
          ..add(LoadRequestDetails(requestId: widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocListener<RequestClientBloc, RequestClientState>(
        listener: (context, state) {
          if (state.status == RequestClientStatus.sending) {
            _tabController.animateTo(_tabController.length -1 );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<RequestClientBloc, RequestClientState>(
              buildWhen: (p, c) => p.hasUnsavedChanges != c.hasUnsavedChanges,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Request'),
                    if (state.hasUnsavedChanges)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: currentTheme.warning,
                        ),
                      ),
                  ],
                );
              },
            ),
            actions: [
              Text("Save"),

              BlocBuilder<RequestClientBloc, RequestClientState>(
                builder: (context, state) {
                  return IconButton(
                    icon: const Icon(Icons.save),
                    onPressed:
                        state.hasUnsavedChanges
                            ? () => context.read<RequestClientBloc>().add(
                              const SaveRequestDraft(),
                            )
                            : null,
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<RequestClientBloc, RequestClientState>(
            builder: (context, state) {
              if (state.status == RequestClientStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.draft == null) {
                return const Center(child: Text('Failed to load request'));
              }

              return PopScope(
                canPop: !state.hasUnsavedChanges,
                onPopInvokedWithResult: (didPop, result) async {
                  if (didPop) return;

                  final shouldDiscard = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Unsaved changes'),
                          content: const Text(
                            'You have unsaved changes. Discard them and go back?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Discard'),
                            ),
                          ],
                        ),
                  );

                  if (shouldDiscard == true) {
                    Navigator.of(context).pop(result);
                  }
                },
                child: Column(
                  children: [
                    RequestActionBar(controller: _tabController),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          ParamsTab(),
                          AuthTab(),
                          HeadersTab(),
                          BodyTab(),
                          ResponseTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// class _ResolvedUrlPreview extends StatelessWidget {
//   final RequestClientState state;

//   const _ResolvedUrlPreview({required this.state});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Resolved URL',
//               style: TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           SelectableText(state.resolvedUrl ?? ''),
//           if (state.variableWarnings.isNotEmpty)
//             ...state.variableWarnings.map(
//               (w) => Text(
//                 '⚠ $w',
//                 style: const TextStyle(color: Colors.orange, fontSize: 12),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

class ParamsTab extends StatelessWidget {
  const ParamsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestClientBloc, RequestClientState>(
      builder: (context, state) {
        final params = state.draft!.queryParams;

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ...params.entries.map(
              (e) => _KeyValueRow(
                keyText: e.key,
                valueText: e.value,
                onChanged:
                    (k, v) => context.read<RequestClientBloc>().add(
                      UpdateQueryParam(key: k, value: v),
                    ),
                onDelete:
                    () => context.read<RequestClientBloc>().add(
                      RemoveQueryParam(key: e.key),
                    ),
              ),
            ),
            _AddRow(
              onAdd:
                  (k, v) => context.read<RequestClientBloc>().add(
                    AddQueryParam(key: k, value: v),
                  ),
            ),
          ],
        );
      },
    );
  }
}

class HeadersTab extends StatelessWidget {
  const HeadersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestClientBloc, RequestClientState>(
      builder: (context, state) {
        final headers = state.draft!.headers;

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ...headers.entries.map(
              (e) => _KeyValueRow(
                keyText: e.key,
                valueText: e.value,
                onChanged:
                    (k, v) => context.read<RequestClientBloc>().add(
                      UpdateHeader(key: k, value: v),
                    ),
                onDelete:
                    () => context.read<RequestClientBloc>().add(
                      RemoveHeader(key: e.key),
                    ),
              ),
            ),
            _AddRow(
              onAdd:
                  (k, v) => context.read<RequestClientBloc>().add(
                    AddHeader(key: k, value: v),
                  ),
            ),
          ],
        );
      },
    );
  }
}

class BodyTab extends StatefulWidget {
  const BodyTab({super.key});

  @override
  State<BodyTab> createState() => _BodyTabState();
}

class _BodyTabState extends State<BodyTab> {
  late final TextEditingController _controller;
  String _lastSyncedValue = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestClientBloc, RequestClientState>(
      buildWhen: (prev, curr) => prev.draft?.body != curr.draft?.body,
      builder: (context, state) {
        final body = state.draft?.body ?? '';

        // 🔑 Sync only if change came from Bloc, not typing
        if (body != _lastSyncedValue && _controller.text != body) {
          _controller.text = body;
          _controller.selection = TextSelection.collapsed(offset: body.length);
          _lastSyncedValue = body;
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          child: TextField(
            controller: _controller,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'Request body',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _lastSyncedValue = value;
              context.read<RequestClientBloc>().add(
                UpdateRequestBody(body: value),
              );
            },
          ),
        );
      },
    );
  }
}

class ResponseTab extends StatelessWidget {
  const ResponseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestClientBloc, RequestClientState>(
      builder: (context, state) {
        final response = state.lastResponse;

        if (response == null) {
          return const Center(child: Text('No response yet'));
        }

        final isJson = JsonPrettyHelper.isJson(response.body);
        final bodyText =
            isJson
                ? JsonPrettyHelper.prettyPrint(response.body)
                : response.body;

        final statusColor =
            response.isSuccess ? currentTheme.success : currentTheme.error;

        return Column(
          children: [
            // =======================
            // RESPONSE HEADER
            // =======================
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: currentTheme.primary)),
              ),
              child: Row(
                children: [
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      response.isSuccess ? '${response.statusCode}' : 'Error',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Time
                  Text('${response.durationMs} ms'),

                  const Spacer(),

                  const Text("Save"),
                  // Save response
                  IconButton(
                    tooltip: 'Save response',
                    icon: Icon(Icons.save),
                    onPressed: () {
                      context.read<RequestClientBloc>().add(
                        const SaveResponse(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Response saved'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),

                  const Text("Copy"),
                  // Copy button
                  IconButton(
                    tooltip: 'Copy response',
                    icon: Icon(Icons.copy),
                    onPressed:
                        response.body.isEmpty
                            ? null
                            : () {
                              Clipboard.setData(ClipboardData(text: bodyText));

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Response copied to clipboard'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                  ),
                ],
              ),
            ),

            // =======================
            // RESPONSE BODY
            // =======================
            Expanded(
              child:
                  response.body.isEmpty
                      ? const Center(child: Text('Empty response body'))
                      : SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: SelectableText(
                          bodyText,
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String keyText;
  final String valueText;
  final void Function(String key, String value) onChanged;
  final VoidCallback onDelete;

  const _KeyValueRow({
    required this.keyText,
    required this.valueText,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final keyController = TextEditingController(text: keyText);
    final valueController = TextEditingController(text: valueText);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: keyController,
            decoration: const InputDecoration(hintText: 'Key'),
            onChanged: (k) => onChanged(k, valueController.text),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: valueController,
            decoration: const InputDecoration(hintText: 'Value'),
            onChanged: (v) => onChanged(keyController.text, v),
          ),
        ),
        IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
      ],
    );
  }
}

class _AddRow extends StatelessWidget {
  final void Function(String key, String value) onAdd;

  const _AddRow({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: keyController,
            decoration: const InputDecoration(hintText: 'Key'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: valueController,
            decoration: const InputDecoration(hintText: 'Value'),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            if (keyController.text.isNotEmpty) {
              onAdd(keyController.text, valueController.text);
              keyController.clear();
              valueController.clear();
            }
          },
        ),
      ],
    );
  }
}
