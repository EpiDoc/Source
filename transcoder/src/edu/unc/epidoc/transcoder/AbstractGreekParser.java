/*
 * AbstractGreekParser.java
 *
 * Created on May 24, 2003, 11:17 AM
 */

package edu.unc.epidoc.transcoder;

/**
 *
 * @author  hcayless
 */
public abstract class AbstractGreekParser extends AbstractParser {
    
    /** Creates a new instance of AbstractGreekParser */
    public AbstractGreekParser() {
        languages = new String[] {"grc", "gr", "greek"};
    }
    
}
