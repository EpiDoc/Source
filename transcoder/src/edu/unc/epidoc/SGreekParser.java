/*
 * SGreekParser.java
 *
 * (c) Michael Jones <mdjone2@uky.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc;

import java.lang.*;
import java.util.Properties;
import java.util.TreeMap;

/**
 *
 * @author  Michael Jones
 * @version
 */
public class SGreekParser implements Parser {

    /** Creates new SGreekParser */
public SGreekParser() {
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

    private static String ENCODING = "US-ASCII";
    private static final String LANGUAGE = "grc";

    private Properties bcp;
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

    public void setString(String in) {
        this.in = in;
        chArray = in.toCharArray();
        index = 0;
    }

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

    public String getEncoding() {
        return new String(ENCODING);
    }
    
    public boolean supportsLanguage(String lang) {
        return LANGUAGE.equals(lang);
    }
    
    public Object getProperty(String name) {
        if (name.equals("ENCODING"))
            return new String(ENCODING);
        return null;
    }
    
    public void setProperty(String name, Object value) {
    }   
}






