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
public class UnicodeDConverter implements Converter {

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
    private StringBuffer strb = new StringBuffer();
    private static final String ENCODING = "UTF8";
    private static final String LANGUAGE = "grc";
    private static final String UNRECOGNIZED_CHAR = "?";
    private String unrec = UNRECOGNIZED_CHAR;

    public String convertToCharacterEntity(String in) {
        String out;
        if (in.indexOf('_')>0 && in.length()>1) {
            strb.delete(0,strb.length());
            String[] elements = split(in);
            for (int i=0;i<elements.length;i++)
                strb.append(unfdc.getProperty(elements[i], elements[i]));
            out = strb.toString();
         } else
            out = unfdc.getProperty(in, in);
        strb.delete(0,strb.length());
        char[] chars = out.toCharArray();
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
         if (in.indexOf('_')>0 && in.length()>1) {
            strb.delete(0,strb.length());
            String[] elements = split(in);
            for (int i=0;i<elements.length;i++)
                strb.append(unfdc.getProperty(elements[i], unrec));
            return strb.toString();
         } else {
             if (in.length() > 1)
                 return unfdc.getProperty(in, unrec);
             else
                return unfdc.getProperty(in, in);
         }
    }
    
    private String[] split(String str) {
        StringTokenizer st = new StringTokenizer(str, "_");
        int tokenCount = st.countTokens();
        String[] result = new String[tokenCount];
        for (int i = 0; i < tokenCount; i++) {
            result[i] = st.nextToken();
        }
        return result;
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
