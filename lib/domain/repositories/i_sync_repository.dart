abstract class ISyncRepository {
  /// Pushes all dirty records to Firestore.
  /// Returns count of synced items (just for stats).
  Future<int> push();

  /// Pulls all updated record from Firestore for this device.
  /// Updates local SQLite.
  Future<void> pull();

  /// Gets the last sync timestamp.
  Future<int> getLastSyncTimestamp();

  /// Sets the last sync error message (or null if success).
  Future<void> setLastError(String? error);

  /// Gets the last persisted error message.
  Future<String?> getLastError();
}
