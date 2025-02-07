import 'package:pusher_client/pusher_client.dart';

import '../channel/pusher_channel.dart';
import '../channel/pusher_encrypted_private_channel.dart';
import '../channel/pusher_presence_channel.dart';
import '../channel/pusher_private_channel.dart';
import 'connector.dart';

///
/// This class creates a null connector.
///
class PusherConnector extends Connector<PusherClient, PusherChannel> {
  /// The Pusher connection instance.
  // PusherClient get pusher => options.client;
  final PusherClient pusher;

  @override
  PusherClient get client => pusher;

  PusherConnector(
    this.pusher, {
    Map? auth,
    String? authEndpoint,
    String? host,
    String? key,
    String? namespace,
    bool autoConnect = false,
    Map moreOptions = const {},
  }) : super(ConnectorOptions(
          client: pusher,
          auth: auth,
          authEndpoint: authEndpoint,
          host: host,
          key: key,
          namespace: namespace,
          autoConnect: autoConnect,
          moreOptions: moreOptions,
        ));

  /// Listen for an event on a channel instance.
  @override
  PusherChannel listen(String name, String event, Function callback) =>
      channel(name).listen(event, callback);

  /// Get a channel instance by name.
  @override
  PusherChannel channel(String name) {
    if (channels[name] == null) {
      channels[name] = PusherChannel(pusher, name, options);
    }
    return channels[name] as PusherChannel;
  }

  /// Get a private channel instance by name.
  @override
  PusherPrivateChannel privateChannel(String name) {
    if (channels['private-$name'] == null) {
      channels['private-$name'] = PusherPrivateChannel(
        pusher,
        'private-$name',
        options,
      );
    }
    return channels['private-$name'] as PusherPrivateChannel;
  }

  /// Get a private encrypted channel instance by name.
  @override
  PusherEncryptedPrivateChannel encryptedPrivateChannel(String name) {
    if (channels['private-encrypted-$name'] == null) {
      channels['private-encrypted-$name'] = PusherEncryptedPrivateChannel(
        pusher,
        'private-encrypted-$name',
        options,
      );
    }
    return channels['private-encrypted-$name'] as PusherEncryptedPrivateChannel;
  }

  /// Get a presence channel instance by name.
  @override
  PusherPresenceChannel presenceChannel(String name) {
    if (channels['presence-$name'] == null) {
      channels['presence-$name'] = PusherPresenceChannel(
        pusher,
        'presence-$name',
        options,
      );
    }
    return channels['presence-$name'] as PusherPresenceChannel;
  }

  /// Leave the given channel, as well as its private and presence variants.
  @override
  void leave(String name) {
    List<String> channels = [name, 'private-$name', 'presence-$name'];
    for (var name in channels) {
      leaveChannel(name);
    }
  }

  /// Leave the given channel.
  @override
  void leaveChannel(String name) {
    if (channels[name] != null) {
      channels[name]!.unsubscribe();
      channels.remove(name);
    }
  }

  /// Get the socket ID for the connection.
  @override
  String? get socketId => pusher.getSocketId();

  /// Create a fresh Pusher connection.
  @override
  void connect() {
    pusher.connect();
  }

  /// Disconnect Pusher connection.
  @override
  void disconnect() => pusher.disconnect();

  @override
  void onConnectError(Function(dynamic data) handler) =>
      pusher.onConnectionError((data) => handler(data));
}
