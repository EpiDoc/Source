/*
 * MapReader.java
 *
 * Created on February 9, 2003, 11:31 AM
 */

package edu.unc.epidoc.transcoder;

import java.util.*;
import java.io.*;

/** Convenience class for reading <CODE>Transcoder</CODE> properties files where the character
 * value is given as an <CODE>Integer</CODE>.
 * @author Hugh A. Cayless
 */
public class MapReader {
    
    /** Creates a new instance of MapReader */
    public MapReader() {
    }
    
    /** Load the properties file specified.
     * @param file The name of the properties file.
     * @param encoding The encoding that should be used in reading the file.
     */    
    public void load (String file, String encoding) {
        map = new HashMap();
                try {
            Class c = this.getClass();
            BufferedReader reader = new BufferedReader(
            new InputStreamReader(c.getResourceAsStream(file)));
            String key = null;
            String value = null;
            int temp = 0;
            char[] chars = new char[6];
            byte[] b = new byte[1];
            StringTokenizer st = null;
            while (reader.ready()) {
                st = new StringTokenizer(reader.readLine(), "=");
                if (st.hasMoreTokens())
                    key = st.nextToken().trim();
                else
                    break;
                if (st.hasMoreTokens()) {
                    value = st.nextToken().trim();
                    map.put(key, value);
                } else
                    map.put(key, "");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /** Method for retrieving a specific character's value.
     * @param key The character.
     * @return The translation of the character
     */    
    public String get(String key) {
        return (String)map.get(key);
    }
    
    /** Method for checking whether the loaded properties file contains a mapping
     * for the specified character.
     * @param key The character.
     * @return Whether the character exists in the properties file.
     */    
    public boolean contains(String key) {
        return map.containsKey(key);
    }
    
    
    
    private Map map;
    
    
}
