/**
 * Copyright (c) Shmulik Kravitz.
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory for more information.
 */

package jewishdate;

/**
 * Utility functions for Julian day and calendar date conversions.
 */
class DateUtils {
    static inline var GREGORIAN_EPOCH:Float = 1721425.5;
    static inline var HEBREW_EPOCH:Float = 347995.5;

    /**
     * Computes the remainder of the division of `a` by `b`.
     * Unlike the standard modulo operator, this handles negative numbers properly.
     */
    public static function mod(a:Float, b:Float):Float {
        return a - b * Math.floor(a / b);
    }

    /**
     * Determines if a given year is a leap year in the Gregorian calendar.
     */
    static function leapGregorian(year:Int):Bool {
        return year % 4 == 0 && !(year % 100 == 0 && year % 400 != 0);
    }

    /**
     * Converts Gregorian date to Julian Day.
     */
    public static function gregorianToJd(year:Int, month:Int, day:Int):Float {
        var leapAdj:Float = if (month <= 2) 0 else if (leapGregorian(year)) -1 else -2;
        return GREGORIAN_EPOCH - 1 + 365 * (year - 1) + Math.floor((year - 1) / 4)
            - Math.floor((year - 1) / 100) + Math.floor((year - 1) / 400)
            + Math.floor((367 * month - 362) / 12 + leapAdj + day);
    }

    /**
     * Converts a Julian day number to Gregorian date.
     * Returns [year, month, day].
     */
    public static function jdToGregorian(jd:Float):Array<Int> {
        var wjd:Float = Math.floor(jd - 0.5) + 0.5;
        var depoch:Float = wjd - GREGORIAN_EPOCH;
        var quadricent:Float = Math.floor(depoch / 146097);
        var dqc:Float = mod(depoch, 146097);
        var cent:Float = Math.floor(dqc / 36524);
        var dcent:Float = mod(dqc, 36524);
        var quad:Float = Math.floor(dcent / 1461);
        var dquad:Float = mod(dcent, 1461);
        var yindex:Float = Math.floor(dquad / 365);
        var year:Int = Std.int(quadricent * 400 + cent * 100 + quad * 4 + yindex);
        if (!(cent == 4 || yindex == 4)) {
            year++;
        }
        var yearday:Float = wjd - gregorianToJd(year, 1, 1);
        var leapadj:Float = if (wjd < gregorianToJd(year, 3, 1)) 0 else if (leapGregorian(year)) 1 else 2;
        var month:Int = Std.int(Math.floor(((yearday + leapadj) * 12 + 373) / 367));
        var day:Int = Std.int(wjd - gregorianToJd(year, month, 1) + 1);
        return [year, month, day];
    }

    /**
     * Determines if a Hebrew year is a leap year.
     */
    static function hebrewLeap(year:Int):Bool {
        return mod(year * 7 + 1, 19) < 7;
    }

    /**
     * Returns the number of months in a Hebrew year.
     */
    static function hebrewYearMonths(year:Int):Int {
        return if (hebrewLeap(year)) 13 else 12;
    }

    /**
     * Calculates the delay of the start of the Hebrew year (dechiya rules).
     */
    static function calculateHebrewYearStartDelay(year:Int):Int {
        var months:Int = Std.int(Math.floor((235.0 * year - 234) / 19));
        var parts:Int = 12084 + 13753 * months;
        var day:Int = months * 29 + Std.int(Math.floor(parts / 25920.0));
        if (mod(3.0 * (day + 1), 7) < 3) {
            day++;
        }
        return day;
    }

    /**
     * Calculates the delay of the start of the Hebrew year due to adjacent year lengths.
     */
    static function calculateHebrewYearAdjacentDelay(year:Int):Int {
        var last = calculateHebrewYearStartDelay(year - 1);
        var present = calculateHebrewYearStartDelay(year);
        var next = calculateHebrewYearStartDelay(year + 1);
        return if (next - present == 356) 2 else if (present - last == 382) 1 else 0;
    }

    /**
     * Calculates the number of days in a Hebrew year.
     */
    static function hebrewYearDays(year:Int):Int {
        return Std.int(hebrewToJd(year + 1, 7, 1) - hebrewToJd(year, 7, 1));
    }

    /**
     * Calculates the number of days in the specified month of the Hebrew year.
     */
    public static function hebrewMonthDays(year:Int, month:Int):Int {
        if (month == 2 || month == 4 || month == 6 || month == 10 || month == 13) {
            return 29;
        }
        if (month == 12 && !hebrewLeap(year)) {
            return 29;
        }
        if (month == 8 && !(mod(hebrewYearDays(year), 10) == 5)) {
            return 29;
        }
        if (month == 9 && mod(hebrewYearDays(year), 10) == 3) {
            return 29;
        }
        return 30;
    }

    /**
     * Converts a Hebrew date to the corresponding Julian day.
     */
    public static function hebrewToJd(year:Int, month:Int, day:Int):Float {
        var months = hebrewYearMonths(year);
        var jd:Float = HEBREW_EPOCH + calculateHebrewYearStartDelay(year) + calculateHebrewYearAdjacentDelay(year) + day + 1;

        if (month < 7) {
            var mon = 7;
            while (mon <= months) {
                jd += hebrewMonthDays(year, mon);
                mon++;
            }
            mon = 1;
            while (mon < month) {
                jd += hebrewMonthDays(year, mon);
                mon++;
            }
        } else {
            var mon = 7;
            while (mon < month) {
                jd += hebrewMonthDays(year, mon);
                mon++;
            }
        }

        return jd;
    }

    /**
     * Converts a Julian date to a Hebrew date.
     * Returns [year, month, day].
     */
    public static function jdToHebrew(julianDate:Float):Array<Int> {
        var jd:Float = Math.floor(julianDate) + 0.5;
        var count:Int = Std.int(Math.floor(((jd - HEBREW_EPOCH) * 98496.0) / 35975351.0));
        var year:Int = count - 1;
        var i = count;
        while (jd >= hebrewToJd(i, 7, 1)) {
            year++;
            i++;
        }
        var first:Int = if (jd < hebrewToJd(year, 1, 1)) 7 else 1;
        var month:Int = first;
        i = first;
        while (jd > hebrewToJd(year, i, hebrewMonthDays(year, i))) {
            month++;
            i++;
        }
        var day:Int = Std.int(jd - hebrewToJd(year, month, 1) + 1);
        return [year, month, day];
    }
}
