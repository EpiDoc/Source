/*
 * HellasConverter.java
 *
 * (c) Hugh A. Cayless (hcayless@email.unc.edu)
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.io.*;
import java.lang.*;
import java.util.Properties;
import java.util.StringTokenizer;

/** Handles the conversion to Beta Code.
 * @author Hugh A. Cayless
 * @version 0.8
 */
public class HellasConverter extends AbstractGreekConverter {

    /** Creates new HellasConverter */
    public HellasConverter() {
        encoding = "US-ASCII";
        hc = new Properties();
        try {
            Class c = this.getClass();
            hc.load(c.getResourceAsStream("HellasConverter.properties"));
        } catch (Exception e) {
        }
    }

    protected Properties hc;

    /** Convert the input String to a String in Hellas with
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

    /** Convert the input String to a String in Beta Code.
     * @param in The String to be converted.
     * @return The converted String.
     */
    public String convertToString(Parser in) {
        StringBuffer result = new StringBuffer();
        while (in.hasNext()) {
            String convert = in.next();
        if (convert.indexOf('_')>0 && convert.length()>1) {
            String[] elements = split(convert);
            String temp = hc.getProperty(elements[0], unrec);
            if (temp.charAt(0) == '*') {
                result.append(temp.charAt(0));
                for (int i=1;i<elements.length;i++)
                    result.append(hc.getProperty(elements[i], unrec));
                result.append(temp.substring(1));
            } else {
                for (int i=0;i<elements.length;i++)
                    result.append(hc.getProperty(elements[i], unrec));
            }
        } else {
            if (convert.length() > 1)
                result.append(hc.getProperty(convert, unrec));
            else
                result.append(hc.getProperty(convert, convert));
        }
        }
        return result.toString();
    }
}
