import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../models/UserModel.dart';
import 'package:flutter/material.dart';
import 'useImage.dart'

class UserViewer extends StatelessWidget {
  const UserViewer({super.key, required this.friend});
  final User friend;

  @override
  Widget build(BuildContext context) {
    return Text(friend.name);
  }
}