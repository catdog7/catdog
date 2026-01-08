enum FcmEventType { friendRequest, friendAccepted }

class FcmEvent {
  final FcmEventType type;
  final String who;

  const FcmEvent({required this.type, required this.who});
}
