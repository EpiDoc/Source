/*
 * SGreekParser.java
 *
 * (c) Michael Jones <mdjone2@uky.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.lang.*;
import java.util.Properties;
import java.util.TreeMap;

/** Parses sources encoded in SGreek.
 * @author  Michael Jones
 */
public class SGreekParser extends AbstractGreekParser {
    
    /** Creates new SGreekParser */
    public SGreekParser() {
        encoding = "ISO8859_1";
        bcp = new Properties();
        ga = new Properties();
        try {
            Class c = this.getClass();
            bcp.load(c.getResourceAsStream("SGreekParser.properties"));
            ga.load(c.getResourceAsStream("GreekAccents.properties"));
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace(System.out);
        }
    }
        
    private Properties bcp;
    private Properties ga;
    private StringBuffer strb = new StringBuffer();
    private TreeMap map = new TreeMap();
    
    /** Returns the next parsed character as a String.
     * @return The name of the parsed character.
     */ 
    public String next() {
        strb.delete(0,strb.length());
        if (in != null) {
            char ch = chArray[index];
            index++;
            map.clear();
            strb.append(lookup(ch));
            while (hasNext() && isSGreekDiacritical(chArray[index])) {
                map.put(lookupAccent(chArray[index]), lookup(chArray[index]));
                index++;
            }
            while (map.size()>0) {
                String str = (String)map.remove(map.firstKey());
                strb.append("_"+str);
            }
        }
        return strb.toString();
    }
    
    private String lookup(char ch) {
        String key = String.valueOf(ch);
        return bcp.getProperty(key, key);
    }
    
    private String lookupAccent(char ch) {
        return ga.getProperty(lookup(ch));
    }
    
    private boolean isSGreekDiacritical(char ch) {
        switch (ch) {
            case ')':
            case '(':
            case '/':
            case '\\':
            case '=':
                return true;
            default:
                return false;
        }
    }
}






