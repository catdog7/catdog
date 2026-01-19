abstract class ReportRepository {
  Future<void> reportFeed({
    required String feedId,
    required String reportedUserId,
    required String category,
    String? reasonDetail,
  });

  Future<List<String>> getReportedFeedIds(String userId);
}
