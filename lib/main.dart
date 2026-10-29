import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/api/dio_client.dart';
import 'features/home/data/products_repository.dart';
import 'features/home/logic/products_cubit.dart';
import 'features/home/presentation/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Task3App());
}

class Task3App extends StatelessWidget {
  const Task3App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ProductsRepository(DioClient.create()),
      child: BlocProvider(
        create: (context) => ProductsCubit(context.read<ProductsRepository>())..loadProducts(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task 3 Shop',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B5FEF)),
            scaffoldBackgroundColor: const Color(0xFFF7F8FC),
            fontFamily: 'Arial',
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
