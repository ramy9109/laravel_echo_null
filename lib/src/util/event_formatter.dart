///
/// Event name formatter
///
class EventFormatter {
  /// Event namespace.
  String? namespace;

  /// Create a new class instance.
  EventFormatter(this.namespace);

  /// Format the given event name.
  String format(String event) {
    if (event.substring(0, 1) == '.' || event.substring(0, 1) == '\\') {
      return event.substring(1);
    } else if (namespace != null) {
      event = '${namespace!}.$event';
    }
    return event.replaceAll(RegExp(r'\.'), '\\');
  }
}
