/*
 * UnicodeNormalizationFormCConverter.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc;

import java.io.*;
import java.lang.*;
import java.util.Properties;
import java.util.StringTokenizer;

/**
 *
 * @author  Hugh A. Cayless
 * @version 
 */
public class UnicodeCConverter implements Converter {

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
    StringBuffer strb = new StringBuffer();

    public String convertToCharacterEntity(String in) {
        String str = unfcc.getProperty(in, in);
        strb.delete(0,strb.length());
        char[] chars = str.toCharArray();
        for (int i=0;i<chars.length;i++) {  
            if (chars[i] > 0x7F) {
                strb.append("&#");
                strb.append(Integer.toString(chars[i]));
                strb.append(";");
            } else {
                strb.append(chars[i]);
            }
        }
        return strb.toString();
    }
    
    public String convertToString(String in) {
        return unfcc.getProperty(in, in);
    } 
    
    public void getParameter(String name) {
    }
    
    public void setParameter(String name, String param) {
    }
    
}
