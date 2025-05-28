import 'package:apimate/config/components/my_bottomsheet.dart';
import 'package:apimate/config/components/my_btn.dart';
import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:apimate/config/components/my_textfield.dart';
import 'package:apimate/config/theme/app_theme/app_theme.dart';
import 'package:apimate/config/theme/color/colors.dart';
import 'package:apimate/config/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/api_request_bloc/api_request_bloc.dart';
import '../../config/utility/screen_config.dart';
import '../../domain/model/headers_list_model.dart';

class HeadersView extends StatefulWidget {
  final int apiID;
  const HeadersView({super.key, required this.apiID});

  @override
  State<HeadersView> createState() => _HeadersViewState();
}

class _HeadersViewState extends State<HeadersView> {
  @override
  void initState() {
    super.initState();

    context.read<ApiRequestBloc>().add(GetApiHeaders(apiID: widget.apiID));
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
          // Add new header row
          Padding(
            padding: screenConfig.padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText.bodyLarge("Add New Header : "),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder:
                          (context) =>
                              AddHeaderBottomSheet(apiID: widget.apiID),
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
                  itemCount: state.headers.length,
                  itemBuilder:
                      (context, index) => HeaderListItem(
                        screenConfig: screenConfig,
                        header: state.headers[index],
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

class HeaderListItem extends StatelessWidget {
  final ScreenConfig screenConfig;
  final HeadersListModel header;
  const HeaderListItem({
    super.key,
    required this.screenConfig,
    required this.header,
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
                (context) => AddHeaderBottomSheet(
                  headerKey: header.key ?? "",
                  headerValue: header.value ?? "",
                  apiID: header.apiId ?? 0,
                ),
          );
        },
        // contentPadding: EdgeInsets.fromLTRB(8, 2, 8, 2),
        title: MyText.bodyMedium("Key : ${header.key}"),
        subtitle: MyText.bodyMedium("Value : ${header.value}"),
        trailing: GestureDetector(
          onTap: () {
            context.read<ApiRequestBloc>().add(
              DeleteHeader(id: header.id ?? 0),
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

class AddHeaderBottomSheet extends StatefulWidget {
  final String? headerKey;
  final String? headerValue;
  final int apiID;

  const AddHeaderBottomSheet({
    super.key,
    this.headerKey,
    this.headerValue,
    required this.apiID,
  });
  @override
  State<AddHeaderBottomSheet> createState() => _AddHeaderBottomSheetState();
}

class _AddHeaderBottomSheetState extends State<AddHeaderBottomSheet> {
  final keyController = TextEditingController();
  final valueController = TextEditingController();

  @override
  void initState() {
    super.initState();

    keyController.text = widget.headerKey ?? '';
    valueController.text = widget.headerValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig screenConfig = ScreenConfig(context);
    return MyBottomsheet(
      childerns: [
        MyGap(gap: 20),
        MyText.h6("Add Header"),
        Padding(
          padding: screenConfig.padding,
          child: MyTextfield(hint: "Key", controller: keyController),
        ),
        Padding(
          padding: screenConfig.padding,
          child: MyTextfield(hint: "Value", controller: valueController),
        ),
        Padding(
          padding: screenConfig.padding,
          child: MyBtn(
            onBtnTap: () {
              Utility.showLog("New Header add button clicked!!");

              if (keyController.text.isNotEmpty &&
                  valueController.text.isNotEmpty) {
                context.read<ApiRequestBloc>().add(
                  AddHeader(
                    apiID: widget.apiID,
                    key: keyController.text,
                    value: valueController.text,
                  ),
                );
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
