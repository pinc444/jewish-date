/**
 * Test suite for the jewish-date library.
 * Ports the original TypeScript vitest tests to pure Haxe.
 */
import jewishdate.Types;
import jewishdate.JewishDateCalc;
import jewishdate.JewishDateHebrew;
import jewishdate.DateUtils;
import jewishdate.NumberUtils;
import jewishdate.Gematriya;

class TestAll {
    static var passed:Int = 0;
    static var failed:Int = 0;

    static function println(s:String):Void {
        #if sys
        Sys.println(s);
        #elseif js
        js.Syntax.code("console.log")(s);
        #else
        trace(s);
        #end
    }

    static function doAssert(condition:Bool, message:String):Void {
        if (condition) {
            passed++;
            println('  pass: $message');
        } else {
            failed++;
            println('  FAIL: $message');
        }
    }

    static function assertEqual<T>(actual:T, expected:T, message:String):Void {
        if (actual == expected) {
            passed++;
            println('  pass: $message');
        } else {
            failed++;
            println('  FAIL: $message (expected: $expected, got: $actual)');
        }
    }

    static function describe(name:String, fn:Void->Void):Void {
        println('\n$name');
        fn();
    }

    static function formatGregorianDate(year:Int, month:Int, day:Int):String {
        return NumberUtils.toLength(year, 4) + "-" + NumberUtils.toLength(month, 2) + "-" + NumberUtils.toLength(day, 2);
    }

