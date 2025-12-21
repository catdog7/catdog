import 'package:amumal/ui/pages/join/view_model/root_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RootPage extends HookConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootState = ref.watch(rootPageViewModelProvider);
    final hasNavigated = useRef(false);

    // 라우팅 로직 (한 번만 실행)
    useEffect(() {
      rootState.whenData((result) {
        if (hasNavigated.value) return;

        final (hasProfile, user) = result;

        if (hasProfile && user != null) {
          hasNavigated.value = true;
          Future.microtask(() {
            context.go('/home', extra: user);
          });
        } else {
          hasNavigated.value = true;
          Future.microtask(() {
            context.go('/login');
          });
        }
      });
      return null;
    }, [rootState]);

    return rootState.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      error: (e, _) => Scaffold(
        body: Center(child: Text("오류 발생: $e")),
      ),

      data: (_) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
