/*
 * GreekKeysParser.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

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
        gkp = new Properties();
        ga = new Properties();
        try {
            Class c = this.getClass();
            gkp.load(c.getResourceAsStream("GreekKeysParser.properties"));
            ga.load(c.getResourceAsStream("GreekAccents.properties"));
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace(System.out);
        }
    }
    
    /* Hack alert: The font isn't really ISO 8859-1, but using Cp1252
     * causes some characters not to be properly converted. */
    private static final String ENCODING = "ISO8859_1";
    private static final String LANGUAGE = "grc";
    
    private Properties gkp;
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
            if (!isPrefixDiacritical(chArray[index])) 
                strb.append(lookup(chArray[index]));
            index++;
            if (chArray[index - 1] == '\u0073' || chArray[index - 1] == '\u0077') {
                if(!hasNext() || !Character.isLetter(chArray[index]))
                    strb.append("Fixed");
            } else {
                if (hasNext() && isPrefixDiacritical(chArray[index - 1])) {
                    if (Character.isLetter(chArray[index])) {
                        strb.append(lookup(chArray[index]));
                        strb.append("_" + lookup(chArray[index - 1]));
                        index ++;
                    } else 
                        strb.append(lookup(chArray[index - 1]));
                } else {
                    if (hasNext() && isPostCombiningDiacritical(chArray[index])) {
                        map.clear();
                        while (isPostCombiningDiacritical(chArray[index])) {
                            map.put(lookupAccent(chArray[index]), lookup(chArray[index]));
                            index++;
                        }
                        while (!map.isEmpty()) {
                            strb.append("_" + (String)map.remove(map.firstKey()));
                        }
                    }
                }
            }
        }
        return strb.toString();
    }
    
    public void setString(String in) {
        try {
            this.in = new String(in.getBytes(), ENCODING);
        } catch (Exception e) {}
        chArray = in.toCharArray();
        index = 0;
    }
    
    private String lookup(char ch) {
        String key = String.valueOf(ch);
        return gkp.getProperty(key, key);
    }
    
    private String lookupAccent(char ch) {
        String key = String.valueOf(ch);
        return ga.getProperty(lookup(ch));
    }
    
    private boolean isPostCombiningDiacritical(char ch) {
        switch (ch) {
            case '\u0060':
            case '\u002B':
                return true;
            default:
                return false;
        }
    }
    
    /* true with diacriticals used in combination with capitals */
    private boolean isPrefixDiacritical(char ch) {
        switch (ch) {
            case '\u0080':
            case '\u0081':
            case '\u0082':
            case '\u0083':
            case '\u0084':
            case '\u0085':
            case '\u0086':
            case '\u0087':
            case '\u0088':
            case '\u0089':
            case '\u008A':
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
