/**
 * Copyright (c) Shmulik Kravitz.
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory for more information.
 */

package jewishdate;

import jewishdate.Types;
import jewishdate.FormatUtils;

/**
 * Hebrew formatting functions for Jewish dates.
 */
class JewishDateHebrew {
    /**
     * Returns the name of a Jewish month in Hebrew.
     */
    public static function getJewishMonthInHebrew(jewishMonth:JewishMonthName):String {
        return switch (jewishMonth) {
            case None: "ללא";
            case Tishri: "תשרי";
            case Cheshvan: "חשון";
            case Kislev: "כסלו";
            case Tevet: "טבת";
            case Shevat: "שבט";
            case Adar: "אדר";
            case AdarI: "אדר א";
            case AdarII: "אדר ב";
            case Nisan: "ניסן";
            case Iyyar: "אייר";
            case Sivan: "סיון";
            case Tammuz: "תמוז";
            case Av: "אב";
            case Elul: "אלול";
        };
    }

    /**
     * Converts a number to its Hebrew gematriya representation.
     */
    public static function convertNumberToHebrew(num:Int, addGeresh:Bool = true, addPunctuate:Bool = true):String {
        return Gematriya.toHebrew(num, addGeresh, addPunctuate);
    }

    /**
     * Converts a year to its short Hebrew equivalent (last two significant digits).
     */
    public static function convertYearToShortHebrew(year:Int):String {
        var shortYear = year % 100;
        return Gematriya.toHebrew(shortYear, true, true);
    }

    /**
     * Converts a basic Jewish date to a Hebrew date with Hebrew letters.
     */
    public static function toHebrewJewishDate(jewishDate:BasicJewishDate):BasicJewishDateHebrew {
        return {
            day: convertNumberToHebrew(jewishDate.day),
            monthName: getJewishMonthInHebrew(jewishDate.monthName),
            year: convertNumberToHebrew(jewishDate.year)
        };
    }

    /**
     * Hebrew formatter for a given token.
     */
    static function hebrewFormatter(token:String, c:FormatComponents):String {
        return switch (token) {
            case "d": Std.string(c.day);
            case "dd": NumberUtils.toLength(c.day, 2);
            case "D": convertNumberToHebrew(c.day);
            case "M": Std.string(c.month);
            case "MM": NumberUtils.toLength(c.month, 2);
            case "MMMM": getJewishMonthInHebrew(JewishDateCalc.stringToMonthName(c.monthName));
            case "yy": NumberUtils.toLength(c.year % 100, 2);
            case "YY": convertYearToShortHebrew(c.year);
            case "yyyy": Std.string(c.year);
            case "YYYY": convertNumberToHebrew(c.year);
            default: token;
        };
    }

    /**
     * Formats a Jewish date into a string representation in Hebrew.
     */
    public static function formatJewishDateInHebrew(jewishDate:BasicJewishDate, ?pattern:String):String {
        var formatPattern = if (pattern != null) pattern else FormatUtils.DEFAULT_PATTERN_HEBREW;
        var components:FormatComponents = {
            day: jewishDate.day,
            month: JewishDateCalc.getIndexByJewishMonth(jewishDate.monthName),
            monthName: JewishDateCalc.monthNameToString(jewishDate.monthName),
            year: jewishDate.year
        };
        return FormatUtils.formatWithPattern(formatPattern, components, hebrewFormatter);
    }
}
