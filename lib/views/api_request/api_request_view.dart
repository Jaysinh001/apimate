import 'package:apimate/bloc/api_reqiest_bloc/api_request_bloc.dart';
import 'package:apimate/config/components/my_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../config/components/my_navbar.dart';
import '../../config/components/my_text.dart';

class ApiRequestView extends StatefulWidget {
  const ApiRequestView({super.key});

  @override
  State<ApiRequestView> createState() => _ApiRequestViewState();
}

class _ApiRequestViewState extends State<ApiRequestView> {
  late ApiRequestBloc apiRequestBloc;

  @override
  void initState() {
    super.initState();

    apiRequestBloc = context.read<ApiRequestBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Nav Bar
            MyNavbar(
              title: "Api Request",
              trailing: PopupMenuButton(
                icon: Icon(Icons.color_lens_rounded),
                onSelected: (value) {
                  context.read<ThemeBloc>().add(ChangeTheme(theme: value));
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: ThemeNames.dracula,
                        child: MyText.bodyMedium(
                          ThemeNames.dracula.name.toString(),
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeNames.gruvbox,
                        child: MyText.bodyMedium(
                          ThemeNames.gruvbox.name.toString(),
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeNames.monokai,
                        child: MyText.bodyMedium(
                          ThemeNames.monokai.name.toString(),
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeNames.nord,
                        child: MyText.bodyMedium(
                          ThemeNames.nord.name.toString(),
                        ),
                      ),
                      PopupMenuItem(
                        value: ThemeNames.solarized,
                        child: MyText.bodyMedium(
                          ThemeNames.solarized.name.toString(),
                        ),
                      ),
                    ],
              ),
            ),

            BlocBuilder<ApiRequestBloc, ApiRequestState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: MyBtn(
                        title: "GET",
                        onBtnTap: () {
                          apiRequestBloc.add(
                            ToggleRequestType(isGetRequest: true),
                          );
                          
                        },
                      ),
                    ),
                    Expanded(
                      child: MyBtn(
                        title: "POST",
                        onBtnTap: () {
                          apiRequestBloc.add(
                            ToggleRequestType(isGetRequest: false),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
