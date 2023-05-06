extension StringExtension on String {
  // Makes the first letter of every word in a sentence capitalized.
  String capitalizeFirstLetter() {
    final List<String> words = split(' ');
    String result = '';
    for (String word in words) {
      word = word.toLowerCase();
      if (words.length == 1) {
        result += '${word[0].toUpperCase() + word.substring(1)} ';
      } else {
        result += word[0].toUpperCase() + word.substring(1);
      }
    }
    return result;
  }
}
