import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/request_client_bloc/request_client_bloc.dart';
import 'request_client_tabs.dart';

class RequestActionBar extends StatelessWidget {
    final TabController controller;

  const RequestActionBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: const Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ResolvedUrlEditableField(),
          const SizedBox(height: 8),
          const _SendButton(),
          const SizedBox(height: 8),
          RequestTabs(controller: controller,), // 👈 Tabs moved here
        ],
      ),
    );
  }
}

class _ResolvedUrlEditableField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestClientBloc, RequestClientState>(
      buildWhen: (p, c) => p.draft?.rawUrl != c.draft?.rawUrl,
      builder: (context, state) {
        final controller = TextEditingController(
          text: state.draft?.rawUrl ?? '',
        );

        return TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Resolved URL',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context.read<RequestClientBloc>().add(
              UpdateResolvedUrl(value), // 🔑 new event
            );
          },
        );
      },
    );
  }
}


class _SendButton extends StatelessWidget {
  const _SendButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestClientBloc, RequestClientState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status || prev.draft != curr.draft,
      builder: (context, state) {
        final bool isSending =
            state.status == RequestClientStatus.sending;

        final bool canSend =
            state.status == RequestClientStatus.ready ||
            state.status == RequestClientStatus.success ||
            state.status == RequestClientStatus.error;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: (!canSend || isSending)
                  ? null
                  : () {
                      context
                          .read<RequestClientBloc>()
                          .add(const SendRequest());
                    },
              child: isSending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}


