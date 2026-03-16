<h1 align="center">
<a href="https://github.com/pinc444/jewish-date"><img src="assets/jewish-date.svg" alt="Jewish Date" /></a>
</h1>

<p align="center">Jewish Date is a fast and lightweight alternative to hebcal with an MIT license.</p>
<p align="center">
  <a href="https://github.com/pinc444/jewish-date/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" />
  </a>
  <img src="https://github.com/pinc444/jewish-date/actions/workflows/main.yml/badge.svg" alt="Build Status" />
</p>

> Jewish Date is a pure Haxe library that provides Gregorian-to-Hebrew and Hebrew-to-Gregorian date conversion. It compiles to JavaScript and has zero runtime dependencies.

- 📦 Pure Haxe — no external dependencies
- 📜 MIT License
- 🔧 Easy to use
- 💻 Compiles to JavaScript (and other Haxe targets)

# Getting Started

## Installation

Install via haxelib:

```console
haxelib install jewish-date
```

Or use as a Git dependency in your `haxelib.json`:

```json
{
  "dependencies": {
    "jewish-date": "git:https://github.com/pinc444/jewish-date.git"
  }
}
```

## Usage

### Haxe Example

```haxe
import jewishdate.JewishDateCalc;
import jewishdate.JewishDateHebrew;
import jewishdate.Types;

class Main {
    static function main() {
        // Convert Gregorian date to Jewish date
        // Parameters: year, month (1-indexed), day
        var jewishDate = JewishDateCalc.toJewishDateFromParts(2023, 5, 9);
        // jewishDate = { year: 5783, monthName: Iyyar, month: 8, day: 18 }

        // Format in English
        var english = JewishDateCalc.formatJewishDate(jewishDate);
        trace(english); // "18 Iyyar 5783"

        // Format with custom pattern
        var formatted = JewishDateCalc.formatJewishDate(jewishDate, "dd/MM/yyyy");
        trace(formatted); // "18/08/5783"

        // Convert to Hebrew
        var hebrewDate = JewishDateHebrew.toHebrewJewishDate(jewishDate);
        // hebrewDate = { day: "י״ח", monthName: "אייר", year: "התשפ״ג" }

        // Format in Hebrew
        var hebrewStr = JewishDateHebrew.formatJewishDateInHebrew(jewishDate);
        trace(hebrewStr); // "י״ח אייר התשפ״ג"

        // Format in Hebrew with custom pattern (gematria)
        var hebrewFormatted = JewishDateHebrew.formatJewishDateInHebrew(jewishDate, "D/MM/YY");
        trace(hebrewFormatted); // "י״ח/02/פ״ג"

        // Convert back to Gregorian
        var gregParts = JewishDateCalc.toGregorianDateParts({
            year: 5783,
            monthName: Iyyar,
            day: 18
        });
        trace(gregParts); // [2023, 5, 9]
    }
}
```

### Building to JavaScript

Add to your `.hxml` build file:

```
-lib jewish-date
-cp src
-main Main
-js output.js
```

## API Reference

### JewishDateCalc

| Function | Description |
| --- | --- |
| `toJewishDateFromParts(year, month, day)` | Convert Gregorian date parts (month is 1-indexed) to a Jewish date |
| `toGregorianDateParts(jewishDate)` | Convert a Jewish date to Gregorian date parts `[year, month, day]` |
| `formatJewishDate(jewishDate, ?pattern)` | Format a Jewish date as an English string |
| `isLeapYear(year)` | Check if a Jewish year is a leap year |
| `getJewishMonthsInOrder(year)` | Get the month names in order for a given year |
| `calcDaysInMonth(year, month)` | Get the number of days in a Jewish month |

### JewishDateHebrew

| Function | Description |
| --- | --- |
| `toHebrewJewishDate(jewishDate)` | Convert a Jewish date to Hebrew strings |
| `formatJewishDateInHebrew(jewishDate, ?pattern)` | Format a Jewish date as a Hebrew string |
| `convertNumberToHebrew(num)` | Convert a number to Hebrew gematria |
| `getJewishMonthInHebrew(month)` | Get the Hebrew name of a Jewish month |

## Format Patterns

Both `formatJewishDate` and `formatJewishDateInHebrew` accept an optional pattern string. The pattern uses tokens similar to [date-fns](https://date-fns.org/docs/format).

### Supported Tokens

| Token  | Description              | `formatJewishDate` | `formatJewishDateInHebrew` |
| ------ | ------------------------ | ------------------ | -------------------------- |
| `d`    | Day (numeric)            | 8                  | 8                          |
| `dd`   | Day (zero-padded)        | 08                 | 08                         |
| `D`    | Day (gematria in Hebrew) | 8                  | ח׳                         |
| `M`    | Month number             | 2                  | 2                          |
| `MM`   | Month number (padded)    | 02                 | 02                         |
| `MMMM` | Month name               | Iyyar              | אייר                       |
| `yy`   | Year short (numeric)     | 83                 | 83                         |
| `YY`   | Year short (gematria)    | 83                 | פ״ג                        |
| `yyyy` | Year full (numeric)      | 5783               | 5783                       |
| `YYYY` | Year full (gematria)     | 5783               | התשפ״ג                     |

## Building from Source

### Prerequisites

- [Haxe](https://haxe.org/download/) 4.x or later

### Build

```console
haxe build.hxml
```

### Run Tests

```console
haxe test.hxml && node dist/test.js
```

# License

Jewish Date is licensed under a [MIT License](./LICENSE).
