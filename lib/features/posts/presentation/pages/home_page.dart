import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vintage/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:vintage/features/posts/presentation/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // AppBar
      appBar: AppBar(
        // title
        centerTitle: true,
        title: const Text("Home"),

        // logout
        actions: [
          IconButton(onPressed: (){context.read<AuthCubit>().logout();}, icon: const Icon(Icons.logout)),
        ],
      ),

      // Drawer
      drawer: MyDrawer(),
    );
  }
}
