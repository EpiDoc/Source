/*
 * AbstractParser.java
 *
 * Created on March 28, 2003, 8:44 AM
 */

package edu.unc.epidoc.transcoder;

import java.util.*;
import java.io.UnsupportedEncodingException;

/** Abstract class which implements most of the <CODE>Parser</CODE> interface.
 * New <CODE>Parser</CODE>s can be created by extending this class.
 * @author Hugh A. Cayless (hcayless@email.unc.edu)
 */
public abstract class AbstractParser implements Parser {    
    
    protected String encoding = "UTF8";
    protected String[] languages;
    
    protected char[] chArray;
    protected int index;
    protected String in;
    
    /** Returns the encoding method supported by this <CODE>Parser</CODE>.
     * @return The encoding.
     *
     */
    public String getEncoding() {
        return new String(encoding);
    }
    
    /** Provides a means of querying the <CODE>Parser</CODE>'s properties.
     * @param name The name of the property to be queried.
     * @return The value of the property.
     *
     */
    public Object getProperty(String name) {
        if ("supported-languages".equals(name)) 
            return languages;
        return null;
    }
    
    /** Provides a means of checking whether anything remains to
     * be parsed from the input String.
     * @return Whether or not anything remains to be parsed.
     *
     */
    public boolean hasNext() {
        if (index < chArray.length)
            return true;
        else
            return false;
    }
    
    /** Returns the next parsed character as a String.
     * @return The name of the parsed character.
     *
     */
    public abstract String next();
    
    /** Provides a mechanism for setting properties that alter the
     * processing behavior of the <CODE>Converter</CODE>.
     * @param name The property name.
     * @param value The property value.
     *
     */
    public void setProperty(String name, Object value) {
        if ("supported-languages".equals(name)) {
            if (value instanceof String[])
                languages = (String[])value;
        }
    }
    
    /** Sets the <CODE>String</CODE> to be parsed.
     * @param in The <CODE>String</CODE> to be parsed.
     *
     */
    public void setString(String in) throws UnsupportedEncodingException{
        this.in = new String(in.getBytes(), encoding);
        chArray = in.toCharArray();
        index = 0;
    }
    
    /** Provides a method of checking whether the <CODE>Parser</CODE> supports a
     * particular language.
     * @param lang The language code.
     * @return Whether the language is supported.
     *
     */
    public boolean supportsLanguage(String lang) {
        for (int i = 0; i < languages.length; i++)
            if (languages[i].equalsIgnoreCase(lang))
                return true;
        return false;
    }
    
}
