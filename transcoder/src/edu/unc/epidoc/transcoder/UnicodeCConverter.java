/*
 * UnicodeCConverter.java
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
 * @author  Hugh A. Cayless
 * @version
 */
public class UnicodeCConverter extends AbstractConverter {
    
    /** Creates new UnicodeNormalizationFormCConverter */
    public UnicodeCConverter() {
        unfcc = new Properties();
        try {
            Class c = this.getClass();
            unfcc.load(c.getResourceAsStream("UnicodeCConverter.properties"));
        } catch (Exception e) {
        }
    }
    
    private Properties unfcc;
    private static final String ENCODING = "UTF8";
    private static final String LANGUAGE = "grc";
    private static final String UNRECOGNIZED_CHAR = "?";
    
    /** Convert the input String to a String in Unicode Form C with
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
    
    /** Convert the input String to a String in Unicode Form C.
     * @param in The String to be converted.
     * @return The converted String.
     */ 
    public String convertToString(Parser in) {
        StringBuffer result = new StringBuffer();
        while (in.hasNext()) {
            String convert = in.next();
            if (convert.length() > 1)
                result.append(unfcc.getProperty(convert, unrec));
            else
                result.append(unfcc.getProperty(convert, convert));
        }
        return result.toString();
    }        
}
