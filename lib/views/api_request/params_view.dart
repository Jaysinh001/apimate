import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/api_reqiest_bloc/api_request_bloc.dart';
import '../../config/utility/screen_config.dart';

class ParamsView extends StatelessWidget {
  final TextEditingController controller;
  const ParamsView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    ScreenConfig screenConfig = ScreenConfig(context);

    return Padding(
      padding: screenConfig.padding,
      child: TextField(
        controller: controller,
        onChanged: (value) {
          context.read<ApiRequestBloc>().add(ParamsChanged(params: value));
        },
        minLines: 3,
        maxLines: null,

        keyboardType: TextInputType.multiline, // Enables the "next line" button
        textInputAction:
            TextInputAction.newline, // Sets the action button to "newline"
        decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
