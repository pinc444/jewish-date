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
 * Core Jewish date conversion functions.
 */
class JewishDateCalc {
    /**
     * Checks if the given year is a leap year according to the Jewish calendar.
     */
    public static function isLeapYear(year:Int):Bool {
        var yearIndex = year % 19;
        return yearIndex == 0 || yearIndex == 3 || yearIndex == 6 || yearIndex == 8 || yearIndex == 11 || yearIndex == 14
            || yearIndex == 17;
    }

    /**
     * Returns the index of the given Jewish month in the Jewish calendar.
     */
    public static function getIndexByJewishMonth(jewishMonth:JewishMonthName):Int {
        return switch (jewishMonth) {
            case None: 0;
            case Tishri: 7;
            case Cheshvan: 8;
            case Kislev: 9;
            case Tevet: 10;
            case Shevat: 11;
            case Adar: 12;
            case AdarI: 12;
            case AdarII: 13;
            case Nisan: 1;
            case Iyyar: 2;
            case Sivan: 3;
            case Tammuz: 4;
            case Av: 5;
            case Elul: 6;
        };
    }

    /**
     * Returns the Jewish month corresponding to the given index.
     */
    public static function getJewishMonthByIndex(index:Int, jewishYear:Int):JewishMonthName {
        var jewishMonths:Array<JewishMonthName> = [
            None, Nisan, Iyyar, Sivan, Tammuz, Av, Elul, Tishri, Cheshvan, Kislev, Tevet, Shevat, Adar, AdarII
        ];

        var month = if (index >= 0 && index < jewishMonths.length) jewishMonths[index] else None;
        if (month == Adar && isLeapYear(jewishYear)) {
            return AdarI;
        }
        return month;
    }

    /**
     * Returns an array of the Jewish month names in the correct order for the given year.
     */
    public static function getJewishMonthsInOrder(year:Int):Array<JewishMonthName> {
        var jewishMonthsInOrder:Array<JewishMonthName> = [
            None, Tishri, Cheshvan, Kislev, Tevet, Shevat, AdarI, AdarII, Nisan, Iyyar, Sivan, Tammuz, Av, Elul
        ];

        if (isLeapYear(year)) {
            return jewishMonthsInOrder;
        }

        // Non-leap year: remove AdarII and rename AdarI to Adar
        var result:Array<JewishMonthName> = [];
        for (m in jewishMonthsInOrder) {
            if (m == AdarII) continue;
            if (m == AdarI) {
                result.push(Adar);
            } else {
                result.push(m);
            }
        }
        return result;
    }

    /**
     * Returns the string name of a Jewish month.
     */
    public static function monthNameToString(month:JewishMonthName):String {
        return switch (month) {
            case None: "None";
            case Tishri: "Tishri";
            case Cheshvan: "Cheshvan";
            case Kislev: "Kislev";
            case Tevet: "Tevet";
            case Shevat: "Shevat";
            case Adar: "Adar";
            case AdarI: "AdarI";
            case AdarII: "AdarII";
            case Nisan: "Nisan";
            case Iyyar: "Iyyar";
            case Sivan: "Sivan";
            case Tammuz: "Tammuz";
            case Av: "Av";
            case Elul: "Elul";
        };
    }

    /**
     * Formats a Jewish date as a string.
     * @param jewishDate The Jewish date to format.
     * @param pattern Optional format pattern (default: "d MMMM yyyy").
     * @return Formatted date string.
     */
    public static function formatJewishDate(jewishDate:JewishDate, ?pattern:String):String {
        var formatPattern = if (pattern != null) pattern else FormatUtils.DEFAULT_PATTERN;
        var components:FormatComponents = {
            day: jewishDate.day,
            month: jewishDate.month,
            monthName: monthNameToString(jewishDate.monthName),
            year: jewishDate.year
        };
        return FormatUtils.formatWithPattern(formatPattern, components, FormatUtils.englishFormatter);
    }

    /**
     * Converts a Gregorian date (year, month 1-indexed, day) to a Jewish date.
     */
    public static function toJewishDateFromParts(year:Int, month:Int, day:Int):JewishDate {
        var jd = DateUtils.gregorianToJd(year, month, day);
        var jewishDateArr = DateUtils.jdToHebrew(jd);
        var jewishYear = jewishDateArr[0];
        var jewishMonthName = getJewishMonthByIndex(jewishDateArr[1], jewishYear);
        var monthsInOrder = getJewishMonthsInOrder(jewishYear);

        var jewishMonth = 0;
        for (i in 0...monthsInOrder.length) {
            if (Type.enumEq(monthsInOrder[i], jewishMonthName)) {
                jewishMonth = i;
                break;
            }
        }

        return {
            year: jewishYear,
            monthName: jewishMonthName,
            month: jewishMonth,
            day: jewishDateArr[2]
        };
    }

    /**
     * Converts a Jewish date to Gregorian date parts [year, month (1-indexed), day].
     */
    public static function toGregorianDateParts(jewishDate:BasicJewishDate):Array<Int> {
        var jewishMonth = getIndexByJewishMonth(jewishDate.monthName);
        var jd = DateUtils.hebrewToJd(jewishDate.year, jewishMonth, jewishDate.day);
        return DateUtils.jdToGregorian(jd);
    }

    /**
     * Calculates the number of days in a Jewish month for a given Jewish year.
     */
    public static function calcDaysInMonth(jewishYear:Int, jewishMonth:JewishMonthName):Int {
        var jewishMonthIndex = getIndexByJewishMonth(jewishMonth);
        return DateUtils.hebrewMonthDays(jewishYear, jewishMonthIndex);
    }

    /**
     * Converts a string month name to a JewishMonthName enum value.
     */
    public static function stringToMonthName(name:String):JewishMonthName {
        return switch (name) {
            case "Tishri": Tishri;
            case "Cheshvan": Cheshvan;
            case "Kislev": Kislev;
            case "Tevet": Tevet;
            case "Shevat": Shevat;
            case "Adar": Adar;
            case "AdarI": AdarI;
            case "AdarII": AdarII;
            case "Nisan": Nisan;
            case "Iyyar": Iyyar;
            case "Sivan": Sivan;
            case "Tammuz": Tammuz;
            case "Av": Av;
            case "Elul": Elul;
            default: None;
        };
    }
}
