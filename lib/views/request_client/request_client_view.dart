import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/request_client_bloc/request_client_bloc.dart';

class RequestClientView extends StatefulWidget {
  final int requestId;

  const RequestClientView({super.key, required this.requestId});

  @override
  State<RequestClientView> createState() => _RequestClientViewState();
}

class _RequestClientViewState extends State<RequestClientView> {
  late final RequestClientBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = RequestClientBloc()
      ..add(LoadRequestDetails(requestId: widget.requestId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Request')),
        body: BlocBuilder<RequestClientBloc, RequestClientState>(
          builder: (context, state) {
            if (state.status == RequestClientStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == RequestClientStatus.error &&
                state.lastResponse == null) {
              return Center(
                child: Text(state.message ?? 'Failed to load request'),
              );
            }

            return _RequestClientBody(state: state);
          },
        ),
      ),
    );
  }
}



class _RequestClientBody extends StatelessWidget {
  final RequestClientState state;

  const _RequestClientBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RequestInfoSection(state: state),
        _ResolvedUrlSection(state: state),
        _SendButton(state: state),
        const Divider(),
        Expanded(child: _ResponseSection(state: state)),
      ],
    );
  }
}


class _RequestInfoSection extends StatelessWidget {
  final RequestClientState state;

  const _RequestInfoSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.method ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            state.rawUrl ?? '',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}


class _ResolvedUrlSection extends StatelessWidget {
  final RequestClientState state;

  const _ResolvedUrlSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resolved URL',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          SelectableText(
            state.resolvedUrl ?? '',
            style: const TextStyle(fontSize: 13),
          ),
          if (state.variableWarnings.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...state.variableWarnings.map(
              (w) => Text(
                '⚠ $w',
                style: const TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}


class _SendButton extends StatelessWidget {
  final RequestClientState state;

  const _SendButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final isSending = state.status == RequestClientStatus.sending;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isSending
              ? null
              : () {
                  context.read<RequestClientBloc>().add(const SendRequest());
                },
          child: isSending
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send'),
        ),
      ),
    );
  }
}


class _ResponseSection extends StatelessWidget {
  final RequestClientState state;

  const _ResponseSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final response = state.lastResponse;

    if (response == null) {
      return const Center(
        child: Text(
          'No response yet',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            Text(
              response.isSuccess
                  ? 'Status: ${response.statusCode}'
                  : 'Error',
              style: TextStyle(
                color: response.isSuccess ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Text('${response.durationMs} ms'),
          ],
        ),
        const SizedBox(height: 12),

        // Headers
        ExpansionTile(
          title: const Text('Headers'),
          children: response.headers.entries
              .map(
                (e) => ListTile(
                  dense: true,
                  title: Text(e.key),
                  subtitle: Text(e.value),
                ),
              )
              .toList(),
        ),

        const SizedBox(height: 12),

        // Body
        const Text(
          'Body',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: SelectableText(
            response.body.isNotEmpty
                ? response.body
                : '(empty)',
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
