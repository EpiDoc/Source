/*
 * SPIonicConverter.java
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

/** Handles conversion to the SPIonic encoding.
 * @author  Michael Jones
 */
public class SPIonicConverter extends AbstractGreekConverter {
    
    /** Creates new SPIonicConverter */
    public SPIonicConverter() {
        encoding = "US-ASCII";
        sgp = new Properties();
        try {
            Class c = this.getClass();
            sgp.load(c.getResourceAsStream("SPIonicConverter.properties"));
        }
        catch (Exception e) {
        }
    }
    
    private Properties sgp;
    
    /** Convert the input String to a String in SPIonic with
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
    
    /** Convert the input String to a String in SPIonic.
     * @param in The String to be converted.
     * @return The converted String.
     */
    public String convertToString(Parser in) {
        StringBuffer result = new StringBuffer();
        while (in.hasNext()) {
            String convert = in.next();
            if (convert.indexOf('_')>0 && convert.length()>1) {
                String temp;
                String narrowWide;
                String[] elements = split(convert);
                if (isCharacterNarrow(elements[0]))
                    narrowWide = "narrow";
                else
                    narrowWide = "wide";
                temp = elements[1];
                if (elements.length == 2) {
                    temp += "_" + narrowWide;
                    if (sgp.getProperty(temp) != null) {
                        result.append(sgp.getProperty(elements[0], unrec) + sgp.getProperty(temp, unrec));
                        for (int i=2;i<elements.length;i++)
                            result.append(sgp.getProperty(elements[i], unrec));
                    }
                    else {
                        for (int i=0; i<elements.length;i++)
                            result.append(sgp.getProperty(elements[i], unrec));
                    }
                }
                else {
                    temp += "_" + elements[2] + "_" + narrowWide;
                    if (sgp.getProperty(temp) != null) {
                        result.append(sgp.getProperty(elements[0], unrec) + sgp.getProperty(temp, unrec));
                        for (int i=3;i<elements.length;i++)
                            result.append(sgp.getProperty(elements[i], unrec));
                    }
                    else {
                        for (int i=0; i<elements.length;i++)
                            result.append(sgp.getProperty(elements[i], unrec));
                    }
                }
            }
            else {
                if (convert.length() > 1)
                    result.append(sgp.getProperty(convert, unrec));
                else
                    result.append(sgp.getProperty(convert, convert));
            }
        }
        return result.toString();
    }
    
    
    private boolean isCharacterNarrow(String ch) {
        if (ch.equals("iota") || ch.equals("epsilon")) {
            return true;
        }
        else
            return false;
    }
}
