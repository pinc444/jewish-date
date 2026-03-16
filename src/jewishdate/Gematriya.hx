/**
 * Copyright (c) Shmulik Kravitz.
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory for more information.
 */

package jewishdate;

/**
 * Pure Haxe implementation of Hebrew gematriya (number-to-Hebrew-letter conversion).
 * Based on the gematriya npm package algorithm by Eyal Schachter (MIT license).
 */
class Gematriya {
    /**
     * Map from numeric value to Hebrew letter(s).
     * Includes composite values for 500-1000.
     */
    static var letters:Map<Int, String> = [
        0 => "",
        1 => "א",
        2 => "ב",
        3 => "ג",
        4 => "ד",
        5 => "ה",
        6 => "ו",
        7 => "ז",
        8 => "ח",
        9 => "ט",
        10 => "י",
        20 => "כ",
        30 => "ל",
        40 => "מ",
        50 => "נ",
        60 => "ס",
        70 => "ע",
        80 => "פ",
        90 => "צ",
        100 => "ק",
        200 => "ר",
        300 => "ש",
        400 => "ת",
        500 => "תק",
        600 => "תר",
        700 => "תש",
        800 => "תת",
        900 => "תתק",
        1000 => "תתר"
    ];

    /**
     * Converts a number to its Hebrew gematriya representation.
     * @param num The number to convert.
     * @param addGeresh Whether to add geresh/gershayim punctuation (default: true).
     * @param addPunctuate Whether to add punctuation (default: true).
     * @return The Hebrew gematriya string.
     */
    public static function toHebrew(num:Int, addGeresh:Bool = true, addPunctuate:Bool = true):String {
        if (num <= 0)
            return "";

        // Split number into individual digits
        var numStr = Std.string(num);
        var digits:Array<Int> = [];
        for (i in 0...numStr.length) {
            digits.push(Std.parseInt(numStr.charAt(i)));
        }
        // Reverse to process from least significant digit
        digits.reverse();

        // Map each digit to its Hebrew letter representation
        var mapped:Array<String> = [];
        for (i in 0...digits.length) {
            mapped.push(convertDigit(digits[i], i));
        }

        // Reverse back to get correct order (most significant first) and join
        mapped.reverse();
        var result = mapped.join("");

        // Replace divine name combinations
        result = StringTools.replace(result, "יה", "טו");
        result = StringTools.replace(result, "יו", "טז");

        // Add geresh/gershayim punctuation
        if (addPunctuate || addGeresh) {
            var chars = splitChars(result);
            if (chars.length == 1) {
                if (addGeresh) {
                    result = result + "׳";
                }
            } else if (chars.length > 1) {
                // Insert gershayim (״) before last character
                var lastChar = chars[chars.length - 1];
                var rest = new StringBuf();
                for (j in 0...chars.length - 1) {
                    rest.add(chars[j]);
                }
                result = rest.toString() + "״" + lastChar;
            }
        }

        return result;
    }

    /**
     * Converts a single digit at a given position to its Hebrew letter(s).
     * For values > 1000, recursively reduces by subtracting 3 from position.
     */
    static function convertDigit(digit:Int, position:Int):String {
        if (digit == 0)
            return "";
        var value = digit * Std.int(Math.round(Math.pow(10, position)));
        if (value > 1000) {
            return convertDigit(digit, position - 3);
        }
        var letter = letters.get(value);
        return if (letter != null) letter else "";
    }

    /**
     * Splits a string into individual Unicode characters.
     * Hebrew characters are multi-byte in UTF-8 but single code units in Haxe's UTF-16 strings.
     */
    static function splitChars(s:String):Array<String> {
        var result:Array<String> = [];
        var i = 0;
        while (i < s.length) {
            var code = StringTools.fastCodeAt(s, i);
            if (code >= 0xD800 && code <= 0xDBFF && i + 1 < s.length) {
                result.push(s.substr(i, 2));
                i += 2;
            } else {
                result.push(s.charAt(i));
                i++;
            }
        }
        return result;
    }
}
