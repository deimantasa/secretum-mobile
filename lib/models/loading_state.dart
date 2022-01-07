class LoadingState {
  bool isLoading = true;

  LoadingState.loading({this.isLoading = true});
  LoadingState.notLoading({this.isLoading = false});
}
