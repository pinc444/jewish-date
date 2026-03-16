/**
 * Copyright (c) Shmulik Kravitz.
 *
 * This source code is licensed under the MIT license.
 * See the LICENSE file in the root directory for more information.
 */

package jewishdate;

/**
 * Utility functions for number formatting.
 */
class NumberUtils {
    /**
     * Pads a number with leading zeros until it reaches the desired length.
     */
    public static function toLength(num:Int, len:Int):String {
        var s = Std.string(num);
        while (s.length < len) {
            s = "0" + s;
        }
        return s;
    }
}
