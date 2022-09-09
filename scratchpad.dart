import "dart:math";

main() {
  getFileName() {
    final _random = new Random();

    final booleans = [true, false];

    if (booleans[_random.nextInt(booleans.length)]) {
      return 'foo';
    } else {
      return 1;
    }
  }

  var i = 42; // Inferred to be an int.
  String name = getFileName();
}
