/*
 * UnicodeNormalizationFormCConverter.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.io.*;
import java.lang.*;
import java.util.Properties;
import java.util.StringTokenizer; 

/**
 *
 * @author  hcayless
 * @version 
 */
public class UnicodeDConverter extends AbstractConverter {

    /** Creates new UnicodeNormalizationFormCConverter */
    public UnicodeDConverter() {
        unfdc = new Properties();
        try {
            Class c = this.getClass();
            unfdc.load(c.getResourceAsStream("UnicodeDConverter.properties"));
        } catch (Exception e) {
        }
    }
    
    private Properties unfdc;
    private static final String ENCODING = "UTF8";
    private static final String LANGUAGE = "grc";
    private static final String UNRECOGNIZED_CHAR = "?";
    
    /** Convert the input String to a String in Unicode Form D with
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
    
    /** Convert the input String to a String in Unicode Form D.
     * @param in The String to be converted.
     * @return The converted String.
     */ 
    public String convertToString(Parser in) {
        StringBuffer result = new StringBuffer();
        while (in.hasNext()) {
            String convert = in.next();
         if (convert.indexOf('_')>0 && convert.length()>1) {
            String[] elements = split(convert);
            for (int i=0;i<elements.length;i++)
                result.append(unfdc.getProperty(elements[i], unrec));
         } else {
             if (convert.length() > 1)
                 result.append(unfdc.getProperty(convert, unrec));
             else
                result.append(unfdc.getProperty(convert, convert));
         }
        }
        return result.toString();
    }        
}
