/*
 * BetaCodeParser.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.util.HashMap;
import java.util.Properties;
import java.util.TreeMap;


/** Parses sources encoded in Beta Code.
 * @author Hugh A. Cayless
 */
public class BetaCodeParser extends AbstractGreekParser {
    
    /** Creates new BetaCodeParser */
    public BetaCodeParser() {
        encoding = "US-ASCII";
        if (properties.isEmpty()) {
            bcp = new Properties();
            ga = new Properties();
            synchronized(properties) {
                try {
                    Class c = this.getClass();
                    bcp.load(c.getResourceAsStream("BetaCodeParser.properties"));
                    ga.load(c.getResourceAsStream("GreekAccents.properties"));
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                    e.printStackTrace(System.out);
                }
                properties.put("bcp", bcp);
                properties.put("ga", ga);
            }
        } else {
            bcp = properties.get("bcp");
            ga = properties.get("ga");
        }
    }

    private static final HashMap<String,Properties> properties = new HashMap<String,Properties>();
    private Properties bcp;
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
                        while (hasNext() && (Character.isDigit(chArray[index]))) {
                            escape.append(chArray[index]);
                            index++;
                        }
                    }
                    String result = lookup(escape.toString());
                    // reset if this isn't a recognized Beta Code escape
                    if (result.equals(escape.toString())) { 
                        index -= (escape.length() - 1);
                        escape.delete(1, escape.length());
                    }
                    strb.append((lookup(escape.toString())));
                } else {
                    if (ch == '#' && Character.isLetter(chArray[index]))
                        strb.append(lookup(ch));
                    else {
                        while (hasNext() && isBetaCodeDiacritical(chArray[index])) {
                            map.put(lookupAccent(chArray[index]), lookup(chArray[index]));
                            index++;
                        }
                        if (hasNext()) {
                            strb.append(lookup(lookup(ch) + String.valueOf(chArray[index])));
                            index++;
                            while (!map.isEmpty()) {
                                String str = (String)map.remove(map.firstKey());
                                strb.append("_").append(str);
                            }
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
                        if (!isTerminalSigma(chArray, index)) {
                            strb.append(lookup(ch));
                        } else {
                            strb.append(lookup(String.valueOf(ch)+"2"));
                        }
                            
                    }
                } else {
                    strb.append(lookup(ch));
                    while (hasNext() && isBetaCodeDiacritical(chArray[index])) {
                        map.put(lookupAccent(chArray[index]), lookup(chArray[index]));
                        index++;
                    }
                    while (map.size()>0) {
                        String str = (String)map.remove(map.firstKey());
                        strb.append("_").append(str);
                    }
                }
            }
        }
        return strb.toString();
    }
    
    protected boolean isTerminalSigma(char[] chArray, int index) {
        if (index >= chArray.length) {
            return true;
        }
        char ch = chArray[index];
        if (Character.isLetter(ch)) {
            return false;
        }

        for (int i = 0; i + index < chArray.length; i++) {
            if (Character.isWhitespace(chArray[index + i])) {
                return true;
            }
            if (Character.isLetter(chArray[index + i])) {
                return false;
            }
            if (chArray[index + i] == '-') {
                return false;
            }
            if (isPunctuation(chArray[index + i])) {
                return true;
            }
            if (chArray[index + i] == '\'') {
                return false;
            }
            if (i + index == chArray.length - 1) {
                return true;
            }
        }
        return false;
    }
    
    protected String lookup(char ch) {
        char chr = ch;
        if (Character.isLowerCase(chr))
            chr = Character.toUpperCase(chr);
        String key = String.valueOf(chr);
        return bcp.getProperty(key, String.valueOf(ch));
    }
    
    protected String lookup(String key) {
        return bcp.getProperty(key.toUpperCase(), key);
    }
    
    protected String lookupAccent(char ch) {
        String key = String.valueOf(ch);
        return ga.getProperty(lookup(key));
    }
    
    protected static boolean isBetaCodeDiacritical(char ch) {
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
    
    protected static boolean isBetaCodePrefix(char ch) {
        switch (ch) {
            case '*':
            case '#':
            case '%':
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
                return true;
            default:
                return false;
        }
    }

}
