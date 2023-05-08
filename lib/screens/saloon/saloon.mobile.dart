import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/screens/saloon/operator_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaloonMobile extends StatefulWidget {
  const SaloonMobile({super.key});

  @override
  State<SaloonMobile> createState() => _SaloonMobileState();
}

class _SaloonMobileState extends State<SaloonMobile> {
  late Future<List<UserModel>> getAllOperators;

  @override
  void initState() {
    super.initState();
    getAllOperators = Provider.of<UserProvider>(context, listen: false)
        .getAllByRole(Role.OPERATOR);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: getAllOperators,
      builder: (context, snapshot) => snapshot.connectionState !=
              ConnectionState.done
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : snapshot.hasError
              ? Center(
                  child: Text('${snapshot.error}'),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                  ),
                  padding: const EdgeInsets.all(20),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => OperatorItem(
                    operator: snapshot.data!.elementAt(index),
                  ),
                ),
    );
  }
}
