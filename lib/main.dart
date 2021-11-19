import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './routes/app_routes.dart';
import './screens/auth_or_home/auth_or_home_screen.dart';
import './screens/change_password/change_password_screen.dart';
import './screens/confirm_email/confirm_email_screen.dart';
import './screens/contact_page/contact_page.dart';
import './screens/home/home_screen.dart';
import './screens/login/login_screen.dart';
import './screens/reset_email_link/reset_email_Link_screen.dart';
import './screens/reset_password/reset_password_screen.dart';
import './screens/reset_password_link/reset_password_Link_screen.dart';
import './screens/signup/signup_screen.dart';
//import './screens/welcome/welcome_screen.dart';
import 'screens/auth_or_home/auth_or_home_screen.dart';
// import './screens/publicacoes/publicacoes_pesquisa_meusprocessos_screen.dart';
import 'screens/publicacoes_pesquisageral/pesquisageral_main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Udex',
          theme: tema.copyWith(
            colorScheme: tema.colorScheme.copyWith(
              primary: Colors.deepPurple[900],
              secondary: Colors.lightBlue[900],

            )
            //primarySwatch: Colors.purple,
            //primaryColorBrightness: Brightness.dark,
            //brightness: Brightness.light,
            //fontFamily: 'Roboto',
            //scaffoldBackgroundColor: Colors.white,

          ),
          home: AuthOrHomeScreen(),
          initialRoute: "/",
          routes: {
            AppRoutes.HOME: (ctx) => HomeScreen(),
            // AppRoutes.WELCOME: (ctx) => WelcomeScreen(),
            AppRoutes.AUTH_HOME: (ctx) => AuthOrHomeScreen(),
            AppRoutes.LOGIN: (ctx) => LoginScreen(),
            AppRoutes.SIGNUP: (ctx) => SignUpScreen(),
            AppRoutes.CHANGEPASSWORD: (ctx) => ChangePasswordScreen(),
            AppRoutes.CONTACTPAGE: (ctx) => ContactScreen(),
            AppRoutes.SENDRESETPASSWORDLINK: (ctx) => ResetPasswordLinkScreen(),
            AppRoutes.RESETEMAILLINK: (ctx) => ResetEmailLinkScreen(),
            AppRoutes.SENDRESETEMAILLINK: (ctx) => ResetEmailLinkScreen(),
            // AppRoutes.CONFIRMEMAIL: (ctx) => PassArgumentsScreen(message: args.message,),
            AppRoutes.PUBLICACOESPESQUISAGERAL: (ctx) =>
                PesquisaGeralMainScreen(),

            // AppRoutes.PUBLICACOESPESQUISAMEUSPROCESSOS: (ctx) =>
            //     PublicacoesPesquisaMeusProcessosScreen(processo),
            // AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
            // AppRoutes.CART: (ctx) => CartScreen(),
            // AppRoutes.ORDERS: (ctx) => OrdersScreen(),
            // AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
            // AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
          },
          onGenerateRoute: (settings) {
            final String tempSettingsName = settings.name ?? '';

            if (tempSettingsName.contains(AppRoutes.CONFIRMEMAIL)) {
              return MaterialPageRoute(
                builder: (context) {
                  return ConfirmEmailScreen(
                    urlToken: tempSettingsName,
                  );
                },
              );
            }

            if (tempSettingsName.contains(AppRoutes.RESETPASSWORD)) {
              print('Routed to ResetPasswordScreen');
              return MaterialPageRoute(
                builder: (context) {
                  return ResetPasswordScreen(
                    urlToken: tempSettingsName,
                  );
                },
              );
            }
          }),
    );
  }
}

        // ChangeNotifierProxyProvider<Auth, Processos>(
        //   create: (_) => new Processos(),
        //   lazy: false,
        //   update: (ctx, user, previousProcessos) => new Processos(
        //     user.token,
        //     user.userId,
        //     previousProcessos.items,
        //   ),
        // ),

            // print(
            //     'Entrou no OnGenerateRoute - 1 - tempSettingsName ${tempSettingsName}');
            //final String tempArgumentsScreen = PassArgumentsScreen.routeName;
            // if (tempSettingsName.contains(PassArgumentsScreen.routeName)) {

              // print(
              // 'Entrou no OnGenerateRoute - 2 - builder  ${PassArgumentsScreen.routeName}');
              //print('Entrou aqui');
              // final args = settings.arguments as ScreenArguments;
              //print('Entrou aqui');
              // print(
              //     'Entrou no OnGenerateRoute - 3 - args  ${tempSettingsName}');
              // http://localhost:58507/#/confirmemail?urlToken=1234567

// void main() {
// runApp(
//   MultiProvider(
//     providers: [
//       // ChangeNotifierProvider(create: (context) => CartModel()),
//       ChangeNotifierProvider(create: (context) => Auth()),
//       // ChangeNotifierProvider(create: (_) => ShoppingCart()),
//     ],
//     child: MyApp(),
//   ),
// );
//}