    static function testJewishDate():Void {
        describe("jewishDate", function() {
            assertEqual(JewishDateCalc.getIndexByJewishMonth(Cheshvan), 8, "Get index by jewish month (Cheshvan=8)");

            doAssert(JewishDateCalc.isLeapYear(5782), "5782 is a leap year");
            doAssert(!JewishDateCalc.isLeapYear(5781), "5781 is not a leap year");

            var months5781 = JewishDateCalc.getJewishMonthsInOrder(5781);
            doAssert(Type.enumEq(months5781[12], JewishMonthName.Elul), "12th month of 5781 is Elul");

            var months5782 = JewishDateCalc.getJewishMonthsInOrder(5782);
            doAssert(Type.enumEq(months5782[12], JewishMonthName.Av), "12th month of 5782 is Av");

            var jd1 = JewishDateCalc.toJewishDateFromParts(2022, 9, 26);
            assertEqual(JewishDateCalc.formatJewishDate(jd1), "1 Tishri 5783", "Format jewish date");
            assertEqual(JewishDateCalc.formatJewishDate(jd1, "d MMMM yyyy"), "1 Tishri 5783",
                "Format jewish date with default pattern");

            var jd2 = JewishDateCalc.toJewishDateFromParts(2023, 4, 26);
            assertEqual(JewishDateCalc.formatJewishDate(jd2, "dd/MM/yyyy"), "05/08/5783",
                "Format jewish date with dd/MM/yyyy");
            assertEqual(JewishDateCalc.formatJewishDate(jd2, "MMMM d, yyyy"), "Iyyar 5, 5783",
                "Format jewish date with MMMM d, yyyy");
            assertEqual(JewishDateCalc.formatJewishDate(jd2, "d/M/yy"), "5/8/83",
                "Format jewish date with short year yy");
            assertEqual(JewishDateCalc.formatJewishDate(jd2, "yyyy-MM-dd"), "5783-08-05",
                "Format jewish date with yyyy-MM-dd");
            assertEqual(JewishDateCalc.formatJewishDate(jd2, "d MMMM yyyy!"), "5 Iyyar 5783!",
                "Format jewish date with trailing literal text");
            assertEqual(JewishDateCalc.formatJewishDate(jd2, "D MMMM YYYY"), "5 Iyyar 5783",
                "Format jewish date with uppercase D and YYYY tokens");
            assertEqual(JewishDateCalc.formatJewishDate(jd2, "d/M/YY"), "5/8/83",
                "Format jewish date with uppercase YY token");

            assertEqual(JewishDateCalc.getIndexByJewishMonth(None), 0,
                "Get index by jewish month with None");

            doAssert(Type.enumEq(JewishDateCalc.getJewishMonthByIndex(8, 5783), JewishMonthName.Cheshvan),
                "Get jewish month by index (8=Cheshvan)");
            doAssert(Type.enumEq(JewishDateCalc.getJewishMonthByIndex(15, 5783), JewishMonthName.None),
                "Get jewish month by index with invalid value");

            var jd3 = JewishDateCalc.toJewishDateFromParts(2023, 4, 26);
            assertEqual(jd3.year, 5783, "Convert 2023-04-26: year");
            assertEqual(jd3.month, 8, "Convert 2023-04-26: month");
            doAssert(Type.enumEq(jd3.monthName, JewishMonthName.Iyyar), "Convert 2023-04-26: monthName");
            assertEqual(jd3.day, 5, "Convert 2023-04-26: day");

            var jd4 = JewishDateCalc.toJewishDateFromParts(2022, 2, 2);
            assertEqual(jd4.year, 5782, "Convert 2022-02-02: year");
            assertEqual(jd4.month, 6, "Convert 2022-02-02: month");
            doAssert(Type.enumEq(jd4.monthName, JewishMonthName.AdarI), "Convert 2022-02-02: monthName");
            assertEqual(jd4.day, 1, "Convert 2022-02-02: day");

            var jd5 = JewishDateCalc.toJewishDateFromParts(2022, 9, 26);
            assertEqual(jd5.year, 5783, "Convert 2022-09-26: year");
            assertEqual(jd5.month, 1, "Convert 2022-09-26: month");
            doAssert(Type.enumEq(jd5.monthName, JewishMonthName.Tishri), "Convert 2022-09-26: monthName");
            assertEqual(jd5.day, 1, "Convert 2022-09-26: day");

            var jd6 = JewishDateCalc.toJewishDateFromParts(2023, 3, 23);
            assertEqual(jd6.year, 5783, "Convert 2023-03-23: year");
            assertEqual(jd6.month, 7, "Convert 2023-03-23: month");
            doAssert(Type.enumEq(jd6.monthName, JewishMonthName.Nisan), "Convert 2023-03-23: monthName");
            assertEqual(jd6.day, 1, "Convert 2023-03-23: day");

            var jd7 = JewishDateCalc.toJewishDateFromParts(1835, 9, 24);
            assertEqual(jd7.year, 5596, "Convert 1835-09-24: year");
            assertEqual(jd7.month, 1, "Convert 1835-09-24: month");
            doAssert(Type.enumEq(jd7.monthName, JewishMonthName.Tishri), "Convert 1835-09-24: monthName");
            assertEqual(jd7.day, 1, "Convert 1835-09-24: day");

            var jd8 = JewishDateCalc.toJewishDateFromParts(1901, 1, 1);
            assertEqual(jd8.year, 5661, "Convert 1901-01-01: year");
            assertEqual(jd8.month, 4, "Convert 1901-01-01: month");
            doAssert(Type.enumEq(jd8.monthName, JewishMonthName.Tevet), "Convert 1901-01-01: monthName");
            assertEqual(jd8.day, 10, "Convert 1901-01-01: day");

            var jd9 = JewishDateCalc.toJewishDateFromParts(1, 1, 1);
            assertEqual(jd9.year, 3761, "Convert 0001-01-01: year");
            assertEqual(jd9.month, 4, "Convert 0001-01-01: month");
            doAssert(Type.enumEq(jd9.monthName, JewishMonthName.Tevet), "Convert 0001-01-01: monthName");
            assertEqual(jd9.day, 18, "Convert 0001-01-01: day");

            var gd1 = JewishDateCalc.toGregorianDateParts({year: 5782, monthName: AdarI, day: 1});
            assertEqual(formatGregorianDate(gd1[0], gd1[1], gd1[2]), "2022-02-02",
                "Convert 5782-AdarI-01 to Gregorian");

            var gd2 = JewishDateCalc.toGregorianDateParts({year: 5782, monthName: AdarII, day: 1});
            assertEqual(formatGregorianDate(gd2[0], gd2[1], gd2[2]), "2022-03-04",
                "Convert 5782-AdarII-01 to Gregorian");

            var gd3 = JewishDateCalc.toGregorianDateParts({year: 5761, monthName: Tevet, day: 18});
            assertEqual(formatGregorianDate(gd3[0], gd3[1], gd3[2]), "2001-01-13",
                "Convert 5761-Tevet-18 to Gregorian");

            var gd4 = JewishDateCalc.toGregorianDateParts({year: 5783, monthName: Nisan, day: 16});
            assertEqual(formatGregorianDate(gd4[0], gd4[1], gd4[2]), "2023-04-07",
                "Convert 5783-Nisan-16 to Gregorian");

            var gd5 = JewishDateCalc.toGregorianDateParts({year: 5784, monthName: Kislev, day: 1});
            assertEqual(formatGregorianDate(gd5[0], gd5[1], gd5[2]), "2023-11-14",
                "Convert 5784-Kislev-1 to Gregorian");

            var gd6 = JewishDateCalc.toGregorianDateParts({year: 3761, monthName: Tevet, day: 18});
            assertEqual(formatGregorianDate(gd6[0], gd6[1], gd6[2]), "0001-01-01",
                "Convert 3761-Tevet-18 to Gregorian");

            var gd7 = JewishDateCalc.toGregorianDateParts({year: 3760, monthName: Shevat, day: 8});
            assertEqual(formatGregorianDate(gd7[0], gd7[1], gd7[2]), "0000-01-01",
                "Convert 3760-Shevat-8 to Gregorian");

            assertEqual(JewishDateCalc.calcDaysInMonth(5784, Cheshvan), 29, "Days in Cheshvan 5784");
            assertEqual(JewishDateCalc.calcDaysInMonth(5783, Cheshvan), 30, "Days in Cheshvan 5783");
        });
    }

