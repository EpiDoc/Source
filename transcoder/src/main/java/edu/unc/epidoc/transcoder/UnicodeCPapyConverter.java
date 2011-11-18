package edu.unc.epidoc.transcoder;

import java.util.Properties;

/**
 *
 * @author hcayless
 * 
 * Identical to the UnicodeCConverter, except it uses a set of conversions
 * specialized for Papyri.info. Lunate sigmas are converted to regular 
 * sigmas, for example.
 */
public class UnicodeCPapyConverter extends UnicodeCConverter {
  
   /** Creates new UnicodeNormalizationFormCConverter */
    public UnicodeCPapyConverter() {
        unfcc = new Properties();
        unfdc = new Properties();
        try {
            Class c = this.getClass();
            unfcc.load(c.getResourceAsStream("UnicodeCPapyConverter.properties"));
            unfdc.load(c.getResourceAsStream("UnicodeDConverter.properties"));
        } catch (Exception e) {
        }
    }
  
}
