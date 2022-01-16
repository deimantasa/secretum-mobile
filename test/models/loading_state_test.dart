import 'package:flutter_test/flutter_test.dart';
import 'package:secretum/models/loading_state.dart';

void main() {
  test('LoadingState.loading', () {
    final loadingState = LoadingState.loading();

    expect(loadingState.isLoading, isTrue);
  });

  test('LoadingState.notLoading', () {
    final loadingState = LoadingState.notLoading();

    expect(loadingState.isLoading, isFalse);
  });
}
