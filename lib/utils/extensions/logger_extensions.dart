import '../../services/logger_service.dart';

/// Bloc'lar için logging extensions
extension BlocLogger on Object {
  void logEvent(String eventName, {Map<String, dynamic>? data}) {
    logger.info(
      'Event: $eventName',
      className: runtimeType.toString(),
      methodName: 'on$eventName',
      data: data,
    );
  }

  void logStateChange(String from, String to, {Map<String, dynamic>? data}) {
    logger.info(
      'State: $from → $to',
      className: runtimeType.toString(),
      methodName: 'emit',
      data: data,
    );
  }

  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    logger.error(
      message,
      className: runtimeType.toString(),
      data: error != null ? {'error': error.toString()} : null,
      stackTrace: stackTrace,
    );
  }
}

/// API Service'ler için logging extensions
extension ApiLogger on Object {
  void logApiRequest(String method, String endpoint, {Map<String, dynamic>? data}) {
    logger.info(
      'API Request: $method $endpoint',
      className: runtimeType.toString(),
      data: data,
    );
  }

  void logApiResponse(String method, String endpoint, int statusCode, {Duration? duration}) {
    if (statusCode >= 400) {
      logger.error(
        'API Response: $method $endpoint - $statusCode',
        className: runtimeType.toString(),
        data: {
          'status': statusCode,
          if (duration != null) 'duration_ms': duration.inMilliseconds,
        },
      );
    } else {
      logger.info(
        'API Response: $method $endpoint - $statusCode',
        className: runtimeType.toString(),
        data: {
          'status': statusCode,
          if (duration != null) 'duration_ms': duration.inMilliseconds,
        },
      );
    }
  }

  void logApiError(String method, String endpoint, Object error, {StackTrace? stackTrace}) {
    logger.error(
      'API Error: $method $endpoint',
      className: runtimeType.toString(),
      data: {'error': error.toString()},
      stackTrace: stackTrace,
    );
  }
}

/// Widget'lar için logging extensions  
extension WidgetLogger on Object {
  void logLifecycle(String event, {Map<String, dynamic>? data}) {
    logger.debug(
      'Lifecycle: $event',
      className: runtimeType.toString(),
      data: data,
    );
  }

  void logUserInteraction(String action, {Map<String, dynamic>? data}) {
    logger.userAction(
      action,
      data: {
        'widget': runtimeType.toString(),
        ...?data,
      },
    );
  }

  void logPerformance(String operation, Duration duration, {Map<String, dynamic>? data}) {
    logger.info(
      'Performance: $operation took ${duration.inMilliseconds}ms',
      className: runtimeType.toString(),
      data: {
        'duration_ms': duration.inMilliseconds,
        ...?data,
      },
    );
  }
}

/// Repository'ler için logging extensions
extension RepositoryLogger on Object {
  void logDataOperation(String operation, {Map<String, dynamic>? data}) {
    logger.info(
      'Data Operation: $operation',
      className: runtimeType.toString(),
      data: data,
    );
  }

  void logCacheHit(String key) {
    logger.debug(
      'Cache Hit: $key',
      className: runtimeType.toString(),
    );
  }

  void logCacheMiss(String key) {
    logger.debug(
      'Cache Miss: $key',
      className: runtimeType.toString(),
    );
  }
} 