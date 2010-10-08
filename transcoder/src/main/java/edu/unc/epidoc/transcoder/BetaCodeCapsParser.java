/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.unc.epidoc.transcoder;

import java.util.HashMap;
import java.util.Properties;
import java.util.TreeMap;

/**
 *
 * @author hcayless
 */
public class BetaCodeCapsParser extends BetaCodeParser {

  public BetaCodeCapsParser() {
    encoding = "US-ASCII";
    if (properties.isEmpty()) {
      bcp = new Properties();
      ga = new Properties();
      synchronized (properties) {
        try {
          Class c = this.getClass();
          bcp.load(c.getResourceAsStream("BetaCodeCapsParser.properties"));
          ga.load(c.getResourceAsStream("GreekAccents.properties"));
        } catch (Exception e) {
          System.out.println(e.getMessage());
          e.printStackTrace(System.out);
        }
        properties.put("bcp", bcp);
        properties.put("ga", ga);
      }
    } else {
      bcp = properties.get("bcp");
      ga = properties.get("ga");
    }
  }
  private static final HashMap<String, Properties> properties = new HashMap<String, Properties>();
  private Properties bcp;
  private Properties ga;
  private StringBuffer strb = new StringBuffer();
  private TreeMap<String, String> map = new TreeMap<String, String>();
  private StringBuffer escape = new StringBuffer();

  @Override
  protected String lookup(char ch) {
    char chr = ch;
    String key = String.valueOf(chr);
    return bcp.getProperty(key, String.valueOf(ch));
  }
}
