import "dart:math";

main() {
  var list1 = [11, 11, 9, 8, 7, 6].reduce((a, b) => a > b ? a : b);

  print(list1);
}
