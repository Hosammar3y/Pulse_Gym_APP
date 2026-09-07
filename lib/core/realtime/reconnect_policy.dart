class ReconnectPolicy {
  const ReconnectPolicy({
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 15),
  });

  final Duration initialDelay;
  final Duration maxDelay;

  Duration next(Duration current) {
    final doubled = Duration(milliseconds: current.inMilliseconds * 2);
    return doubled > maxDelay ? maxDelay : doubled;
  }
}
