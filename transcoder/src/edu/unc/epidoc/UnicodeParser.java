/*
 * UnicodeParser.java
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
public class UnicodeParser implements Parser {
    
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
    
    private static final String ENCODING = "UTF8";
    private static final String LANGUAGE = "grc";
    
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
    
    public Object getProperty(String name) {
        return null;
    }
    
    public void setProperty(String name, Object value) {
    }
    
    public String getEncoding() {
        return new String(ENCODING);
    }
    
    public boolean supportsLanguage(String lang) {
        return LANGUAGE.equals(lang);
    }
    
}
