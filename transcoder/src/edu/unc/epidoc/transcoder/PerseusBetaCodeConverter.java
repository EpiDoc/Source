/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package edu.unc.epidoc.transcoder;
import java.util.Properties;


/**
 *
 * @author hcayless
 *
 * Essentially the same as BetaCodeConverter, but outputs lower case beta code
 * in the fashion of Perseus' format.
 */
public class PerseusBetaCodeConverter extends BetaCodeConverter {
    /** Creates new PerseusBetaCodeConverter */
    public PerseusBetaCodeConverter() {
        encoding = "US-ASCII";
        bcc = new Properties();
        try {
            Class c = this.getClass();
            bcc.load(c.getResourceAsStream("PerseusBetaCodeConverter.properties"));
        } catch (Exception e) {
        }
    }
}
