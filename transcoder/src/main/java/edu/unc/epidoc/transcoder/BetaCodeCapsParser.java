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

  /** Returns the next parsed character as a String.
   * @return The name of the parsed character.
   */
  @Override
  public String next() {
    strb.delete(0, strb.length());
    if (in != null) {
      char ch = chArray[index];
      index++;
      map.clear();
      escape.delete(0, escape.length());
      if (hasNext() && isBetaCodePrefix(ch)) {
        if (Character.isDigit(chArray[index]) || isBetaCodePrefix(chArray[index])) {
          escape.append(ch);
          if (isBetaCodePrefix(chArray[index])) {
            escape.append(chArray[index]);
            index++;
          }
          if (hasNext()) {
            while (hasNext() && (Character.isDigit(chArray[index]))) {
              escape.append(chArray[index]);
              index++;
            }
          }
          String result = lookup(escape.toString());
          // reset if this isn't a recognized Beta Code escape
          if (result.equals(escape.toString())) {
            index -= (escape.length() - 1);
            escape.delete(1, escape.length());
          }
          strb.append((lookup(escape.toString())));
        } else {
          if (ch == '*') {
            strb.append(ch);
          } else if (ch == '#' && Character.isLetter(chArray[index])) {
            strb.append(lookup(ch));
          } else {
            while (hasNext() && isBetaCodeDiacritical(chArray[index])) {
              map.put(lookupAccent(chArray[index]), lookup(chArray[index]));
              index++;
            }
            if (hasNext()) {
              strb.append(lookup(lookup(ch) + String.valueOf(chArray[index])));
              index++;
              while (!map.isEmpty()) {
                String str = (String) map.remove(map.firstKey());
                strb.append("_").append(str);
              }
            }
          }
        }
      } else {
        if (ch == 'S' || ch == 's') {
          if (index < chArray.length && Character.isDigit(chArray[index])) {
            escape.append(ch);
            escape.append(chArray[index]);
            index++;
            strb.append(lookup(escape.toString()));
          } else {
            if (!isTerminalSigma(chArray, index)) {
              strb.append(lookup(ch));
            } else {
              strb.append(lookup(String.valueOf(ch) + "2"));
            }

          }
        } else {
          strb.append(lookup(ch));
          while (hasNext() && isBetaCodeDiacritical(chArray[index])) {
            map.put(lookupAccent(chArray[index]), lookup(chArray[index]));
            index++;
          }
          while (map.size() > 0) {
            String str = (String) map.remove(map.firstKey());
            strb.append("_").append(str);
          }
        }
      }
    }
    return strb.toString();
  }

  @Override
  protected String lookup(char ch) {
    char chr = ch;
    String key = String.valueOf(chr);
    return bcp.getProperty(key, String.valueOf(ch));
  }
}
