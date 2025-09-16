import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:winr/core/apptext/app_text.dart';

class VersionScreen extends HookConsumerWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packageInfo = useState<PackageInfo?>(null);

    useEffect(() {
      Future<void> getVersion() async {
        final info = await PackageInfo.fromPlatform();
        packageInfo.value = info;
      }

      getVersion();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text(AppText.version), centerTitle: true),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              buildListTile(
                packageInfo.value?.appName ?? AppText.unknown,
                AppText.appName,
              ),
              buildListTile(
                packageInfo.value?.version ?? AppText.unknown,
                AppText.appVersion,
              ),
              buildListTile(
                packageInfo.value?.buildNumber ?? AppText.unknown,
                AppText.appBuildNumber,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildListTile(String trailing, String title) {
    return ListTile(title: Text(title), trailing: Text(trailing));
  }
}
