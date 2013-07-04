/*
 * HellasParser.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.util.HashMap;
import java.util.Properties;
import java.util.TreeMap;
import java.util.*;
import java.util.List;
import java.util.ArrayList;


/** Parses sources encoded in Hellas.
 * @author Hugh A. Cayless
 */
public class HellasParser extends AbstractGreekParser {

    /** Creates new HellasParser */
    public HellasParser() {
        // debugging
        verbose = false;

        encoding = "UTF8";
        if (properties.isEmpty()) {
            hp = new Properties();
            ga = new Properties();
            synchronized(properties) {
                try {
                    Class c = this.getClass();
                    hp.load(c.getResourceAsStream("HellasParser.properties"));
                    ga.load(c.getResourceAsStream("GreekAccents.properties"));
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                    e.printStackTrace(System.out);
                }
                properties.put("hp", hp);
                properties.put("ga", ga);
            }
        } else {
            hp = properties.get("hp");
            ga = properties.get("ga");
        }
    }

    private static final HashMap<String,Properties> properties = new HashMap<String,Properties>();
    private Properties hp;
    private Properties ga;
    private StringBuffer strb = new StringBuffer();
    private TreeMap<String,String> map = new TreeMap<String,String>();
    private StringBuffer escape = new StringBuffer();
    private Stack<Character> specialPrefix = new Stack<Character>();
    private Stack<Integer> specialPrefixIndex  = new Stack<Integer>();

    /** Returns the next parsed character as a String.
     * @return The name of the parsed character.
     */
    public String next() {
        strb.delete(0,strb.length());
        if (in != null) {
            char ch = chArray[index];

            // reset flags, map, and escape
            map.clear();
            escape.delete(0,escape.length());

            do {
                // run once, and again if character is prefix
                // unless it is special prefix, in which case, just record it's occurence.
                if (isHellasSpecialPrefix(chArray[index])) {
                    specialPrefixIndex.push(index);
                    specialPrefix.push(chArray[index]);
                    log("Added Special  prefix " + Integer.toHexString(chArray[index] | 0x10000).substring(1));
                } else {
                    escape.append(chArray[index]);
                    log("Added caracter: '" + chArray[index] + "'");
                    log("Unicode: " + Integer.toHexString(chArray[index] | 0x10000).substring(1));

                }

                index++;

            } while(hasNext() && isHellasPrefix(chArray[index - 1]));

            log("String to test length : " + escape.length());

            while (escape.length() > 0) {
                String result = escape.toString();

                String prefixes = escape.substring(0, escape.length() - 1);
                String last = escape.substring(escape.length() - 1);

                // get all permutations of prefixes
                List<String> variations = permutation(prefixes);

                if (variations.size() == 0){
                    variations.add("");
                }

                perm:
                    for (String prefix: variations) {
                        String attempt = prefix + last;
                        result = lookup(attempt);

                        log("Looked up: '" + attempt.toString() + "' of length: " + attempt.length());

                        if (!result.equals(attempt.toString())) {
                            // result is different from  attempt -> we have found a match
                            break perm;
                        } else {
                            result = escape.toString();
                        }
                }


                if (result.equals(escape.toString())) {
                    // no matches found with this combination, let's reduce one character
                    escape.deleteCharAt(escape.length() - 1);
                    index -= 1;

                    log("special prefix stack size " + specialPrefixIndex.size());

                    if (specialPrefixIndex.size() > 0 ) {
                        if (index == specialPrefixIndex.peek()) {
                            // if special prefix at this location, remove it as well
                            specialPrefixIndex.pop();
                            specialPrefix.pop();
                            index -= 1;
                            log("Popped a specialprefix");
                        }
                    }


                } else {
                    // Valid match!
                    strb.append(result);
                    log("Appended " + result);
                    break;
                }
            }

            while (specialPrefix.size() > 0) {
                // append special prefixes as postfixes
                String special_prefix_postfixed = lookup(Character.toString(specialPrefix.pop()));
                specialPrefixIndex.pop();

                // add as postfix
                if (strb.length() > 0) {
                    strb.append('_');
                }
                strb.append(special_prefix_postfixed);
                log("appended special prefix as postfix " + special_prefix_postfixed);
            }

            if (strb.length() == 0) {
                if(isPunctuation(ch) || Character.isWhitespace(ch) || Character.isDigit(ch)) {
                    log("Puctuation or whitespace or digit");
                    strb.append(ch);
                    index++;
                } else {
                    strb.append(Character.toString((char) 0xFFFD));
                    log("Je ne comprends pas!");
                    index++;
                }
            }
        }
        log("Returns: '" + strb + "'\n");
        return strb.toString();
    }


    protected String lookup(String key) {
        return hp.getProperty(key, key);
    }

    protected String lookup(char ch) {
        String key = String.valueOf(ch);
        return lookup(key);
    }

    private String lookupAccent(char ch) {
        String key = String.valueOf(ch);
        return ga.getProperty(lookup(ch));
    }

    protected static boolean isHellasSpecialPrefix(char ch) {

        switch(ch) {
            case 0x00db: // macron
            case 0x2044:  // underdot
                return true;
            default:
                return false;
        }
    }

    protected static boolean isHellasPrefix(char ch) {
        switch (ch) {
            case '!':
            case '"':
            case '\'':
            case '&':
            case '(':
            case ')':
            case '{':
            case 0x201c: // “
            case 0x2018: // ‘
            case 0x00b6: // ¶
            case 0x00AB: // «
            case 0x00A1: // ¡
            case 0xa7: // §
            case 0xD4: // Ô
            case 0xE0: // à
            case 0xE7: // ç
            case 0xE8: // è
            case 0xE9: // é
            case 0xEF: // ï
            case 0xEB: // ë
                return true;
            default:
                return isHellasSpecialPrefix(ch);
        }
    }

    protected static boolean isPunctuation(char ch) {
        switch (ch) {
            case '.':
            case ',':
            case ':':
            case ';':
            case '_':
            case '-':
            case 0x00a0: // non-breaking space
            case 0x2026: // elipsis
            case 0x2019: // smart apostrophe
            case 0x005c: // solidus reverse
                return true;
            default:
                return false;
        }
    }

     public  static List<String> permutation(String str) {
        return permutation("", str);
     }

     private static List<String> permutation(String prefix, String str) {
        int n = str.length();
        List<String> list = new ArrayList<String>();
        if (n == 0) {
            list.add(prefix);
            return list;
        } else {
            for (int i = 0; i < n; i++) {
                list.addAll(permutation(prefix + str.charAt(i), str.substring(0, i) + str.substring(i+1, n)));
            }
            return list;
        }

    }

}
