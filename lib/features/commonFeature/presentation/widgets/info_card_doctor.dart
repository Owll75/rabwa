import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/domain/doctor.dart';

import '../update_Info_page.dart';

class InfoCardDoctor extends StatefulWidget {
  final Doctor doctor;

  const InfoCardDoctor({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  State<InfoCardDoctor> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCardDoctor> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: Text(widget
                  .doctor.name![0]), // Displays the first letter of the name
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.doctor.name!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                //await Navigator.push(
                //    context,
                //    MaterialPageRoute(
                //       builder: (context) => p
//UpdateInfoScreen(userData: widget.doctor)
                //           ));

                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
