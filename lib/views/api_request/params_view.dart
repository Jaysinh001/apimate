import 'package:apimate/domain/model/params_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/api_request_bloc/api_request_bloc.dart';
import '../../config/components/my_bottomsheet.dart';
import '../../config/components/my_btn.dart';
import '../../config/components/my_gap.dart';
import '../../config/components/my_text.dart';
import '../../config/components/my_textfield.dart';
import '../../config/theme/color/colors.dart';
import '../../config/utility/screen_config.dart';
import '../../config/utility/utility.dart';

class ParamsView extends StatefulWidget {
  final int apiID;
  const ParamsView({super.key, required this.apiID});

  @override
  State<ParamsView> createState() => _ParamsViewState();
}

class _ParamsViewState extends State<ParamsView> {
  @override
  void initState() {
    super.initState();

    context.read<ApiRequestBloc>().add(GetApiParams(apiID: widget.apiID));
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig screenConfig = ScreenConfig(context);

    return BlocListener<ApiRequestBloc, ApiRequestState>(
      listener: (context, state) {
        if (state.apiRequestStatus == ApiRequestStatus.created) {
          Navigator.pop(context);
        }
      },
      child: Column(
        children: [
          // Add new params row
          Padding(
            padding: screenConfig.padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText.bodyLarge("Add New Params : "),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder:
                          (context) =>
                              AddParamsBottomSheet(apiID: widget.apiID),
                    );
                  },
                  child: Icon(
                    Icons.add_circle_outline_rounded,
                    color:
                        AppColors()
                            .getCurrentColorScheme(context: context)
                            .primary,
                  ),
                ),
              ],
            ),
          ),

          Flexible(
            child: BlocBuilder<ApiRequestBloc, ApiRequestState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.params.length,
                  itemBuilder:
                      (context, index) => ParamsListItem(
                        screenConfig: screenConfig,
                        params: state.params[index],
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ParamsListItem extends StatelessWidget {
  final ScreenConfig screenConfig;
  final ParamsListModel params;
  const ParamsListItem({
    super.key,
    required this.screenConfig,

    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(12),
      margin: screenConfig.padding,
      decoration: BoxDecoration(
        color: AppColors().getCurrentColorScheme(context: context).surface,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),

      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder:
                (context) => AddParamsBottomSheet(
                  paramsKey: params.key ?? "",
                  paramsValue: params.value ?? "",
                  apiID: params.apiId ?? 0,
                  isNew: false,
                  isActive: params.isActive == 1 ? true : false,
                ),
          );
        },
        contentPadding: EdgeInsets.fromLTRB(4, 2, 8, 2),
        horizontalTitleGap: 0,
        leading: Checkbox(
          value: params.isActive == 1 ? true : false,
          onChanged: (value) {
            if (value is bool) {
              context.read<ApiRequestBloc>().add(
                UpdateParams(
                  id: params.id ?? 0,
                  keyName: params.key,
                  value: params.value,
                  isActive: value,
                ),
              );
            }
          },
        ),
        title: MyText.bodyMedium("Key : ${params.key}"),
        subtitle: MyText.bodyMedium("Value : ${params.value}"),
        trailing: GestureDetector(
          onTap: () {
            context.read<ApiRequestBloc>().add(
              DeleteParams(id: params.id ?? 0),
            );
          },
          child: Icon(
            Icons.delete,
            color: AppColors().getCurrentColorScheme(context: context).primary,
          ),
        ),
      ),
    );
  }
}

class AddParamsBottomSheet extends StatefulWidget {
  final String? paramsKey;
  final String? paramsValue;
  final int apiID;
  final bool isNew;
  final bool? isActive;
  const AddParamsBottomSheet({
    super.key,
    this.paramsKey,
    this.paramsValue,
    required this.apiID,
    this.isNew = true,
    this.isActive,
  });

  @override
  State<AddParamsBottomSheet> createState() => _AddParamsBottomSheetState();
}

class _AddParamsBottomSheetState extends State<AddParamsBottomSheet> {
  final keyController = TextEditingController();
  final valueController = TextEditingController();

  @override
  void initState() {
    super.initState();

    keyController.text = widget.paramsKey ?? '';
    valueController.text = widget.paramsValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig screenConfig = ScreenConfig(context);
    return MyBottomsheet(
      childerns: [
        MyGap(gap: 20),
        MyText.h6("Add Params"),
        Padding(
          padding: screenConfig.padding,
          child: MyTextfield(
            hint: "Key",
            controller: keyController,
            shouldValidate: false,
          ),
        ),
        Padding(
          padding: screenConfig.padding,
          child: MyTextfield(
            hint: "Value",
            controller: valueController,
            shouldValidate: false,
          ),
        ),
        Padding(
          padding: screenConfig.padding,
          child: MyBtn(
            onBtnTap: () {
              Utility.showLog("New Params add button clicked!!");

              if (keyController.text.isNotEmpty &&
                  valueController.text.isNotEmpty) {
                if (widget.isNew) {
                  context.read<ApiRequestBloc>().add(
                    AddParams(
                      apiID: widget.apiID,
                      key: keyController.text,
                      value: valueController.text,
                    ),
                  );
                } else {
                  context.read<ApiRequestBloc>().add(
                    UpdateParams(
                      id: widget.apiID,
                      keyName: keyController.text,
                      value: valueController.text,
                      isActive: widget.isActive,
                    ),
                  );

                  Navigator.pop(context);
                }
              } else {
                Utility.showToastMessage(
                  "Collection Name Should Not Be Empty",
                  context,
                );
              }
            },
            title: "Add",
          ),
        ),
      ],
    );
  }
}
