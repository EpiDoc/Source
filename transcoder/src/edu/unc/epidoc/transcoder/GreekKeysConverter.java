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
    /* Hack alert: The font isn't really ISO 8859-1, but using Cp1252
     * causes some characters not to be properly converted. */
    private static final String ENCODING = "ISO8859_1";
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
    
    private byte[] doConversion(String in) {
        String temp = reader.get(in);
        byte[] result = null;
        if (temp != null) {
            if (temp.length() > 1) {
                try {
                    int i = Integer.parseInt(temp, 16);
                    result = new byte[] {(byte)i};
                } catch (Exception e) {
                    e.printStackTrace();
                    result = unrec.getBytes();
                }
            } else
                result = temp.getBytes();
        } else {
            if (in.length() > 1)
                result = unrec.getBytes();
            else
                result = in.getBytes();
        }
        if ("elisionMark".equals(in))
            System.out.println("elision: "+result.length);
        return result;
    }
    
    public String convertToString(String in) {
        
        byte[] result = null;
        strb.delete(0, strb.length());
        char[] chars = in.toCharArray();
        if (Character.isUpperCase(chars[0]) && in.indexOf('_') > 0) {
            String letter = in.substring(0, in.indexOf('_'));
            String diacriticals = in.substring(in.indexOf('_') + 1);
            byte[] d = doConversion(diacriticals);
            byte[] l = doConversion(letter);
            result = new byte[d.length + l.length];
            System.arraycopy(d, 0, result, 0, d.length);
            System.arraycopy(l, 0, result, d.length, l.length);
        } else
            result = doConversion(in);
        try {
            return new String(result, ENCODING);
        } catch (UnsupportedEncodingException e) {
            return null;
        }
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
