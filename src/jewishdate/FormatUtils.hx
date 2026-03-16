/**
 * Copyright (c) Shmulik Kravitz.
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory for more information.
 */

package jewishdate;

/**
 * Represents the components needed for formatting a Jewish date.
 */
typedef FormatComponents = {
    day:Int,
    month:Int,
    monthName:String,
    year:Int
};

/**
 * Pattern-based date formatting utilities.
 */
class FormatUtils {
    /** Default pattern for formatting Jewish dates (numeric). */
    public static inline var DEFAULT_PATTERN:String = "d MMMM yyyy";

    /** Default pattern for formatting Jewish dates in Hebrew (gematria). */
    public static inline var DEFAULT_PATTERN_HEBREW:String = "D MMMM YYYY";

    /** Token patterns ordered longest first to avoid partial matches. */
    static var TOKEN_PATTERNS:Array<String> = ["yyyy", "YYYY", "yy", "YY", "MMMM", "MM", "M", "dd", "D", "d"];

    /**
     * Finds all tokens in the pattern string and returns them with their positions.
     */
    static function findTokens(pattern:String):Array<{token:String, index:Int}> {
        var matches:Array<{token:String, index:Int}> = [];
        var searchStart = 0;

        while (searchStart < pattern.length) {
            var foundMatch:Null<{token:String, index:Int}> = null;

            for (token in TOKEN_PATTERNS) {
                if (searchStart + token.length <= pattern.length && pattern.substr(searchStart, token.length) == token) {
                    foundMatch = {token: token, index: searchStart};
                    break;
                }
            }

            if (foundMatch != null) {
                matches.push(foundMatch);
                searchStart = foundMatch.index + foundMatch.token.length;
            } else {
                searchStart++;
            }
        }

        return matches;
    }

    /**
     * Formats a date using the given pattern and a formatter function.
     * The formatter function receives a token string and the components, and returns
     * the formatted value for that token.
     */
    public static function formatWithPattern(pattern:String, components:FormatComponents,
            formatter:String->FormatComponents->String):String {
        var tokens = findTokens(pattern);
        var result = new StringBuf();
        var lastIndex = 0;

        for (match in tokens) {
            if (match.index > lastIndex) {
                result.add(pattern.substr(lastIndex, match.index - lastIndex));
            }
            result.add(formatter(match.token, components));
            lastIndex = match.index + match.token.length;
        }

        if (lastIndex < pattern.length) {
            result.add(pattern.substr(lastIndex));
        }

        return result.toString();
    }

    /**
     * English (numeric) formatter for a given token.
     */
    public static function englishFormatter(token:String, c:FormatComponents):String {
        return switch (token) {
            case "d": Std.string(c.day);
            case "dd": NumberUtils.toLength(c.day, 2);
            case "D": Std.string(c.day);
            case "M": Std.string(c.month);
            case "MM": NumberUtils.toLength(c.month, 2);
            case "MMMM": c.monthName;
            case "yy": NumberUtils.toLength(c.year % 100, 2);
            case "YY": NumberUtils.toLength(c.year % 100, 2);
            case "yyyy": Std.string(c.year);
            case "YYYY": Std.string(c.year);
            default: token;
        };
    }
}
