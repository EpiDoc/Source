/*
 * SPIonicConverter.java
 *
 * (c) Michael Jones <mdjone2@uky.edu>
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
 * @author  Michael Jones
 * @version
 */
public class SPIonicConverter implements Converter {
    
    /** Creates new SPIonicConverter */
    public SPIonicConverter() {
        bcc = new Properties();
        try {
            Class c = this.getClass();
            bcc.load(c.getResourceAsStream("SPIonicConverter.properties"));
        } catch (Exception e) {
        }
    }
    
    private Properties bcc;
    StringBuffer strb = new StringBuffer();
    
    public String convertToCharacterEntity(String in) {
        String out;
        if (in.indexOf('_')>0 && in.length()>1) {
            strb.delete(0,strb.length());
            String[] elements = split(in);
            String temp = bcc.getProperty(elements[0]);
            if (temp.charAt(0) == '*') {
                strb.append(temp.charAt(0));
                for (int i=1;i<elements.length;i++)
                    strb.append(bcc.getProperty(elements[i]));
                strb.append(temp.substring(1));
            } else {
                for (int i=0;i<elements.length;i++)
                    strb.append(bcc.getProperty(elements[i]));
            }
            out = strb.toString();
        } else
            out = bcc.getProperty(in, in);
        strb.delete(0,strb.length());
        char[] chars = out.toCharArray();
        for (int i=0;i<chars.length;i++) {
            if (Character.getNumericValue(chars[i]) > 126) {
                strb.append("&#");
                strb.append(Character.getNumericValue(chars[i]));
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
            String temp = bcc.getProperty(elements[0]);
            if (temp.charAt(0) == '*') {
                strb.append(temp.charAt(0));
                for (int i=1;i<elements.length;i++)
                    strb.append(bcc.getProperty(elements[i]));
                strb.append(temp.substring(1));
            } else {
                for (int i=0;i<elements.length;i++)
                    strb.append(bcc.getProperty(elements[i]));
            }
            return strb.toString();
        } else
            return bcc.getProperty(in, in);
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
    
    public void getParameter(String name) {
    }
    
    public void setParameter(String name, String param) {
    }
    
}
