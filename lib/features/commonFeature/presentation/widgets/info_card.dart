import 'package:flutter/material.dart';

import '../../domain/user.dart';
import '../update_Info_page.dart';

class InfoCard extends StatefulWidget {
  final UserData user;

  const InfoCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(
                  widget.user.name[0]), // Displays the first letter of the name
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.user.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '#${widget.user.id}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UpdateInfoScreen(userData: widget.user)));

                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
