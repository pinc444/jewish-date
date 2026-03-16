/**
 * Copyright (c) Shmulik Kravitz.
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory for more information.
 */

package jewishdate;

/**
 * Enumeration of Jewish month names.
 */
enum JewishMonthName {
    None;
    Tishri;
    Cheshvan;
    Kislev;
    Tevet;
    Shevat;
    Adar;
    Nisan;
    Iyyar;
    Sivan;
    Tammuz;
    Av;
    Elul;
    AdarI;
    AdarII;
}

/**
 * Represents a basic Jewish date with day, month name, and year.
 */
typedef BasicJewishDate = {
    /** Day of month */
    day:Int,
    /** Month name */
    monthName:JewishMonthName,
    /** Year */
    year:Int
};

/**
 * Represents a Jewish date with day, month name, month index, and year.
 */
typedef JewishDate = {
    > BasicJewishDate,
    /** Month index in the year's month order */
    month:Int
};

/**
 * Represents a Jewish date with Hebrew string values.
 */
typedef BasicJewishDateHebrew = {
    /** Day of month in Hebrew */
    day:String,
    /** Month name in Hebrew */
    monthName:String,
    /** Year in Hebrew */
    year:String
};
