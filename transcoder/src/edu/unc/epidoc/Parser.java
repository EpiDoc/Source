/*
 * Parser.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc;

/**
 *
 * @author  Hugh A. Cayless
 * @version 0.1
 *
 * A Parser's function is to read a String or File chunk by chunk
 * and return the name of the character represented by that chunk.
 * The nature of a chunk will vary depending on the encoding scheme
 * and font with which the string was constructed.  
 */
public interface Parser {
        
    public boolean hasNext();
    
    public String next();
    
    public void setString(String in);        
    
    public Object getProperty(String name);
    
    public void setProperty(String name, Object value);
    
    public String getEncoding();
    
    public boolean supportsLanguage(String lang);
        
}

