import 'package:ebutler/models/user.model.dart';
import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/screens/saloon/operator_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaloonWeb extends StatefulWidget {
  const SaloonWeb({super.key});

  @override
  State<SaloonWeb> createState() => _SaloonWebState();
}

class _SaloonWebState extends State<SaloonWeb> {
  late Future<List<UserModel>> getOperatorsFuture;

  @override
  void initState() {
    super.initState();
    getOperatorsFuture = Provider.of<UserProvider>(context, listen: false)
        .getAllByRole(Role.OPERATOR);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getOperatorsFuture,
      builder: (context, snapshot) =>
          snapshot.connectionState != ConnectionState.done
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
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
