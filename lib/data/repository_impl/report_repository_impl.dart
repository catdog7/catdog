import 'package:catdog/domain/repository/report_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'report_repository_impl.g.dart';

class ReportRepositoryImpl implements ReportRepository {
  final SupabaseClient _supabase;

  ReportRepositoryImpl(this._supabase);

  @override
  Future<void> reportFeed({
    required String feedId,
    required String reportedUserId,
    required String category,
    String? reasonDetail,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("로그인이 필요합니다.");

    await _supabase.from('reports').insert({
      'reporter_id': user.id,
      'reported_user_id': reportedUserId,
      'target_type': 'FEED',
      'target_id': feedId,
      'category': category,
      'reason_detail': reasonDetail,
      'status': 'PENDING',
    });
  }

  @override
  Future<List<String>> getReportedFeedIds(String userId) async {
    final response = await _supabase
        .from('reports')
        .select('target_id')
        .eq('reporter_id', userId)
        .eq('target_type', 'FEED');

    final List<dynamic> data = response;
    return data.map((e) => e['target_id'] as String).toList();
  }
}

@riverpod
ReportRepository reportRepository(Ref ref) {
  return ReportRepositoryImpl(Supabase.instance.client);
}
