/*
 * Parser.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.io.UnsupportedEncodingException;

/** A Parser's function is to read a String or File chunk by chunk
 * and return the name of the character represented by that chunk.
 * The nature of a chunk will vary depending on the encoding scheme
 * and font with which the string was constructed.
 * @author Hugh A. Cayless
 * @version 0.9
 *
 *
 */
public interface Parser {
        
    /** Provides a means of checking whether anything remains to
     * be parsed from the input String.
     * @return Whether or not anything remains to be parsed.
     */    
    public boolean hasNext();
    
    /** Returns the next parsed character as a String.
     * @return The name of the parsed character.
     */    
    public String next();
    
    /** Sets the <CODE>String</CODE> to be parsed.
     * @param in The <CODE>String</CODE> to be parsed.
     */    
    public void setString(String in) throws UnsupportedEncodingException;        
    
    /** Provides a means of querying the <CODE>Parser</CODE>'s properties.
     * @param name The name of the property to be queried.
     * @return The value of the property.
     */ 
    public Object getProperty(String name);
    
    /** Provides a mechanism for setting properties that alter the
     * processing behavior of the <CODE>Converter</CODE>.
     * @param name The property name.
     * @param value The property value.
     */ 
    public void setProperty(String name, Object value);    
    
    /** Returns the encoding method supported by this <CODE>Parser</CODE>.
     * @return The encoding.
     */  
    public String getEncoding();
    
    /** Provides a method of checking whether the <CODE>Parser</CODE> supports a
     * particular language.
     * @param lang The language code.
     * @return Whether the language is supported.
     */  
    public boolean supportsLanguage(String lang);
        
}

