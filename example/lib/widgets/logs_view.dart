import '../app_state.dart';
import 'package:flutter/material.dart';

class LogsView extends StatelessWidget {
  const LogsView({super.key});

  @override
  Widget build(BuildContext context) {
    var logs = AppState.of(context).logs;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey[100],
      child: ListView.builder(
        reverse: true,
        itemCount: logs.length,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${logs[index].date} ',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: ' ${logs[index].text}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
