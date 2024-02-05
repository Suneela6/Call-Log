import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const CallLogApp());
}

class CallLogApp extends StatelessWidget {
  const CallLogApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Log App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Call Log Access',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 93, 214, 232),
        ),
        body: FutureBuilder<Iterable<CallLogEntry>>(
          future: CallLog.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final entry = snapshot.data!.elementAt(index);

                  final timestamp = entry.timestamp != null
                      ? DateTime.fromMillisecondsSinceEpoch(entry.timestamp!)
                      : null;

                  final formattedDateTime = timestamp != null
                      ? DateFormat.yMd().add_Hms().format(timestamp)
                      : 'N/A';

                  return ListTile(
                    leading: const Icon(Icons.call),
                    title: Text('${entry.name ?? 'Unknown'}: ${entry.number}'),
                    subtitle:
                        Text('$formattedDateTime | ${entry.duration} seconds'),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
