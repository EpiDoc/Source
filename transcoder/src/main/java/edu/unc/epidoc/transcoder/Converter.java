/*
 * Converter.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details. */

package edu.unc.epidoc.transcoder;

/** A Converter's function is to take a character or the name
 * of a character as input and return that character in the
 * desired encoding. If the result encoding does not contain
 * the named character, then the converter will return the
 * character it is passed.
 * @author Hugh A. Cayless (hcayless@email.unc.edu)
 * @version 0.9
 */
public interface Converter {
    
    /** Convert the input <CODE>Parser</CODE> to a <CODE>String</CODE> in the desired encoding.
     * @param in The <CODE>Parser</CODE> to be converted.
     * @return The converted <CODE>String</CODE>.
     */    
    public String convertToString(Parser in); 
    
    /** Convert the input <CODE>Parser</CODE> to a <CODE>String</CODE> in the desired encoding with
     * characters greater than 127 escaped as XML character entities.
     * @param in The <CODE>Parser</CODE> to be converted
     * @return The converted <CODE>String</CODE>.
     */    
    public String convertToCharacterEntities(Parser in);     
    
    /** Provides a mechanism for setting properties that alter the
     * processing behavior of the <CODE>Converter</CODE>.
     * @param name The property name.
     * @param value The property value.
     */    
    public void setProperty(String name, Object value);
    
    /** Provides a means of querying the <CODE>Converter</CODE>'s properties.
     * @param name The name of the property to be queried.
     * @return The value of the property.
     */    
    public Object getProperty(String name);
    
    /** Returns the encoding method supported by this <CODE>Converter</CODE>.
     * @return The encoding.
     */    
    public String getEncoding();
    
    /** Provides a method of checking whether the Converter supports a
     * particular language.
     * @param lang The language code.
     * @return Whether the language is supported.
     */    
    public boolean supportsLanguage(String lang);

}
