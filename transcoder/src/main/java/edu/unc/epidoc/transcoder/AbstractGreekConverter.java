/*
 * AbstractGreekConverter.java
 *
 * Created on May 24, 2003, 10:59 AM
 */

package edu.unc.epidoc.transcoder;

/**
 *
 * @author  hcayless
 */
public abstract class AbstractGreekConverter extends AbstractConverter {
    
    /** Creates a new instance of AbstractGreekConverter */
    public AbstractGreekConverter() {
        languages = new String[] {"grc", "gr", "greek"};
    }
    
}
