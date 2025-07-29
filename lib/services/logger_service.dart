import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Log severity levels
enum LogLevel {
  debug(0, 'DEBUG', '🐛'),
  info(1, 'INFO', 'ℹ️'),
  warning(2, 'WARNING', '⚠️'),
  error(3, 'ERROR', '❌'),
  critical(4, 'CRITICAL', '🔥');

  const LogLevel(this.priority, this.name, this.emoji);
  
  final int priority;
  final String name;
  final String emoji;
}

/// Log configuration
class LogConfig {
  final LogLevel minimumLevel;
  final bool enableConsoleLogging;
  final bool enableFileLogging;
  final bool enableRemoteLogging;
  final int maxLogFiles;
  final int maxLogFileSize; // bytes
  final bool includeStackTrace;
  final bool enableColoring;

  const LogConfig({
    this.minimumLevel = LogLevel.debug,
    this.enableConsoleLogging = true,
    this.enableFileLogging = true,
    this.enableRemoteLogging = false,
    this.maxLogFiles = 5,
    this.maxLogFileSize = 5 * 1024 * 1024, // 5MB
    this.includeStackTrace = true,
    this.enableColoring = true,
  });

  /// Development configuration
  factory LogConfig.development() => const LogConfig(
    minimumLevel: LogLevel.debug,
    enableConsoleLogging: true,
    enableFileLogging: true,
    enableRemoteLogging: false,
  );

  /// Production configuration
  factory LogConfig.production() => const LogConfig(
    minimumLevel: LogLevel.info,
    enableConsoleLogging: false,
    enableFileLogging: true,
    enableRemoteLogging: true,
  );
}

/// Structured log entry
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? className;
  final String? methodName;
  final Map<String, dynamic>? data;
  final StackTrace? stackTrace;
  final String? userId;
  final String? sessionId;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.className,
    this.methodName,
    this.data,
    this.stackTrace,
    this.userId,
    this.sessionId,
  });

  /// Convert to JSON for structured logging
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'level': level.name,
      'message': message,
      if (className != null) 'class': className,
      if (methodName != null) 'method': methodName,
      if (data != null) 'data': data,
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      if (userId != null) 'userId': userId,
      if (sessionId != null) 'sessionId': sessionId,
    };
  }

  /// Format for console output
  String formatForConsole({bool enableColoring = true}) {
    final buffer = StringBuffer();
    
    // Timestamp
    buffer.write('[${timestamp.toString().substring(11, 23)}] ');
    
    // Level with emoji and color
    if (enableColoring && !kIsWeb) {
      final colorCode = _getColorCode(level);
      buffer.write('$colorCode${level.emoji} ${level.name}\x1B[0m ');
    } else {
      buffer.write('${level.emoji} ${level.name} ');
    }
    
    // Class and method
    if (className != null || methodName != null) {
      buffer.write('[');
      if (className != null) buffer.write(className);
      if (methodName != null) buffer.write('::$methodName');
      buffer.write('] ');
    }
    
    // Message
    buffer.write(message);
    
    // Data
    if (data != null && data!.isNotEmpty) {
      buffer.write(' | Data: ${jsonEncode(data)}');
    }
    
    return buffer.toString();
  }

  String _getColorCode(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '\x1B[37m'; // White
      case LogLevel.info:
        return '\x1B[36m'; // Cyan
      case LogLevel.warning:
        return '\x1B[33m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m'; // Red
      case LogLevel.critical:
        return '\x1B[35m'; // Magenta
    }
  }
}

/// Main Logger Service
class LoggerService {
  static LoggerService? _instance;
  static LoggerService get instance => _instance ??= LoggerService._();
  LoggerService._();

  LogConfig _config = LogConfig.development();
  String? _currentUserId;
  String? _currentSessionId;
  File? _currentLogFile;
  
  /// Initialize logger with configuration
  Future<void> initialize({LogConfig? config}) async {
    _config = config ?? (kDebugMode ? LogConfig.development() : LogConfig.production());
    
    if (_config.enableFileLogging) {
      await _initializeFileLogging();
    }
    
    info('Logger Service initialized', className: 'LoggerService', methodName: 'initialize');
  }

