import 'package:flutter/material.dart';
import 'package:winr/common/components/loading/skeleton.dart';

class RecordLoading extends StatelessWidget {
  const RecordLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Skeleton(height: 23, width: 50),
                Icon(Icons.chevron_right),
              ],
            ),
            SizedBox(height: 15),
            Skeleton(height: 120, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
