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
import '../../config/routes/routes_name.dart';
import '../../config/theme/color/colors.dart';
import '../../config/utility/screen_config.dart';
import '../../config/utility/utility.dart';
import '../../domain/model/get_api_list_model.dart';

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
  final paramsController = TextEditingController();
  final authController = TextEditingController();
  final headersController = TextEditingController();
  final payloadController = TextEditingController();

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

    return Scaffold(
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
            if (state.apiRequestStatus == ApiRequestStatus.success &&
                state.response != null) {
              Utility.hideFullScreenLoader(context: context);

              await Future.delayed(Durations.medium4);
              Navigator.pushNamed(
                context,
                RoutesName.apiResponseView,
                arguments: state.response,
              );
            }

            if (state.apiRequestStatus == ApiRequestStatus.error &&
                state.message != null) {
              Utility.hideFullScreenLoader(context: context);
              Utility.showToastMessage(state.message ?? '', context);
            }
            if (state.apiRequestStatus == ApiRequestStatus.sendingRequest) {
              Utility.showFullScreenLoader(context: context);
            }
          },
          child: Column(
            children: [
              // Nav Bar
              MyNavbar(
                title: "Api Request",
                trailing: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: GestureDetector(
                    child: MyText.bodyLarge(
                      "SAVE",
                      style: TextStyle(
                        color:
                            AppColors()
                                .getCurrentColorScheme(context: context)
                                .primary,
                      ),
                    ),
                  ),
                ),
              ),

              // API Request Type Toggle button
              Padding(
                padding: screenConfig.paddingH,
                child: BlocBuilder<ApiRequestBloc, ApiRequestState>(
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
                                state.isGetRequest ? null : Colors.transparent,
                            titleColor:
                                state.isGetRequest
                                    ? null
                                    : AppColors()
                                        .getCurrentColorScheme(context: context)
                                        .primary,
                          ),
                        ),
                        Expanded(
                          child: MyBtn(
                            title: "POST",
                            titleColor:
                                state.isGetRequest
                                    ? AppColors()
                                        .getCurrentColorScheme(context: context)
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
                    ParamsView(controller: paramsController),
                    AuthorizationView(controller: authController),
                    HeadersView(controller: headersController),
                    BodyView(controller: payloadController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
