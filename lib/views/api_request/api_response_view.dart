import 'package:apimate/config/components/my_gap.dart';
import 'package:apimate/config/components/my_navbar.dart';
import 'package:apimate/config/components/my_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../config/utility/screen_config.dart';
import '../../config/utility/utility.dart';

class ApiResponseView extends StatelessWidget {
  final http.Response response;
  const ApiResponseView({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final ScreenConfig screenConfig = ScreenConfig(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MyNavbar(
                title: "Api Response",
                trailing: GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: Utility.prettyPrintJson(response.body),
                      ),
                    ).then((value) {
                      Utility.showToastMessage(
                        "Response Copied To Clipboard!",
                        context,
                      );
                    });
                  },
                  child: Padding(
                    padding: screenConfig.paddingH,
                    child: Icon(Icons.copy_rounded),
                  ),
                ),
              ),


              

              MyGap(gap: 10),

              // Response Status Code
              Padding(
                padding: screenConfig.padding,
                child: Row(
                  children: [
                    MyText.h6("Response Code : "),
                    MyText.h5(
                      '${response.statusCode}  ${response.reasonPhrase}',
                    ),
                  ],
                ),
              ),

              // Response Status Body
              MyText.bodyMedium(Utility.prettyPrintJson(response.body)),
            ],
          ),
        ),
      ),
    );
  }
}
