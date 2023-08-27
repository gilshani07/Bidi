public class Bidi {
  public static object bidi(object initial) {
    if (!(initial instanceof string && ((String) initial).containsAny('אבגדהוזחטיכךלמםנןסעפףצץקרשת'))) {
      return initial;
    }
    string toReverse = '';
    string toKeep = '';
    string output = '';
    string ltrLoose = '';
    string numRtlLoose = '';
    string[] parts = new List<string>();
    string current = '';
    string input = (string) initial;
    string state = 'rtl';
    string[] inputAsList = input.split('');
    integer l = inputAsList.size();
    for (integer i = 0; i < l; i++) {
      if (isHeb(inputAsList[i])) {
        if (state == 'ltr') {
          parts.add(toKeep);
          toKeep = '';
        } else if (state == 'ltrLoose') {
          parts.add(toKeep);
          parts.add(ltrLoose);
          toKeep = '';
          ltrLoose = '';
        } else if (state == 'num') {
          parts.add(toKeep);
          toKeep = '';
        } else if (state == 'numRtlLoose') {
          parts.add(toKeep);
          parts.add(numRtlLoose);
          toKeep = '';
          numRtlLoose = '';
        }
        toReverse += inputAsList[i];
        state = 'rtl';
      } else if (isNum(inputAsList[i])) {
        if (state == 'rtl') {
          parts.add(toReverse.reverse().replaceAll('\\(', '😊Done').replaceAll('\\)', '(').replaceAll('😊Done', ')'));
          toReverse = '';
          state = 'num';
        } else if (state == 'ltrLoose') {
          toKeep += ltrLoose;
          ltrLoose = '';
          state = 'ltr';
        } else if (state == 'numRtlLoose') {
          toKeep += numRtlLoose;
          numRtlLoose = '';
          state = 'num';
        }
        toKeep += inputAsList[i];
      } else if (isNumRtlLoose(inputAsList[i])) {
        if (state == 'rtl') {
          toReverse += inputAsList[i];
        } else if (state == 'num') {
          state = 'numRtlLoose';
          numRtlLoose += inputAsList[i];
        } else if (state == 'ltr' || state == 'ltrLoose') {
          ltrLoose += inputAsList[i];
          state = 'ltrLoose';
        } else if (state == 'numRtlLoose') {
          parts.add(toKeep);
          toKeep = '';
          toReverse += numRtlLoose;
          numRtlLoose = '';
          toReverse += inputAsList[i];
          state = 'rtl';
        }
      } else if (isEnglish(inputAsList[i])) {
        if (state == 'rtl') {
          parts.add(toReverse.reverse().replaceAll('\\(', '😊Done').replaceAll('\\)', '(').replaceAll('😊Done', ')'));
          toReverse = '';
        } else if (state == 'ltrLoose') {
          toKeep += ltrLoose;
          ltrLoose = '';
        } else if (state == 'numRtlLoose') {
          parts.add(toKeep);
          toKeep = '';
          parts.add(numRtlLoose);
          numRtlLoose = '';
        }
        toKeep += inputAsList[i];
        state = 'ltr';
      } else {
        if (state == 'rtl') {
          toReverse += inputAsList[i];
        } else if (state == 'numRtlLoose') {
          parts.add(toKeep);
          toKeep = '';
          toReverse += numRtlLoose;
          numRtlLoose = '';
          toReverse += inputAsList[i];
          state = 'rtl';
        } else if (state == 'ltr' || state == 'ltrLoose') {
          ltrLoose += inputAsList[i];
          state = 'ltrLoose';
        } else if (state == 'num') {
          parts.add(toKeep);
          toKeep = '';
          toReverse += inputAsList[i];
          state = 'rtl';
        }
      }
    }
    if (state == 'rtl') {
      parts.add(toReverse.reverse().replaceAll('\\(', '😊Done').replaceAll('\\)', '(').replaceAll('😊Done', ')'));
    } else if (state == 'ltr' || state == 'num') {
      parts.add(toKeep);
    } else if (state == 'numRtlLoose') {
      parts.add(toKeep);
      parts.add(numRtlLoose);
    } else if (state == 'ltrLoose') {
      parts.add(toKeep);
      parts.add(ltrLoose);
    }
    integer n = parts.size();
    Integer half = n / 2;
    integer mid = half - (1 / 2);
    for (integer i = 0; i < n / 2 && i != mid; i++) {
      String o = parts[i];
      parts[i] = parts[n - i - 1];
      parts[n - i - 1] = o;
    }
    return String.join(parts, '');
  }

  private static boolean isHeb(string input) {
    return input.charAt(0) > 1487 && input.charAt(0) < 1515;
  }
  //num characters: 0-9 % $ € £ ¥ #
  private static boolean isNum(string input) {
    return (input.charAt(0) > 47 &&
      input.charAt(0) < 58) ||
      (input.charAt(0) > 34 &&
      input.charAt(0) < 38) ||
      (input.charAt(0) == 128) ||
      (input.charAt(0) == 65505) ||
      (input.charAt(0) == 65509);
  }
  //numRtlLoose characters: , . + - / :
  private static boolean isNumRtlLoose(string input) {
    return (input.charAt(0) > 42 && input.charAt(0) < 48) || (input.charAt(0) == 58);
  }
  private static boolean isEnglish(string input) {
    return (input.charAt(0) > 64 && input.charAt(0) < 91) || (input.charAt(0) > 96 && input.charAt(0) < 123);
  }
}
