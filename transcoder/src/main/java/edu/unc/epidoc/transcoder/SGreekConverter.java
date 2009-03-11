/*
 * SGreekConverter.java
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

/** Handles conversion to the SGreek encoding.
 * @author  Michael Jones
 */
public class SGreekConverter extends AbstractGreekConverter {
    
    /** Creates new SGreekConverter */
    public SGreekConverter() {
        encoding = "Cp1252";
        unrecognizedChar = String.valueOf('\u0081');
        sgp = new Properties();
        try {
            Class c = this.getClass();
            sgp.load(c.getResourceAsStream("SGreekConverter.properties"));
        }
        catch (Exception e) {
        }
    }
    
    private Properties sgp;
    
    /** Convert the input String to a String in SGreek with
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
    
    /** Convert the input String to a String in SGreek.
     * @param in The String to be converted.
     * @return The converted String.
     */ 
    public String convertToString(Parser in) {
        StringBuffer result = new StringBuffer();
        StringBuffer strb = new StringBuffer();
        while (in.hasNext()) {
            String convert = in.next();
            if (convert.indexOf('_')>0 && convert.length()>1) {
                String[] elements = split(convert);
                if (elements[1].equals("isub")) {
                    strb.delete(0, strb.length());
                    for (int i=2;i<elements.length;i++)
                        strb.append(sgp.getProperty(elements[i], unrec));
                    result.append(sgp.getProperty(convert, convert) + strb.toString());
                }
                else {
                    for (int i=0;i<elements.length;i++)
                        result.append(sgp.getProperty(elements[i], unrec));
                }
            } else {
                if (convert.length() > 1)
                    result.append(sgp.getProperty(convert, unrec));
                else
                    result.append(sgp.getProperty(convert, convert));
            }
        }
        return result.toString();
    }    
}
