class Dependencies {
  Dependencies._();

  static final Dependencies _shared = Dependencies._();
  static Dependencies? testOverrides;

  factory Dependencies.shared() => testOverrides ?? _shared;
}
