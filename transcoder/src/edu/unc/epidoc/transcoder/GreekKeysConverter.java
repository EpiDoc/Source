/*
 * GreekKeysConverter.java
 *
 * (c) Hugh A. Cayless (hcayless@email.unc.edu)
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.io.*;
import java.lang.*;
import java.util.*;

/** Handles conversion to the GreekKeys encoding.
 * @author Hugh A. Cayless
 */
public class GreekKeysConverter extends AbstractGreekConverter {
    
    /** Creates new GreekKeysConverter */
    public GreekKeysConverter() {
        encoding = "Cp1252";
        reader = new MapReader();
        reader.load("GreekKeysConverter.properties", encoding);
    }
    
    private MapReader reader;
    
    /** Convert the input String to a String in the desired encoding with
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
    
    /** Convert the input String to a String in GreekKeys.
     * @param in The String to be converted.
     * @return The converted String.
     */
    public String convertToString(Parser in) {
        byte[] b = null;
        StringBuffer result = new StringBuffer();
        while (in.hasNext()) {
            String convert = in.next();
            char[] chars = convert.toCharArray();
            if (Character.isUpperCase(chars[0]) && convert.indexOf('_') > 0) {
                String letter = convert.substring(0, convert.indexOf('_'));
                String diacriticals = convert.substring(convert.indexOf('_') + 1);
                byte[] d = doConversion(diacriticals);
                byte[] l = doConversion(letter);
                b = new byte[d.length + l.length];
                System.arraycopy(d, 0, b, 0, d.length);
                System.arraycopy(l, 0, b, d.length, l.length);
            } else
                b = doConversion(convert);
            try {
                result.append(new String(b, "ISO8859_1"));
            } catch (UnsupportedEncodingException e) {
                return null;
            }
        }
        return result.toString();
    }
    

}
