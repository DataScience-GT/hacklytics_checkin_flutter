import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:provider/provider.dart';

import 'common/tag_read.dart';
import 'common/nfc_session.dart';
import 'common/tag_info.dart';
import 'common/ndef_record.dart';
import '../utility/extensions.dart';

// class NFCPage extends StatefulWidget {
//   static Widget withDependency() => ChangeNotifierProvider<TagReadModel>(
//         create: (context) => TagReadModel(),
//         child: NFCPage(),
//       );
//   const NFCPage({super.key});

//   @override
//   State<NFCPage> createState() => _NFCPageState();
// }

// class _NFCPageState extends State<NFCPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('NFC Page'),
//       ),
//       body: ListView(
//         padding: EdgeInsets.all(2),
//         children: [
//           Column(
//             children: [
//               ListTile(
//                 title: Text('Start Session',
//                     style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary)),
//                 onTap: () => startSession(
//                   context: context,
//                   handleTag: Provider.of<TagReadModel>(context, listen: false)
//                       .handleTag,
//                 ),
//               ),
//             ],
//           ),
//           // consider: Selector<Tuple<{TAG}, {ADDITIONAL_DATA}>>
//           Consumer<TagReadModel>(builder: (context, model, _) {
//             final tag = model.tag;
//             final additionalData = model.additionalData;
//             if (tag != null && additionalData != null) {
//               return TagInfo(tag, additionalData);
//             }
//             return SizedBox.shrink();
//           }),
//         ],
//       ),
//     );
//   }
// }

class NfcPage extends StatelessWidget {
  static Widget withDependency() => ChangeNotifierProvider<TagReadModel>(
        create: (context) => TagReadModel(),
        child: const NfcPage(),
      );
  const NfcPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Page'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(2),
        children: [
          Column(
            children: [
              ListTile(
                title: Text('Start Session',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)),
                onTap: () => startSession(
                  context: context,
                  handleTag: Provider.of<TagReadModel>(context, listen: false)
                      .handleTag,
                ),
              ),
            ],
          ),
          // consider: Selector<Tuple<{TAG}, {ADDITIONAL_DATA}>>
          Consumer<TagReadModel>(builder: (context, model, _) {
            final tag = model.tag;
            final additionalData = model.additionalData;
            print('data: $model.additionalData');
            if (tag != null && additionalData != null) {
              return TagInfo(tag, additionalData);
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
