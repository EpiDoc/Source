 /*
 * AbstractConverter.java
 *
 * (c) Hugh A. Cayless (hcayless@email.unc.edu)
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.util.*;

/** Abstract class which implements most of the <CODE>Converter</CODE> interface.
 * New <CODE>Converter</CODE>s can be created by extending this class.
 * @author Hugh A. Cayless (hcayless@email.unc.edu)
 */
public abstract class AbstractConverter implements edu.unc.epidoc.transcoder.Converter {
    
    /** Convert the input String to a String in the desired encoding with
     * characters greater than 127 escaped as XML character entities.
     * @param in The String to be converted
     * @return The converted String.
     *
     */
    public abstract String convertToCharacterEntities(Parser in);
    
    /** Convert the input String to a String in the desired encoding.
     * @param in The String to be converted.
     * @return The converted String.
     *
     */
    public abstract String convertToString(Parser in);
    
    /** Returns the encoding method supported by this <CODE>Converter</CODE>.
     * @return The encoding.
     *
     */
    public String getEncoding() {
        return new String(encoding);
    }
    
    /** Provides a means of querying the <CODE>Converter</CODE>'s properties.
     * @param name The name of the property to be queried.
     * @return The value of the property.
     *
     */
    public Object getProperty(String name) {
        if ("suppress-unrecognized-characters".equals(name))
            return new Boolean(unrec.equals(""));
        if ("supported-languages".equals(name))
            return languages;
        return null;
    }
    
    /** Provides a mechanism for setting properties that alter the
     * processing behavior of the <CODE>Converter</CODE>.
     * @param name The property name.
     * @param value The property value.
     *
     */
    public void setProperty(String name, Object value) {
        if ("suppress-unrecognized-characters".equals(name)) {
            String val = (String)value;
            if ("true".equals(val))
                unrec = "";
            else
                unrec = unrecognizedChar;
        }
        if ("supported-languages".equals(name)) {
            if (value instanceof String[])
                languages = (String[])value;
        }
    }
    
    /** Provides a method of checking whether the Converter supports a
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
    
    protected String[] split(String str) {
        StringTokenizer st = new StringTokenizer(str, "_");
        int tokenCount = st.countTokens();
        String[] result = new String[tokenCount];
        for (int i = 0; i < tokenCount; i++) {
            result[i] = st.nextToken();
        }
        return result;
    }
    
    protected String encoding = "UTF8";
    protected String[] languages;
    protected String unrecognizedChar = "?";
    protected String unrec = unrecognizedChar;
    
}
