/*
 * UnicodeParser.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.lang.*;
import java.util.Properties;
import java.util.TreeMap;

/** Parses sources encoded in Unicode.
 * @author Hugh A. Cayless
 */
public class UnicodeParser extends AbstractGreekParser {
    
    /** Creates new UnicodeParser */
    public UnicodeParser() {
        up = new Properties();
        ga = new Properties();
        try {
            Class c = this.getClass();
            up.load(c.getResourceAsStream("UnicodeParser.properties"));
            ga.load(c.getResourceAsStream("GreekAccents.properties"));
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace(System.out);
        }
    }
       
    private Properties up;
    private Properties ga;
    private StringBuffer strb = new StringBuffer();
    private TreeMap map = new TreeMap();
    
    /** Returns the next parsed character as a String.
     * @return The name of the parsed character.
     */ 
    public String next() {
        strb.delete(0,strb.length());
        if (in != null && hasNext()) {
            strb.append(lookup(chArray[index]));
            index++;
            if (chArray[index - 1] == '\u03C3' || chArray[index - 1] == '\u03C2') {
                switch (chArray[index - 1]) {
                    case '\u03C3':
                        if(!hasNext() || !Character.isLetter(chArray[index]))
                            strb.append("Fixed");
                        break;
                    case '\u03C2':
                        if(hasNext() && Character.isLetter(chArray[index]))
                            strb.append("Fixed");
                }
            } else {
                if (hasNext() && isCombiningDiacritical(chArray[index])) {
                    map.clear();
                    while (isCombiningDiacritical(chArray[index])) {
                        map.put(lookupAccent(chArray[index]), lookup(chArray[index]));
                        index++;
                    }
                    while (!map.isEmpty()) {
                        strb.append("_" + (String)map.remove(map.firstKey()));
                    }
                }
            }
        }
        return strb.toString();
    }
    
    private String lookup(char ch) {
        String key = String.valueOf(ch);
        return up.getProperty(key, key);
    }
    
    private String lookupAccent(char ch) {
        String key = String.valueOf(ch);
        int i = (int)ch;
        String result = lookup(ch);
        return ga.getProperty(lookup(ch));
    }
    
    private boolean isCombiningDiacritical(char ch) {
        switch (ch) {
            case '\u0313':
            case '\u0314':
            case '\u0301':
            case '\u0300':
            case '\u0303':
            case '\u0308':
            case '\u0342':
            case '\u0345':
                return true;
            default:
                return false;
        }
    }    
    
}
