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


/** Parses sources encoded in Hellas.
 * @author Hugh A. Cayless
 */
public class HellasParser extends AbstractGreekParser {

    /** Creates new HellasParser */
    public HellasParser() {
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

    /** Returns the next parsed character as a String.
     * @return The name of the parsed character.
     */
    public String next() {
        strb.delete(0,strb.length());
        if (in != null) {
            char ch = chArray[index];
            System.out.println("Character: " + String.valueOf(ch));
            index++;
            map.clear();
            escape.delete(0,escape.length());
            escape.append(ch);

            if (hasNext() && isHellasPrefix(ch)) {
                // Prefix
                escape.append(chArray[index]);
                index++;

                if(hasNext() && isHellasPrefix(chArray[index])) {
                    // Second Level Prefix
                    escape.append(chArray[index]);
                    index++;
                }
            }

            System.out.println(escape.length());

            while (escape.length() > 0) {
                String result = lookup(escape.toString());
                System.out.println("Looked up: " + result.length());
                if (result.equals(escape.toString())) {
                    escape.deleteCharAt(escape.length() - 1);
                    index -= 1;
                } else {
                    strb.append(result);
                    break;
                }
            }

            if (strb.length() == 0) {
                if(isPunctuation(ch) || Character.isWhitespace(ch)) {
                    strb.append(ch);
                    index++;
                } else {
                    strb.append('?');
                    index++;
                }
            }
        }
        System.out.println("Returns: " + strb);
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

    protected static boolean isHellasPrefix(char ch) {
        switch (ch) {
            case '!':
            case '"':
            case '&':
            case '(':
            case ')':
            case '§':
            case 'Ô':
            case 'à':
            case 'ç':
            case 'è':
            case 'ï':
            case '/': // underdot
                return true;
            default:
                return false;
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
                return true;
            default:
                return false;
        }
    }

}
