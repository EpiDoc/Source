/*
 * GreekKeysParser.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.util.Properties;
import java.util.TreeMap;

/** Parses sources encoded in GreekKeys format.
 * @author Hugh A. Cayless
 */
public class GreekKeysParser extends AbstractGreekParser {
    
    /** Creates new GreekKeysParser */
    public GreekKeysParser() {
        encoding = "UTF8";
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
    
    private Properties gkp;
    private Properties ga;
    private StringBuffer strb = new StringBuffer();
    private TreeMap<String,String> map = new TreeMap<String,String>();
    
    /** Returns the next parsed character as a String.
     * @return The name of the parsed character.
     */ 
    public String next() {
        strb.delete(0,strb.length());
        if (in != null && hasNext()) {
            if (!isPrefixDiacritical(chArray[index])) 
                strb.append(lookup(chArray[index]));
            index++;
            if (chArray[index - 1] == '\uF073' || chArray[index - 1] == '\uF077') {
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
    
    private String lookup(char ch) {
        String key = String.valueOf(ch);
        String result = gkp.getProperty(key, key);
        if (key.equals(result) && Character.UnicodeBlock.of(ch) == Character.UnicodeBlock.PRIVATE_USE_AREA) {
          return Character.toString((char)((int)ch - 61440));
        } else {
          return result;
        }
    }
    
    private String lookupAccent(char ch) {
        return ga.getProperty(lookup(ch));
    }
    
    private boolean isPostCombiningDiacritical(char ch) {
        switch (ch) {
            case '\uF060':
            case '\uF02B':
                return true;
            default:
                return false;
        }
    }
    
    /* true with diacriticals used in combination with capitals */
    private boolean isPrefixDiacritical(char ch) {
        switch (ch) {
            case '\uF080':
            case '\uF081':
            case '\uF082':
            case '\uF083':
            case '\uF084':
            case '\uF085':
            case '\uF086':
            case '\uF087':
            case '\uF088':
            case '\uF089':
            case '\uF08A':
                return true;
            default:
                return false;
        }
    }    
}
