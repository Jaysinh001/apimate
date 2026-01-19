import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/request_client_bloc/request_client_bloc.dart';
import '../../../domain/model/request_client_model/request_auth_model.dart';

class AuthTab extends StatefulWidget {
  const AuthTab({super.key});

  @override
  State<AuthTab> createState() => _AuthTabState();
}

class _AuthTabState extends State<AuthTab> {
  late final TextEditingController usernameCtrl;

  late final TextEditingController passwordCtrl;

  late final TextEditingController tokenCtrl;

  late final TextEditingController apiKeyCtrl;
  late final TextEditingController apiValCtrl;

  @override
  void initState() {
    super.initState();

    final auth = context.read<RequestClientBloc>().state.draft?.auth;

    usernameCtrl = TextEditingController(text: auth?.username ?? '');
    passwordCtrl = TextEditingController(text: auth?.password ?? '');
    tokenCtrl = TextEditingController(text: auth?.token ?? '');
    apiKeyCtrl = TextEditingController(text: auth?.apiKey ?? '');
    apiValCtrl = TextEditingController(text: auth?.apiValue ?? '');
  }

  @override
  void didUpdateWidget(covariant AuthTab oldWidget) {
    super.didUpdateWidget(oldWidget);

    final auth = context.read<RequestClientBloc>().state.draft?.auth;

    if (usernameCtrl.text != auth?.username) {
      usernameCtrl.text = auth?.username ?? '';
    }

    if (passwordCtrl.text != auth?.password) {
      passwordCtrl.text = auth?.password ?? '';
    }

    if (tokenCtrl.text != auth?.token) {
      tokenCtrl.text = auth?.token ?? '';
    }

    if (apiKeyCtrl.text != auth?.apiKey) {
      apiKeyCtrl.text = auth?.apiKey ?? '';
    }

    if (apiValCtrl.text != auth?.apiValue) {
      apiValCtrl.text = auth?.apiValue ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestClientBloc, RequestClientState>(
      builder: (context, state) {
        final auth = state.draft?.auth ?? RequestAuth.none();

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _authTypeSelector(context, auth),
              const SizedBox(height: 12),
              _authEditor(
                context: context,
                auth: auth,
                usernameCtrl: usernameCtrl,
                passwordCtrl: passwordCtrl,
                tokenCtrl: tokenCtrl,
                apiKeyCtrl: apiKeyCtrl,
                apiValCtrl: apiValCtrl,
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _authTypeSelector(BuildContext context, RequestAuth auth) {
  return Row(
    children: [
      const Text(
        "Authorization",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const Spacer(),
      DropdownButton<AuthType>(
        value: auth.type,
        items: const [
          DropdownMenuItem(value: AuthType.none, child: Text("No Auth")),
          DropdownMenuItem(value: AuthType.bearer, child: Text("Bearer Token")),
          DropdownMenuItem(value: AuthType.apiKey, child: Text("API Key")),
          DropdownMenuItem(value: AuthType.basic, child: Text("Basic Auth")),
        ],
        onChanged: (value) {
          context.read<RequestClientBloc>().add(UpdateAuthType(value!));
        },
      ),
    ],
  );
}

Widget _authEditor({
  required BuildContext context,
  required RequestAuth auth,
  required TextEditingController usernameCtrl,
  required TextEditingController passwordCtrl,
  required TextEditingController tokenCtrl,
  required TextEditingController apiKeyCtrl,
  required TextEditingController apiValCtrl,
}) {
  switch (auth.type) {
    case AuthType.bearer:
      return _bearerAuth(context, auth, tokenCtrl);
    case AuthType.apiKey:
      return _apiKeyAuth(context, auth, apiKeyCtrl, apiValCtrl);
    case AuthType.basic:
      return _basicAuth(context, auth, usernameCtrl, passwordCtrl);
    default:
      return const SizedBox.shrink();
  }
}

Widget _bearerAuth(
  BuildContext context,
  RequestAuth auth,
  TextEditingController tokenCtrl,
) {
  return TextField(
    decoration: const InputDecoration(
      labelText: "Bearer Token",
      hintText: "Enter token",
    ),
    controller: tokenCtrl,
    onChanged: (val) {
      context.read<RequestClientBloc>().add(UpdateBearerToken(val));
    },
  );
}

Widget _apiKeyAuth(
  BuildContext context,
  RequestAuth auth,
  TextEditingController apiKeyCtrl,
  TextEditingController apiValCtrl,
) {
  return Column(
    children: [
      TextField(
        controller: apiKeyCtrl,
        decoration: const InputDecoration(labelText: "Key"),
        onChanged: (v) {
          context.read<RequestClientBloc>().add(UpdateApiKey(key: v));
        },
      ),
      const SizedBox(height: 8),
      TextField(
        controller: apiValCtrl,
        decoration: const InputDecoration(labelText: "Value"),
        onChanged: (v) {
          context.read<RequestClientBloc>().add(UpdateApiValue(value: v));
        },
      ),
      const SizedBox(height: 8),
      DropdownButton<ApiKeyLocation>(
        value: auth.apiLocation ?? ApiKeyLocation.header,
        items: const [
          DropdownMenuItem(value: ApiKeyLocation.header, child: Text("Header")),
          DropdownMenuItem(
            value: ApiKeyLocation.query,
            child: Text("Query Param"),
          ),
        ],
        onChanged: (v) {
          context.read<RequestClientBloc>().add(UpdateApiLocation(v!));
        },
      ),
    ],
  );
}

Widget _basicAuth(
  BuildContext context,
  RequestAuth auth,
  TextEditingController usernameCtrl,
  TextEditingController passwordCtrl,
) {
  return Column(
    children: [
      TextField(
        decoration: const InputDecoration(labelText: "Username"),
        controller: usernameCtrl,
        onChanged: (v) {
          context.read<RequestClientBloc>().add(UpdateBasicUsername(v));
        },
      ),
      const SizedBox(height: 8),
      TextField(
        decoration: const InputDecoration(labelText: "Password"),
        obscureText: true,
        controller: passwordCtrl,
        onChanged: (v) {
          context.read<RequestClientBloc>().add(UpdateBasicPassword(v));
        },
      ),
    ],
  );
}
