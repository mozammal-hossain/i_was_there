enum ForceUpdateStatus { initial, openFailed }

class ForceUpdateState {
  const ForceUpdateState({
    this.status = ForceUpdateStatus.initial,
    this.openStoreError,
  });

  final ForceUpdateStatus status;
  final String? openStoreError;

  ForceUpdateState copyWith({
    ForceUpdateStatus? status,
    String? openStoreError,
  }) {
    return ForceUpdateState(
      status: status ?? this.status,
      openStoreError: openStoreError,
    );
  }
}
