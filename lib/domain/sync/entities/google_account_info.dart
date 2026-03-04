class GoogleAccountInfo {
  const GoogleAccountInfo({required this.displayName, required this.email});

  final String? displayName;
  final String email;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoogleAccountInfo &&
          runtimeType == other.runtimeType &&
          displayName == other.displayName &&
          email == other.email;

  @override
  int get hashCode => displayName.hashCode ^ email.hashCode;
}
