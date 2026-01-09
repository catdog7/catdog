abstract interface class CommentLikeRepository {
  Future<int> getCommentLikeCount(String commentId);
  Future<bool> checkLiked(String commentId);
  Future<void> deleteLiked(String commentId);
  Future<void> addLiked(String commentId);
}
