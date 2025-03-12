import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock Stream class for testing
class Stream {
  final String id;
  final String quality;

  Stream({required this.id, required this.quality});
}

// YtPlayerState mock implementation
class YtPlayerState extends StatefulWidget {
  final List<Stream> videoOnlyStreams;
  @override
  final GlobalKey<_YtPlayerState> key;

  const YtPlayerState({required this.videoOnlyStreams, required this.key})
      : super(key: key);

  @override
  _YtPlayerState createState() => _YtPlayerState();
}

class _YtPlayerState extends State<YtPlayerState> {
  String? currentStreamQuality;

  List<Stream> get videoOnlyStreams => widget.videoOnlyStreams;

  // Mock _changeQuality method that updates the current stream quality
  Future<void> _changeQuality({required Stream stream}) async {
    setState(() {
      currentStreamQuality = stream.quality;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          currentStreamQuality ?? 'No Quality Selected',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// Main function to run the tests
void main() {
  group('YtPlayer Tests', () {
    final ytPlayerKey = GlobalKey<_YtPlayerState>();

    // Mock stream data for testing
    List<Stream> mockStreams = [
      Stream(id: '1', quality: '360p'),
      Stream(id: '2', quality: '720p'),
      Stream(id: '3', quality: '1080p'),
    ];

    testWidgets('Should switch quality on _changeQuality call',
        (WidgetTester tester) async {
      // Arrange: Set up the widget with a mock stream list
      await tester.pumpWidget(MaterialApp(
        home: YtPlayerState(
          videoOnlyStreams: mockStreams,
          key: ytPlayerKey,
        ),
      ));

      // Get the player state from the GlobalKey
      final playerState = ytPlayerKey.currentState;
      expect(playerState, isNotNull,
          reason: 'YtPlayerState should be initialized.');

      // Act: Trigger the quality change method
      if (playerState != null && playerState.videoOnlyStreams.isNotEmpty) {
        await playerState._changeQuality(
            stream: playerState.videoOnlyStreams.first);

        // Assert: Check if the quality switched correctly
        expect(playerState.currentStreamQuality, equals('360p'),
            reason:
                'The quality should switch to 360p after calling _changeQuality with the first stream.');
      } else {
        fail('Failed to initialize videoOnlyStreams or playerState is null.');
      }

      // Ensure the text on screen reflects the quality change
      await tester.pumpAndSettle();
      expect(find.text('360p'), findsOneWidget);
    });
  });
}
