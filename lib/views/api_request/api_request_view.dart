import 'package:apimate/bloc/api_reqiest_bloc/api_request_bloc.dart';
import 'package:apimate/config/components/my_btn.dart';
import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/config/components/my_textfield.dart';
import 'package:apimate/views/api_request/authorization_view.dart';
import 'package:apimate/views/api_request/body_view.dart';
import 'package:apimate/views/api_request/headers_view.dart';
import 'package:apimate/views/api_request/params_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../config/components/my_navbar.dart';
import '../../config/components/my_text.dart';
import '../../config/theme/color/colors.dart';
import '../../config/utility/screen_config.dart';

class ApiRequestView extends StatefulWidget {
  const ApiRequestView({super.key});

  @override
  State<ApiRequestView> createState() => _ApiRequestViewState();
}

class _ApiRequestViewState extends State<ApiRequestView>
    with SingleTickerProviderStateMixin {
  late ApiRequestBloc apiRequestBloc;
  late TabController tabController;

  final apiController = TextEditingController();
  final headersController = TextEditingController();
  final payloadController = TextEditingController();

  @override
  void initState() {
    super.initState();

    apiRequestBloc = context.read<ApiRequestBloc>();
    tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    final ScreenConfig screenConfig = ScreenConfig(context);

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

            // API Request Type Toggle button
            Padding(
              padding: screenConfig.paddingH,
              child: BlocBuilder<ApiRequestBloc, ApiRequestState>(
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
                          btnColor:
                              state.isGetRequest ? null : Colors.transparent,
                          titleColor:
                              state.isGetRequest
                                  ? null
                                  : AppColors()
                                      .getCurrentColorScheme(
                                        theme:
                                            context
                                                .read<ThemeBloc>()
                                                .state
                                                .theme,
                                      )
                                      .primary,
                        ),
                      ),
                      Expanded(
                        child: MyBtn(
                          title: "POST",
                          titleColor:
                              state.isGetRequest
                                  ? AppColors()
                                      .getCurrentColorScheme(
                                        theme:
                                            context
                                                .read<ThemeBloc>()
                                                .state
                                                .theme,
                                      )
                                      .primary
                                  : null,
                          onBtnTap: () {
                            apiRequestBloc.add(
                              ToggleRequestType(isGetRequest: false),
                            );
                          },
                          btnColor:
                              state.isGetRequest ? Colors.transparent : null,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Add Api Textfield
            Padding(
              padding: screenConfig.padding,
              child: MyTextfield(
                hint: "Enter Api",
                controller: apiController,
                onChanged: (value) {
                  apiRequestBloc.add(ApiTextChanged(api: value));
                },
              ),
            ),

            // All Row Buttons
            // Padding(
            //   padding: screenConfig.paddingH,
            //   child: Row(
            //     children: [
            //       MyBtn(title: "Params", onBtnTap: () {}),
            //       MyGap(gap: 3),
            //       MyBtn(title: "Authorization", onBtnTap: () {}),
            //       MyGap(gap: 3),
            //       MyBtn(title: "Headers", onBtnTap: () {}),
            //       MyBtn(title: "Body", onBtnTap: () {}),
            //     ],
            //   ),
            // ),
            MyGap(gap: 6),
            TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              tabs: [
                MyText.bodyLarge("Params"),
                MyText.bodyLarge("Authorization"),
                MyText.bodyLarge("Headers"),
                MyText.bodyLarge("Body"),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  ParamsView(),
                  AuthorizationView(),
                  HeadersView(),
                  BodyView(controller: payloadController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
