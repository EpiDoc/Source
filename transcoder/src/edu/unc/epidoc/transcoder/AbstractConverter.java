/*
 * AbstractConverter.java
 *
 * Created on March 28, 2003, 4:31 PM
 */

package edu.unc.epidoc.transcoder;

import java.util.*;

/**
 *
 * @author  hcayless
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
        return new String(ENCODING);
    }
    
    /** Provides a means of querying the <CODE>Converter</CODE>'s properties.
     * @param name The name of the property to be queried.
     * @return The value of the property.
     *
     */
    public Object getProperty(String name) {
        if ("suppress-unrecognized-characters".equals(name))
            return Boolean.valueOf(unrec.equals(""));
        else
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
                unrec = UNRECOGNIZED_CHAR;
        }
    }
    
    /** Provides a method of checking whether the Converter supports a
     * particular language.
     * @param lang The language code.
     * @return Whether the language is supported.
     *
     */
    public boolean supportsLanguage(String lang) {
        return LANGUAGE.equals(lang);
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
    
    protected static final String ENCODING = "UTF8";
    protected static final String LANGUAGE = "grc";
    protected static final String UNRECOGNIZED_CHAR = "?";
    protected String unrec = UNRECOGNIZED_CHAR;
    
}