  /// Set user context for all logs
  void setUserContext(String userId, {String? sessionId}) {
    _currentUserId = userId;
    _currentSessionId = sessionId ?? DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Clear user context
  void clearUserContext() {
    _currentUserId = null;
    _currentSessionId = null;
  }

  /// Log debug message
  void debug(
    String message, {
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
  }) {
    _log(LogLevel.debug, message, className: className, methodName: methodName, data: data);
  }

  /// Log info message
  void info(
    String message, {
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
  }) {
    _log(LogLevel.info, message, className: className, methodName: methodName, data: data);
  }

  /// Log warning message
  void warning(
    String message, {
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
  }) {
    _log(LogLevel.warning, message, className: className, methodName: methodName, data: data);
  }

  /// Log error message
  void error(
    String message, {
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error, 
      message, 
      className: className, 
      methodName: methodName, 
      data: data,
      stackTrace: stackTrace ?? (_config.includeStackTrace ? StackTrace.current : null),
    );
  }

  /// Log critical error
  void critical(
    String message, {
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.critical, 
      message, 
      className: className, 
      methodName: methodName, 
      data: data,
      stackTrace: stackTrace ?? StackTrace.current,
    );
  }

  /// Log API calls
  void apiCall(
    String method,
    String url, {
    Map<String, dynamic>? requestData,
    int? statusCode,
    Map<String, dynamic>? responseData,
    Duration? duration,
  }) {
    final data = <String, dynamic>{
      'method': method,
      'url': url,
      if (requestData != null) 'request': requestData,
      if (statusCode != null) 'status': statusCode,
      if (responseData != null) 'response': responseData,
      if (duration != null) 'duration_ms': duration.inMilliseconds,
    };

    final level = (statusCode != null && statusCode >= 400) ? LogLevel.error : LogLevel.info;
    _log(level, 'API Call: $method $url', className: 'ApiService', data: data);
  }

  /// Log navigation events
  void navigation(String from, String to, {Map<String, dynamic>? data}) {
    _log(
      LogLevel.info, 
      'Navigation: $from → $to', 
      className: 'NavigationService',
      data: data,
    );
  }

  /// Log user actions
  void userAction(String action, {Map<String, dynamic>? data}) {
    _log(
      LogLevel.info, 
      'User Action: $action', 
      className: 'UserActions',
      data: data,
    );
  }

  /// Main logging method
  void _log(
    LogLevel level,
    String message, {
    String? className,
    String? methodName,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  }) {
    // Check if should log based on minimum level
    if (level.priority < _config.minimumLevel.priority) {
      return;
    }

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      className: className,
      methodName: methodName,
      data: data,
      stackTrace: stackTrace,
      userId: _currentUserId,
      sessionId: _currentSessionId,
    );

    // Console logging
    if (_config.enableConsoleLogging) {
      _logToConsole(entry);
    }

    // File logging (async)
    if (_config.enableFileLogging) {
      _logToFile(entry);
    }

    // Remote logging (async)
    if (_config.enableRemoteLogging) {
      _logToRemote(entry);
    }
  }

  /// Console logging
  void _logToConsole(LogEntry entry) {
    final formatted = entry.formatForConsole(enableColoring: _config.enableColoring);
    
    if (kDebugMode) {
      // Use developer.log for better debugging
      developer.log(
        formatted,
        name: entry.className ?? 'App',
        level: entry.level.priority * 100,
        time: entry.timestamp,
        stackTrace: entry.stackTrace,
      );
    }
  }

  /// File logging
  Future<void> _logToFile(LogEntry entry) async {
    try {
      if (_currentLogFile == null) {
        await _initializeFileLogging();
      }

      final logLine = '${jsonEncode(entry.toJson())}\n';
      await _currentLogFile?.writeAsString(logLine, mode: FileMode.append);

      // Check file size and rotate if needed
      await _rotateLogFileIfNeeded();
    } catch (e) {
      // Failed to log to file, at least log to console
      if (kDebugMode) {
        print('Failed to log to file: $e');
      }
    }
  }

  /// Remote logging (placeholder for Firebase Crashlytics, etc.)
  Future<void> _logToRemote(LogEntry entry) async {
    // TODO: Implement Firebase Crashlytics, Sentry, etc.
    // For now, just a placeholder
  }

  /// Initialize file logging
  Future<void> _initializeFileLogging() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDirectory = Directory(path.join(directory.path, 'logs'));
      
      if (!await logsDirectory.exists()) {
        await logsDirectory.create(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().split('T').first;
      _currentLogFile = File(path.join(logsDirectory.path, 'app_$timestamp.log'));
      
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize file logging: $e');
      }
    }
  }

  /// Rotate log files if current file is too large
  Future<void> _rotateLogFileIfNeeded() async {
    try {
      if (_currentLogFile == null) return;

      final fileSize = await _currentLogFile!.length();
      if (fileSize > _config.maxLogFileSize) {
        // Create new log file
        await _initializeFileLogging();
        
        // Clean old files
        await _cleanOldLogFiles();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to rotate log file: $e');
      }
    }
  }

  /// Clean old log files based on maxLogFiles configuration
  Future<void> _cleanOldLogFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDirectory = Directory(path.join(directory.path, 'logs'));
      
      final logFiles = await logsDirectory
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.log'))
          .cast<File>()
          .toList();

      if (logFiles.length > _config.maxLogFiles) {
        // Sort by modification date and delete oldest
        logFiles.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
        
        final filesToDelete = logFiles.take(logFiles.length - _config.maxLogFiles);
        for (final file in filesToDelete) {
          await file.delete();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clean old log files: $e');
      }
    }
  }

  /// Get recent logs (for debugging)
  Future<List<LogEntry>> getRecentLogs({int limit = 100}) async {
    // TODO: Implement reading from log files
    // For now, return empty list
    return [];
  }

  /// Export logs
  Future<String?> exportLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDirectory = Directory(path.join(directory.path, 'logs'));
      
      if (!await logsDirectory.exists()) {
        return null;
      }

      final exportFile = File(path.join(directory.path, 'exported_logs_${DateTime.now().millisecondsSinceEpoch}.json'));
      
      final logFiles = await logsDirectory
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.log'))
          .cast<File>()
          .toList();

      final allLogs = <String>[];
      for (final file in logFiles) {
        final content = await file.readAsString();
        allLogs.addAll(content.split('\n').where((line) => line.trim().isNotEmpty));
      }

      await exportFile.writeAsString('[\n${allLogs.join(',\n')}\n]');
      return exportFile.path;
      
    } catch (e) {
      error('Failed to export logs: $e', className: 'LoggerService', methodName: 'exportLogs');
      return null;
    }
  }
}

/// Global logger instance for easy access
final logger = LoggerService.instance; 