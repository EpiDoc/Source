/*
 * GreekKeysParser.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc;

import java.lang.*;
import java.util.Properties;
import java.util.TreeMap;

/**
 *
 * @author  Hugh A. Cayless
 * @version
 */
public class GreekKeysParser implements Parser {
    
    /** Creates new UnicodeParser */
    public GreekKeysParser() {
        up = new Properties();
        ga = new Properties();
        try {
            Class c = this.getClass();
            up.load(c.getResourceAsStream("GreekKeysParser.properties"));
            ga.load(c.getResourceAsStream("GreekAccents.properties"));
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace(System.out);
        }
    }
    
    private static String ENCODING = "ISO8859_1";
    
    private Properties up;
    private Properties ga;
    private char[] chArray;
    private int index;
    private String in;
    private StringBuffer strb = new StringBuffer();
    private TreeMap map = new TreeMap();
    
    public boolean hasNext() {
        if (index < chArray.length)
            return true;
        else
            return false;
    }
    
    public String next() {
        strb.delete(0,strb.length());
        if (in != null && hasNext()) {
            strb.append(lookup(chArray[index]));
            index++;
            if (chArray[index - 1] == '\u0073' || chArray[index - 1] == '\u0077') {
                if(!hasNext() || !Character.isLetter(chArray[index]))
                    strb.append("Fixed");
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
    
    public void setString(String in) {
        this.in = in;
        chArray = in.toCharArray();
        index = 0;
    }
    
    private String lookup(char ch) {
        String key = String.valueOf(ch);
        return up.getProperty(key, key);
    }
    
    private String lookupAccent(char ch) {
        String key = String.valueOf(ch);
        return ga.getProperty(lookup(ch));
    }
    
    private boolean isCombiningDiacritical(char ch) {
        switch (ch) {
            case '\u0060':
            case '\u002B':
                return true;
            default:
                return false;
        }
    }
    
    public String getParameter(String name) {
        if (name.equals("ENCODING"))
            return ENCODING;
        return null;
    }
    
    public void setParameter(String name, String param) {
    }
    
}
