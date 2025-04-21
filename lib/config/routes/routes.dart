import 'package:flutter/material.dart';

import '../../views/views.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splashView:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case RoutesName.apiRequestView:
        return MaterialPageRoute(builder: (context) => const ApiRequestView());
      //   case RoutesName.updateAppView:
      //     return MaterialPageRoute(builder: (context) => const UpdateAppScreen());
      //   case RoutesName.maintainanceView:
      //     return MaterialPageRoute(
      //         builder: (context) => const MaintainanceView());
      //   case RoutesName.bottomTabview:
      //     return MaterialPageRoute(builder: (context) => const BottomTabView());
      //   case RoutesName.loginScreen:
      //     return MaterialPageRoute(builder: (context) => const LoginScreen());
      //   case RoutesName.registerScreen:
      //     return MaterialPageRoute(builder: (context) => const RegisterScreen());
      //   case RoutesName.verifyOTPScreen:
      //     return MaterialPageRoute(builder: (context) => const VerifyOTPScreen());
      //   case RoutesName.forgotPasswordScreen:
      //     return MaterialPageRoute(
      //         builder: (context) => const ForgotPasswordScreen());
      //   case RoutesName.chatListScreen:
      //     return MaterialPageRoute(builder: (context) => const ChatListScreen());
      //   case RoutesName.newStudentListScreen:
      //     return MaterialPageRoute(
      //         builder: (context) => const NewStudentsListScreen());
      //   case RoutesName.chatScreen:
      //     return MaterialPageRoute(builder: (context) {
      //       Map<String, dynamic> userData =
      //           settings.arguments as Map<String, dynamic>;

      //       return ChatScreen(userData: userData);
      //     });

      //   // >>>>>>>>>>>>>> Profile Screen Routes <<<<<<<<<<<<<<<<<
      //   case RoutesName.bankListView:
      //     return MaterialPageRoute(builder: (context) => const BanksListView());
      //   case RoutesName.scheduleLocationView:
      //     return MaterialPageRoute(
      //         builder: (context) => const ScheduleLocationView());
      //   case RoutesName.paymentDueStudentsView:
      //     return MaterialPageRoute(
      //         builder: (context) => const PaymentDueStudentsView());
      //   case RoutesName.studentDuePayments:
      //     return MaterialPageRoute(
      //         builder: (context) => StudentDuePaymentsView(
      //               // passed student id in argument
      //               studentID: settings.arguments as int,
      //             ));

      default:
        return MaterialPageRoute(
          builder: (context) => const DefaultRouteScreenView(),
        );
    }
  }
}

class DefaultRouteScreenView extends StatelessWidget {
  const DefaultRouteScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Technical Error!")));
  }
}
