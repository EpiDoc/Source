/*
 * BetaCodeParser.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.lang.*;
import java.util.Properties;
import java.util.TreeMap;


/** Parses sources encoded in Beta Code.
 * @author Hugh A. Cayless
 */
public class BetaCodeParser extends AbstractGreekParser {
    
    /** Creates new BetaCodeParser */
    public BetaCodeParser() {
        encoding = "US-ASCII";
        bcp = new Properties();
        ga = new Properties();
        try {
            Class c = this.getClass();
            bcp.load(c.getResourceAsStream("BetaCodeParser.properties"));
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
    private StringBuffer escape = new StringBuffer();
    
    /** Returns the next parsed character as a String.
     * @return The name of the parsed character.
     */  
    public String next() {
        strb.delete(0,strb.length());
        if (in != null) {
            char ch = chArray[index];
            index++;
            map.clear();
            escape.delete(0,escape.length());
            if (hasNext() && isBetaCodePrefix(ch)) {
                if (Character.isDigit(chArray[index]) || isBetaCodePrefix(chArray[index])) {
                    escape.append(ch);
                    if (isBetaCodePrefix(chArray[index])) {
                        escape.append(chArray[index]);
                        index++;
                    }
                    if (hasNext()) {
                        while (Character.isDigit(chArray[index])) {
                            escape.append(chArray[index]);
                            index++;
                        }
                    }
                    strb.append((lookup(escape.toString())));
                } else {
                    if (ch == '#' && Character.isLetter(chArray[index]))
                        strb.append(lookup(ch));
                    else {
                        while (isBetaCodeDiacritical(chArray[index])) {
                            map.put(lookupAccent(chArray[index]), lookup(chArray[index]));
                            index++;
                        }
                        strb.append(lookup(lookup(ch) + String.valueOf(chArray[index])));
                        index++;
                        while (!map.isEmpty()) {
                            String str = (String)map.remove(map.firstKey());
                            strb.append("_"+str);
                        }
                    }
                }
            } else {
                if (ch == 'S' || ch == 's') {
                    if (index < chArray.length && Character.isDigit(chArray[index])) {
                        escape.append(ch);
                        escape.append(chArray[index]);
                        index++;
                        strb.append(lookup(escape.toString()));
                    } else {
                        if (index > chArray.length-1 || !Character.isLetter(chArray[index]))
                            strb.append(lookup(String.valueOf(ch)+"2"));
                        else
                            strb.append(lookup(ch));
                    }
                } else {
                    strb.append(lookup(ch));
                    while (hasNext() && isBetaCodeDiacritical(chArray[index])) {
                        map.put(lookupAccent(chArray[index]), lookup(chArray[index]));
                        index++;
                    }
                    while (map.size()>0) {
                        String str = (String)map.remove(map.firstKey());
                        strb.append("_"+str);
                    }
                }
            }
        }
        return strb.toString();
    }
    
    private String lookup(char ch) {
        if (Character.isLowerCase(ch))
            ch = Character.toUpperCase(ch);
        String key = String.valueOf(ch);
        return bcp.getProperty(key, key);
    }
    
    private String lookup(String key) {
        return bcp.getProperty(key.toUpperCase());
    }
    
    private String lookupAccent(char ch) {
        String key = String.valueOf(ch);
        return ga.getProperty(lookup(key));
    }
    
    private boolean isBetaCodeDiacritical(char ch) {
        switch (ch) {
            case ')':
            case '(':
            case '/':
            case '\\':
            case '=':
            case '+':
            case '|':
                return true;
            default:
                return false;
        }
    }
    
    private boolean isBetaCodePrefix(char ch) {
        switch (ch) {
            case '*':
            case '#':
            case '%':
                return true;
            default:
                return false;
        }
    }
}
