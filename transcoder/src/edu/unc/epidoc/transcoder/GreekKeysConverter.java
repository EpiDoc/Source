/*
 * GreekKeysConverter.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.io.*;
import java.lang.*;
import java.util.*;

/**
 *
 * @author  Hugh A. Cayless
 * @version
 */
public class GreekKeysConverter implements Converter {
    
    /** Creates new GreekKeysConverter */
    public GreekKeysConverter() {
        reader = new MapReader();
        reader.load("GreekKeysConverter.properties", ENCODING);
    }
    
    private MapReader reader;
    private StringBuffer strb = new StringBuffer();
    private static final String ENCODING = "Cp1252";
    private static final String LANGUAGE = "grc";
    private static final String UNRECOGNIZED_CHAR = "?";
    private String unrec = UNRECOGNIZED_CHAR;
    
    
    public String convertToCharacterEntity(String in) {
        String temp = reader.get(in);
        strb.delete(0,strb.length());
        if (temp != null) {
            char c = temp.charAt(0);
            if (c > 0x7F) {
                strb.append("&#");
                strb.append(Integer.toString(c));
                strb.append(";");
            } else {
                strb.append(c);
            }
        }
        return strb.toString();
    }
    
    private String doConversion(String in) {
        String result = reader.get(in);
        
        if (result != null) {
            try {
                result = new String(result.getBytes(ENCODING));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
            return result;
        }
        if (in.length() > 1)
            return unrec;
        else
            return in;
    }
    
    public String convertToString(String in) {
        char[] chars = in.toCharArray();
        String result = null;
        if (Character.isUpperCase(chars[0]) && in.indexOf('_') > 0) {
            String letter = in.substring(0, in.indexOf('_'));
            String diacriticals = in.substring(in.indexOf('_') + 1);
            result = doConversion(diacriticals);
            result += doConversion(letter);
        } else
            result = doConversion(in);
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
