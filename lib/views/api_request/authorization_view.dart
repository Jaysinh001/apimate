import 'package:apimate/bloc/api_reqiest_bloc/api_request_bloc.dart';
import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/config/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/utility/screen_config.dart';

class AuthorizationView extends StatefulWidget {
  final TextEditingController controller;
  const AuthorizationView({super.key, required this.controller});

  @override
  State<AuthorizationView> createState() => _AuthorizationViewState();
}

class _AuthorizationViewState extends State<AuthorizationView> {
  final List<String> authTypes = ['No Auth', 'Basic Auth', 'Bearer', 'O-auth2'];

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final bearerController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig screenConfig = ScreenConfig(context);

    return Padding(
      padding: screenConfig.paddingH,
      child: Column(
        children: [
          MyGap(gap: 16),
          BlocBuilder<ApiRequestBloc, ApiRequestState>(
            builder: (context, state) {
              return DropdownButtonFormField(
                items:
                    authTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: MyText.bodyMedium(type),
                      );
                    }).toList(),
                hint: MyText.bodyMedium("Select Authorization Type"),
                value:
                    state.selectedAuthType.isNotEmpty
                        ? state.selectedAuthType
                        : null,
                onChanged: (val) {
                  context.read<ApiRequestBloc>().add(
                    SelectAuthType(authType: val),
                  );
                },
              );
            },
          ),

          MyGap(gap: 14),

          BlocBuilder<ApiRequestBloc, ApiRequestState>(
            builder: (context, state) {
              return Visibility(
                visible: state.selectedAuthType != 'No Auth',
                child: MyText.bodyLarge(state.selectedAuthType),
              );
            },
          ),

          MyGap(gap: 14),

          BlocBuilder<ApiRequestBloc, ApiRequestState>(
            builder: (context, state) {
              return state.selectedAuthType == 'Basic Auth'
                  ? BasicAuthView(
                    usernameController: usernameController,
                    passwordController: passwordController,
                  )
                  : state.selectedAuthType == 'Bearer'
                  ? BearerView(bearerController: bearerController)
                  : state.selectedAuthType == 'O-auth2'
                  ? OAuth2View()
                  : Expanded(
                    child: Center(
                      child: MyText.bodyLarge("Select Authorization Type"),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}

class BasicAuthView extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  const BasicAuthView({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextfield(
          hint: 'Enter Username',
          controller: usernameController,
          shouldValidate: false,
          onChanged: (value) {
            context.read<ApiRequestBloc>().add(
              BasicAuthUsernameChanged(username: value),
            );
          },
        ),
        MyGap(gap: 10),
        MyTextfield(
          hint: 'Enter Password',
          shouldValidate: false,
          controller: passwordController,
          onChanged: (value) {
            context.read<ApiRequestBloc>().add(
              BasicAuthPasswordChanged(password: value),
            );
          },
        ),
        MyGap(gap: 10),
      ],
    );
  }
}

class BearerView extends StatelessWidget {
  final TextEditingController bearerController;
  const BearerView({super.key, required this.bearerController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextfield(
          hint: 'Enter Your Token',
          controller: bearerController,
          shouldValidate: false,
          onChanged: (value) {
            context.read<ApiRequestBloc>().add(
              BearerTokenChanged(token: value),
            );
          },
        ),
        MyGap(gap: 10),
      ],
    );
  }
}

class OAuth2View extends StatelessWidget {
  const OAuth2View({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextfield(
          hint: 'Enter Username',
          controller: TextEditingController(),
        ),
        MyGap(gap: 10),
        MyTextfield(
          hint: 'Enter Password',
          controller: TextEditingController(),
        ),
        MyGap(gap: 10),
      ],
    );
  }
}
