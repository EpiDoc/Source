/*
 * MapReader.java
 *
 * Created on February 9, 2003, 11:31 AM
 */

package edu.unc.epidoc.transcoder;

import java.util.*;
import java.io.*;

/**
 *
 * @author  hcayless
 */
public class MapReader {
    
    /** Creates a new instance of MapReader */
    public MapReader() {
    }
    
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
    
    public String get(String key) {
        return (String)map.get(key);
    }
    
    public boolean contains(String key) {
        return map.containsKey(key);
    }
    
    
    
    private Map map;
    
    
}
