/*
 * SPIonicParser.java
 *
 * (c) Michael Jones <mdjone2@uky.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.lang.*;
import java.util.Properties;
import java.util.TreeMap;

/** Parses sources encoded in SPIonic.
 * @author  Michael Jones
 */
public class SPIonicParser extends AbstractGreekParser {
    
    /** Creates new SPIonicParser */
    public SPIonicParser() {
        bcp = new Properties();
        ga = new Properties();
        try {
            Class c = this.getClass();
            bcp.load(c.getResourceAsStream("SPIonicParser.properties"));
            ga.load(c.getResourceAsStream("GreekAccents.properties"));
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace(System.out);
        }
    }
    
    protected static final String ENCODING = "US-ASCII";
    
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
            while (hasNext() && isSPIonicDiacritical(chArray[index])) {
                strb.append("_" + lookup(chArray[index]));
                index++;
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
    
    private boolean isSPIonicDiacritical(char ch) {
        switch (ch) {
            case '/':
            case '&':
            case '\\':
            case '_':
            case '=':
            case '~':
            case '0':
            case ')':
            case '9':
            case '(':
            case '1':
            case '!':
            case '2':
            case '@':
            case ']':
            case '}':
            case '3':
            case '#':
            case '4':
            case '$':
            case '[':
            case '{':
            case '+':
            case '"':
            case '5':
            case '%':
            case '6':
            case '^':
            case '<':
            case '>':
            case '|':
                return true;
            default:
                return false;
        }
    }
}






