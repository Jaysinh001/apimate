import 'package:apimate/bloc/api_request_bloc/api_request_bloc.dart';
import 'package:apimate/config/components/my_btn.dart';
import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/config/components/my_textfield.dart';
import 'package:apimate/views/api_request/authorization_view.dart';
import 'package:apimate/views/api_request/body_view.dart';
import 'package:apimate/views/api_request/headers_view.dart';
import 'package:apimate/views/api_request/params_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/components/my_navbar.dart';
import '../../config/components/my_text.dart';
import '../../config/routes/routes_name.dart';
import '../../config/theme/color/colors.dart';
import '../../config/utility/screen_config.dart';
import '../../config/utility/utility.dart';
import '../../domain/model/get_api_list_model.dart';
import '../../main.dart';

class ApiRequestView extends StatefulWidget {
  final GetApiListModel? selectedApi;
  const ApiRequestView({super.key, this.selectedApi});

  @override
  State<ApiRequestView> createState() => _ApiRequestViewState();
}

class _ApiRequestViewState extends State<ApiRequestView>
    with SingleTickerProviderStateMixin {
  late ApiRequestBloc apiRequestBloc;
  late TabController tabController;

  final apiController = TextEditingController();
  final authController = TextEditingController();
  final payloadController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    apiRequestBloc = context.read<ApiRequestBloc>();
    tabController = TabController(vsync: this, length: 4);

    // assigning the value to respective fields if apiData is not null
    if (widget.selectedApi != null) {
      Utility.showLog("selected api not null");

      apiRequestBloc.add(LoadSelectedApiData(api: widget.selectedApi));
      apiController.text = widget.selectedApi?.url ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScreenConfig screenConfig = ScreenConfig(context);

    return PopScope(
      canPop: widget.selectedApi?.name?.toLowerCase() != "untitled request",
      onPopInvokedWithResult: (didPop, result) {
        Utility.showLog("didPop : $didPop  ::: result : $result");

        if (!didPop) {
          showDialog(
            context: context,
            builder:
                (context) => SaveApiDialog(
                  controller: nameController,
                  onCancelTap: () {
                    // Pop Dialog and screen
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  onSaveTap: () {
                    if (nameController.text.isNotEmpty) {
                      context.read<ApiRequestBloc>().add(
                        SaveApiName(
                          name: nameController.text,
                          apiID: widget.selectedApi?.id ?? 0,
                        ),
                      );
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                ),
          );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<ApiRequestBloc>().add(SendApiRequest());
          },
          label: MyText.bodyMedium("SEND"),
          icon: Icon(Icons.send_rounded),
        ),
        body: SafeArea(
          child: BlocListener<ApiRequestBloc, ApiRequestState>(
            listener: (context, state) async {
              if (state.apiRequestStatus == ApiRequestStatus.requestSuccess &&
                  state.response != null) {
                Utility.hideFullScreenLoader(context: context);

                // await Future.delayed(Durations.medium4);
                Navigator.pushNamed(
                  context,
                  RoutesName.apiResponseView,
                  arguments: state.response,
                );
              }

              if (state.apiRequestStatus == ApiRequestStatus.requestFailed &&
                  state.message != null) {
                Utility.hideFullScreenLoader(context: context);
                Utility.showToastMessage(state.message ?? '', context);
              }
              if (state.apiRequestStatus == ApiRequestStatus.sendingRequest) {
                Utility.showFullScreenLoader(context: context);
              }

              if (state.apiRequestStatus == ApiRequestStatus.updated &&
                  state.response != null) {
                Utility.showToastMessage(state.message ?? '', context);
              }
            },
            child: Column(
              children: [
                // Nav Bar
                BlocBuilder<ApiRequestBloc, ApiRequestState>(
                  builder: (context, state) {
                    return MyNavbar(
                      titleWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText.bodyLarge(
                            state.apiName,
                            // widget.selectedApi?.name ?? '',
                            fontWeightType: FontWeightType.bold,
                            // style: titleStyle ?? const TextStyle(fontSize: 20),
                          ),
                          MyGap(gap: 4),
                          GestureDetector(
                            onTap: () {
                              nameController.text = state.apiName;

                              showDialog(
                                context: context,
                                builder:
                                    (context) => SaveApiDialog(
                                      controller: nameController,
                                      onCancelTap: () {
                                        Navigator.pop(context);
                                      },
                                      onSaveTap: () {
                                        if (nameController.text.isNotEmpty) {
                                          context.read<ApiRequestBloc>().add(
                                            SaveApiName(
                                              name: nameController.text,
                                              apiID:
                                                  widget.selectedApi?.id ?? 0,
                                            ),
                                          );
                                          Navigator.pop(context, true);
                                        }
                                      },
                                    ),
                              );

                              // .then((val) {
                              //   if (val == true) {
                              //     context.read<ApiRequestBloc>().add(
                              //       LoadSelectedApiData(
                              //         name: nameController.text,
                              //       ),
                              //     );
                              //   }
                              // }
                              // );
                            },
                            child: Icon(
                              Icons.edit_note_rounded,
                              size: 20,
                              color: currentTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: GestureDetector(
                          onTap: () {
                            context.read<ApiRequestBloc>().add(
                              SaveApiToLocalDB(
                                apiID: widget.selectedApi?.id ?? 0,
                              ),
                            );
                          },
                          child: MyText.bodyLarge(
                            "SAVE",
                            style: TextStyle(
                              color:
                                  currentTheme
                                      .primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // API Request Type Toggle button
                Padding(
                  padding: screenConfig.paddingH,
                  child: BlocBuilder<ApiRequestBloc, ApiRequestState>(
                    buildWhen:
                        (previous, current) =>
                            previous.isGetRequest != current.isGetRequest,
                    builder: (context, state) {
                      Utility.showLog("isGetRequest :: ${state.isGetRequest}");
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
                                  state.isGetRequest
                                      ? null
                                      : Colors.transparent,
                              titleColor:
                                  state.isGetRequest
                                      ? null
                                      : AppColors()
                                          .getCurrentColorScheme(
                                            context: context,
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
                                            context: context,
                                          )
                                          .primary
                                      : null,
                              onBtnTap: () {
                                apiRequestBloc.add(
                                  ToggleRequestType(isGetRequest: false),
                                );
                              },
                              btnColor:
                                  state.isGetRequest
                                      ? Colors.transparent
                                      : null,
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
                    shouldValidate: false,
                    onChanged: (value) {
                      apiRequestBloc.add(ApiTextChanged(api: value));
                    },
                  ),
                ),

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
                      ParamsView(apiID: widget.selectedApi?.id ?? 0),
                      AuthorizationView(),
                      HeadersView(apiID: widget.selectedApi?.id ?? 0),
                      BodyView(controller: payloadController),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SaveApiDialog extends StatelessWidget {
  final VoidCallback onCancelTap;
  final VoidCallback onSaveTap;
  final TextEditingController controller;
  SaveApiDialog({
    super.key,
    required this.onCancelTap,
    required this.onSaveTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Optional: You can set a shape for the dialog if you want rounded corners or a custom shape.
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(10.0),
      // ),s
      child: Padding(
        padding: const EdgeInsets.all(
          20.0,
        ), // Add some padding around the content
        child: Column(
          mainAxisSize:
              MainAxisSize
                  .min, // This is crucial for wrapping content vertically
          children: [
            MyText.bodyMedium(
              'Do You Want To Change Request Name?',
              textAlign: TextAlign.center,
            ),
            MyGap(gap: 10),
            MyTextfield(hint: "Enter Name", controller: controller),
            MyGap(gap: 16),

            Row(
              children: [
                Expanded(
                  child: MyBtn(
                    onBtnTap: onCancelTap,
                    title: "Cancel",
                    btnColor:
                        AppColors()
                            .getCurrentColorScheme(context: context)
                            .borderColor,
                  ),
                ),
                MyGap(gap: 12),
                Expanded(
                  child: MyBtn(
                    onBtnTap: onSaveTap,
                    title: "Save",
                    btnColor:
                        AppColors()
                            .getCurrentColorScheme(context: context)
                            .primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
