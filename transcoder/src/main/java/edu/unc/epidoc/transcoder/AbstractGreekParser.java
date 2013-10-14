/*
 * AbstractGreekParser.java
 *
 * Created on May 24, 2003, 11:17 AM
 */
package edu.unc.epidoc.transcoder;

import java.io.File;
import java.util.Properties;

/**
 *
 * @author hcayless
 */
public abstract class AbstractGreekParser extends AbstractParser {

  /**
   * Creates a new instance of AbstractGreekParser
   */
  public AbstractGreekParser() {
    languages = new String[]{"grc", "gr", "greek", "la-Grek"};


    Properties font_props = new Properties();

    // This should find the prefix,
    // for example if the parser is HellasParser, prefix will equal Hellas
    Class c = this.getClass();
    String prefix = c.getSimpleName().replaceFirst("Parser$", "");

    try {
      File f = new File(c.getResource(prefix + "Fonts.properties").toURI());
      if (f.exists()) {
        font_props.load(c.getResourceAsStream(prefix + "Fonts.properties"));
        fonts = font_props.getProperty("Fonts").split(",");
      }
    } catch (Exception e) {
      System.out.println(e.getMessage());
      e.printStackTrace(System.out);
    }
  }
}
