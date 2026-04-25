import 'package:get_it/get_it.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/auth/presentation/bloc/login_bloc.dart';
import 'features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'features/auth/presentation/bloc/sign_up_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/cart_bloc.dart';
import 'features/home/presentation/bloc/product_detail_bloc.dart';

/// Service Locator global menggunakan GetIt.
/// Panggil [initDependencies] sebelum [runApp].
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Feature: Splash ──
  sl.registerFactory<SplashBloc>(() => SplashBloc());

  // ── Feature: Auth ──
  sl.registerFactory<LoginBloc>(() => LoginBloc());
  sl.registerFactory<ForgotPasswordBloc>(() => ForgotPasswordBloc());
  sl.registerFactory<SignUpBloc>(() => SignUpBloc());

  // ── Feature: Home ──
  sl.registerFactory<HomeBloc>(() => HomeBloc());
  sl.registerFactory<CartBloc>(() => CartBloc());
  sl.registerFactory<ProductDetailBloc>(() => ProductDetailBloc());
}