    static function testJewishDateHebrew():Void {
        describe("jewishDateHebrew", function() {
            assertEqual(JewishDateHebrew.convertNumberToHebrew(5783), "התשפ״ג",
                "Convert number to hebrew (5783)");

            assertEqual(JewishDateHebrew.getJewishMonthInHebrew(Iyyar), "אייר",
                "Get jewish month in hebrew (Iyyar)");

            var jd = JewishDateCalc.toJewishDateFromParts(2022, 9, 26);
            var hebrewDate = JewishDateHebrew.toHebrewJewishDate(jd);
            assertEqual(hebrewDate.day, "א׳", "To hebrew jewish date: day");
            assertEqual(hebrewDate.monthName, "תשרי", "To hebrew jewish date: monthName");
            assertEqual(hebrewDate.year, "התשפ״ג", "To hebrew jewish date: year");

            assertEqual(JewishDateHebrew.formatJewishDateInHebrew(jd), "א׳ תשרי התשפ״ג",
                "Format jewish date in hebrew");

            assertEqual(JewishDateHebrew.convertYearToShortHebrew(5783), "פ״ג",
                "Convert year to short hebrew");

            assertEqual(JewishDateHebrew.formatJewishDateInHebrew(jd, "D MMMM YYYY"), "א׳ תשרי התשפ״ג",
                "Format in hebrew with gematria pattern");

            var jd2 = JewishDateCalc.toJewishDateFromParts(2023, 4, 26);
            assertEqual(JewishDateHebrew.formatJewishDateInHebrew(jd2, "dd/MM/yyyy"), "05/02/5783",
                "Format in hebrew with dd/MM/yyyy");
            assertEqual(JewishDateHebrew.formatJewishDateInHebrew(jd2, "d/M/yy"), "5/2/83",
                "Format in hebrew with d/M/yy");
            assertEqual(JewishDateHebrew.formatJewishDateInHebrew(jd2, "D/MM/YY"), "ה׳/02/פ״ג",
                "Format in hebrew with D/MM/YY");
            assertEqual(JewishDateHebrew.formatJewishDateInHebrew(jd2, "d MMMM yyyy"), "5 אייר 5783",
                "Format in hebrew with mixed numeric and Hebrew");
        });
    }

    static function testDateUtils():Void {
        describe("dateUtils", function() {
            assertEqual(DateUtils.mod(20, 15), 5.0, "mod(20, 15) = 5");
            assertEqual(DateUtils.mod(-1, 5), 4.0, "mod(-1, 5) = 4");
        });
    }

    static function testGematriya():Void {
        describe("gematriya", function() {
            assertEqual(Gematriya.toHebrew(1), "א׳", "1 = aleph");
            assertEqual(Gematriya.toHebrew(5), "ה׳", "5 = he");
            assertEqual(Gematriya.toHebrew(10), "י׳", "10 = yod");
            assertEqual(Gematriya.toHebrew(15), "ט״ו", "15 = tet-vav (special case)");
            assertEqual(Gematriya.toHebrew(16), "ט״ז", "16 = tet-zayin (special case)");
            assertEqual(Gematriya.toHebrew(100), "ק׳", "100 = qof");
            assertEqual(Gematriya.toHebrew(400), "ת׳", "400 = tav");
            assertEqual(Gematriya.toHebrew(500), "ת״ק", "500 = tav-qof");
            assertEqual(Gematriya.toHebrew(770), "תש״ע", "770 = tav-shin-ayin");
            assertEqual(Gematriya.toHebrew(5783), "התשפ״ג", "5783 = he-tav-shin-pe-gimel");
        });
    }

    public static function main():Void {
        println("Running jewish-date tests...");

        testDateUtils();
        testGematriya();
        testJewishDate();
        testJewishDateHebrew();

        println('\n========================================');
        println('Results: $passed passed, $failed failed');
        println('========================================');

        if (failed > 0) {
            #if sys
            Sys.exit(1);
            #elseif js
            js.Syntax.code("console.error")("Tests failed!");
            js.Syntax.code("if (typeof process !== 'undefined') process.exit(1)");
            #end
        }
    }
}
