class Status {
  late String message;
  late bool success;
  late Error error;

  Status({required this.message, required this.success});
  Status.withError({required this.error}) {
    success = false;
  }
  Status.withSuccess({required this.message}) {
    success = true;
  }
}
