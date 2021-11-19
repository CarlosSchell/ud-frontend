import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth.dart';

class TopDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context, listen: true);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 2),
      height: 140,
      child: Consumer<Auth>(
        builder: (_, userManager, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Udex',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Olá, ${auth.name} !',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.deepPurple,
                  //color: Constants.kPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
