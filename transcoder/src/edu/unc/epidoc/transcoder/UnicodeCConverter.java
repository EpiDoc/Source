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
    private StringBuffer strb = new StringBuffer();
    private static final String ENCODING = "UTF8";
    private static final String LANGUAGE = "grc";
    private static final String UNRECOGNIZED_CHAR = "?";
    private String unrec = UNRECOGNIZED_CHAR;

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
        if (in.length() > 1)
            return unfcc.getProperty(in, unrec);
        else
            return unfcc.getProperty(in, in);
    } 
    
    public Object getProperty(String name) {
        return null;
    }
    
    public void setProperty(String name, Object value) {
        if (name.equals("suppress-unrecognized-characters")) {
            String val = (String)value;
            if (val.equals("true"))
                unrec = "";
            else
                val = UNRECOGNIZED_CHAR;
        }
    }
    
    public String getEncoding() {
        return new String(ENCODING);
    }
    
    public boolean supportsLanguage(String lang) {
        return LANGUAGE.equals(lang);
    }
    
}
