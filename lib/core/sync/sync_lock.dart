import 'package:injectable/injectable.dart';
import 'package:synchronized/synchronized.dart';

@lazySingleton
class SyncLock {
  final Lock lock = Lock();
}
