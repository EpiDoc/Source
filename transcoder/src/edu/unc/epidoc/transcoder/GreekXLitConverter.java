/*
 * GreekXLitConverter.java
 *
 * (c) Michael Jones (mdjone2@uky.edu)
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.io.*;
import java.lang.*;
import java.util.Properties;
import java.util.StringTokenizer;

/** Handles conversion to the Perseus Greek transliteration format.
 * @author  Michael Jones
 */
public class GreekXLitConverter extends AbstractGreekConverter {
    
    /** Creates new GreekXLitConverter */
    public GreekXLitConverter() {
        encoding = "US-ASCII";
        unrecognizedChar = "";
        sgp = new Properties();
        try {
            Class c = this.getClass();
            sgp.load(c.getResourceAsStream("GreekXLitConverter.properties"));
        }
        catch (Exception e) {
        }
    }
    
    private Properties sgp;
    
    /** Convert the input String to a String in transliterated Greek with
     * characters greater than 127 escaped as XML character entities.
     * @param in The String to be converted
     * @return The converted String.
     */ 
    public String convertToCharacterEntities(Parser in) {
        StringBuffer result = new StringBuffer();
        char[] chars = convertToString(in).toCharArray();
        for (int i = 0; i < chars.length; i++) {
            int ch = (int)chars[i];
            if (ch > 127)
                result.append("&#x"+Integer.toHexString(ch)+";");
            else
                result.append(chars[i]);        
        }
        return result.toString();
    }
    
    /** Convert the input String to a String in transliterated Greek.
     * @param in The String to be converted.
     * @return The converted String.
     */ 
    public String convertToString(Parser in) {
        StringBuffer result = new StringBuffer();
        String last = "";
        while (in.hasNext()) {
            String convert = in.next();
            if (convert.indexOf('_')>0 && convert.length()>1) {
                String[] elements = split(convert);
                if (elements[1].equals("asper")) {
                    if (isDiphthong(last, elements[0]) && convert.indexOf("diaer") < 0) {
                        if (Character.isUpperCase(elements[0].charAt(0))) {
                            result.insert(result.length()-1, "H");
                            result.append((sgp.getProperty(elements[0], "")).toLowerCase());
                        }
                        else {
                            result.insert(result.length()-1, "h");
                            result.append(sgp.getProperty(elements[0], ""));
                        }
                    } else {
                        if (Character.isUpperCase(elements[0].charAt(0))) {
                            result.append("H");
                            result.append((sgp.getProperty(elements[0], "")).toLowerCase());
                        }
                        else {
                            result.append("h");
                            result.append(sgp.getProperty(elements[0], ""));
                        }
                    }
                }
                else
                    result.append(sgp.getProperty(elements[0], ""));
            } else {
                if (convert.length() > 1)
                    result.append(sgp.getProperty(convert, ""));
                else
                    result.append(sgp.getProperty(convert, convert));
            }
            last = convert;
        }
        return result.toString();
    }  
    
    private boolean isDiphthong(String first, String second) {
        if ("iota".equalsIgnoreCase(second)) {
            if ("alpha".equalsIgnoreCase(first))
                return true;
            if ("epsilon".equalsIgnoreCase(first))
                return true;
            if ("omicron".equalsIgnoreCase(first))
                return true;
            if ("upsilon".equalsIgnoreCase(first))
                return true;
        }
        if ("upsilon".equalsIgnoreCase(second)) {
            if ("alpha".equalsIgnoreCase(first))
                return true;
            if ("epsilon".equalsIgnoreCase(first))
                return true;
            if ("omicron".equalsIgnoreCase(first))
                return true;
            if ("eta".equalsIgnoreCase(first))
                return true;
        }
        return false;
    }
}
