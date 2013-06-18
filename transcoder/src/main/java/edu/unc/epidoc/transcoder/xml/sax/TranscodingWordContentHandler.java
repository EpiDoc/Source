package edu.unc.epidoc.transcoder.xml.sax;

/*
 * TranscodingWordContentHandler.java
 *
 * Created on October 27, 2002, 3:39 PM
 */

import edu.unc.epidoc.transcoder.*;
import java.lang.reflect.*;
import java.util.*;
import org.xml.sax.*;
import org.xml.sax.ext.*;
import org.xml.sax.helpers.AttributesImpl;
import java.util.Properties;

/** The TranscodingWordContentHandler is a SAX <code>ContentHandler</code>.  If
 * passed into a SAX process, it will transcode Greek text that it finds.
 * The ContentHandler detects Greek text by means of attributes in the source,
 * or it can simply transcode the entire text content.  It buffers the text as
 * it processes, in order to be able to detect word boundaries and properly
 * handle medial vs. final sigma.  Elements that trigger buffering (and buffer
 * flushing) are, by default, <p> and <lb/>.  If buffering is not desired, an
 * empty element list can be passed to the setup method.
 *
 * For example, both:
 * <PRE>
 * &lt;foreign lang="grc"&gt;OI) ME\N I)PPH/WN&lt;/foreign&gt;
 * </PRE>
 * and
 * <PRE>
 * &lt;transcode xmlns="http://stoa.org/2002/transcoder"&gt;A)SPIDI ME\N *SAI/+WM TIS A)GA/LLETAI&lt;transcoder&gt;
 * </PRE>
 * will cause the transcoder to be invoked against their content.
 * @author Hugh A. Cayless (hcayless@email.unc.edu)
 * @version 1.2
 */
public class TranscodingWordContentHandler implements ContentHandler, LexicalHandler {

  /**
   * The setup method must be called before the ContentHandler is used
   * @param ch A SAX ContentHandler
   * @param lh A SAX Lexical Handler
   * @param tc A pre-configured TransCoder
   * @param useAttribute The local name of an attribute to be used as a
   * signal to transcode the contents of an element (default "lang").
   * @param lang The default language (default "eng").
   * @param flowTerminators A List of String triples
   * ([namespace, name, container|milestone]) that  will cause the
   * TranscodingWordContentHandler's text buffer to flush.  The default are <p>
   * and <lb/> tags.
   * Important if you are using large documents
   * @throws java.lang.Exception
   */
  public void setup(ContentHandler ch, LexicalHandler lh, TransCoder tc, String useAttribute) throws Exception {
    this.contentHandler = ch;
    this.lexicalHandler = lh;
    this.tc = tc;
    if (useAttribute != null) {
      this.fontAttrs = new String[]{useAttribute};
    } else {
      fontAttrs = new String[]{"w:ascii", "w:cs", "w:hAnsi"};
    }
    this.elements = new Stack<String[]>();
    this.fonts = new Stack<String>();

    this.parsers = new Stack<String>();
    this.parsers.push(tc.getParser().getClass().getName());
    this.converters = new Stack<String>();
    this.converters.push(tc.getConverter().getClass().getName());

    font = tc.getConverter().getDefaultFont();
    if (font != null) {
      fonts.push(font);
    } else {
      fonts.push(DEFAULT_FONT);
      font = DEFAULT_FONT;
    }
  }

  public void setup(ContentHandler ch, LexicalHandler lh, TransCoder tc) throws Exception {
    this.setup(ch, lh, tc, null);
  }


  /* Lexical Handler methods */

  /**
   * Handle the start of an element in the source document.
   * @param uri the namespace URI
   * @param name the local name (without prefix), or the
   *        empty string if Namespace processing is not being
   *        performed
   * @param raw the qualified name (with prefix), or the
   *        empty string if qualified names are not available
   * @param attributes the attributes attached to the element.  If
   *        there are no attributes, it shall be an empty
   *        Attributes object.  The value of this object after
   *        startElement returns is undefined
   * @throws org.xml.sax.SAXException
   */
  public void startElement(String uri, String name, String raw, org.xml.sax.Attributes attributes)
  throws SAXException {
    this.currentElt = name;

    String lastPushedElt = "";

    if (elements.size() > 0) {
      // name of the last pushed element
      lastPushedElt = elements.peek()[0];
    }

    if(NAMESPACE.equals(uri) && (name.equals(R_NODE) || name.equals(P_NODE))) {

      font = DEFAULT_FONT;

      log("pushed font " + font);
      // always record current font on <R_NODE> and <P_NODE>
      fonts.push(font);

      log("pushed element " + name);
      elements.push(new String[] {name, new String(fonts.peek())});

    } else if((NAMESPACE.equals(uri) && name.equals(PPR_NODE)) && lastPushedElt.equals(P_NODE)) {
      log("pushed element " + name);
      elements.push(new String[] {name, new String(fonts.peek())});

    } else if((NAMESPACE.equals(uri) && name.equals(RPR_NODE)) &&
                (lastPushedElt.equals(R_NODE) || lastPushedElt.equals(PPR_NODE))) {

      log("pushed element " + name);
      elements.push(new String[] {name, new String(fonts.peek())});

    } else if((NAMESPACE.equals(uri) && name.equals(RFONTS_NODE)) && lastPushedElt.equals(RPR_NODE)) {

      for (String fontAttr : fontAttrs) {
        if (attributes.getValue(fontAttr) != null) {
          font = attributes.getValue(fontAttr);
          break;
        }
      }

      if(tc.getParser().supportsFont(font)) {

        // get the appropriate forn to convert to
        String conv_font = tc.getConverter().getDefaultFont();

        log("Conversion font " + conv_font);


        AttributesImpl new_attrs = new AttributesImpl(attributes);

        // change all font attributes to new font
        for (String fontAttr : fontAttrs) {
          int attr_index = attributes.getIndex(fontAttr);
          if (attr_index != -1) {
            new_attrs.setValue(attr_index, conv_font);
          }
        }
        // attributes to newly updated object
        attributes = new_attrs;
      }

      // pop the font we have been carrying for this <R_NODE> or <P_NODE>
      fonts.pop();

      // push new font
      log("pushed font " + font);
      fonts.push(new String(font));


      log("pushed element " + name);
      elements.push(new String[] {name, new String(font)});

    } else if((NAMESPACE.equals(uri) && name.equals(T_NODE)) && lastPushedElt.equals(RPR_NODE)) {
      // TEXT ELEMENT
      log("pushed element " + name);
      elements.push(new String[] {name, new String(fonts.peek())});
    } else {

    }

    this.contentHandler.startElement(uri, name, raw, attributes);
  }
  /**
   * Handle the end of an element in the source document.
   * @param uri the Namespace
   * @param name the local name (without prefix), or the
   *        empty string if Namespace processing is not being
   *        performed
   * @param raw the qualified XML name (with prefix), or the
   *        empty string if qualified names are not available
   * @throws org.xml.sax.SAXException
   */
  public void endElement(String uri, String name, String raw)
  throws SAXException {
    this.currentElt = name;
    // transcode if charBuffer has elements:
    if (this.charBuffer.length() > 0) {

        // transcode
        log("\nTranscode:");
        String out = "";

        try {
          log("from " + this.charBuffer);
          out = this.tc.getString(this.charBuffer, 0, this.charBuffer.length());
          log("to " + out);
          this.contentHandler.characters(out.toCharArray(), 0, out.length());
        } catch (Exception e) {
          throw new SAXException(e);
        } finally {
          this.charBuffer.delete(0, this.charBuffer.length());
        }
    }


    // name of the last pushed element
    String lastPushedElt = "";
    if (elements.size() > 0) {
      lastPushedElt = elements.peek()[0];
    }

    // only pop if current element is the same as the last element in the stack

    if (lastPushedElt.equals(name)){
      if(NAMESPACE.equals(uri) && (name.equals(R_NODE) || name.equals(P_NODE))) {

        // pop fonts in <R_NODE> and <P_NODE>
        log("popped element " + name);
        elements.pop();
        fonts.pop();
        font = fonts.peek();
      } else if(NAMESPACE.equals(uri) &&
                (name.equals(RPR_NODE) ||
                  name.equals(PPR_NODE) ||
                  name.equals(RFONTS_NODE) ||
                  name.equals(T_NODE))) {
        // pop any other element
        log("popped element " + name);
        elements.pop();
      } else {

      }
    }

    this.contentHandler.endElement(uri, name, raw);

 }

  /**
   * Handle character data.  Since character data != all of the text inside
   * and element, the data is buffered and then flushed when an element
   * close or open event occurs.
   * @param c the character array
   * @param start the position in the array from which to start reading
   * @param len how far to read
   * @throws org.xml.sax.SAXException
   */
  public void characters(char c[], int start, int len)
  throws SAXException {
    try {
      if(tc.getParser().supportsFont(font)) {
        // if current parser supports current font
        // save for transcoding
        this.charBuffer.append(c, start, len);
      } else {
        this.contentHandler.characters(c, start, len);
      }
    } catch (Exception e) {
      e.printStackTrace();
      throw new SAXException(e);
    }
  }

  public void endDocument() throws SAXException {
    contentHandler.endDocument();
  }

  public void endPrefixMapping(String prefix) throws SAXException {
    contentHandler.endPrefixMapping(prefix);
  }

  /**
   * For text buffering purposes, ignorable whitespace isn't treated as ignorable.  It is added
   * to the text buffer and has an effect on character transcoding.
   *
   * @param ch
   * @param start
   * @param length
   * @throws org.xml.sax.SAXException
   */
  public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
    contentHandler.ignorableWhitespace(ch, start, length);
  }

  public void processingInstruction(String target, String data) throws SAXException {
    contentHandler.processingInstruction(target, data);
  }

  public void setDocumentLocator(Locator locator) {
    contentHandler.setDocumentLocator(locator);
  }

  public void skippedEntity(String name) throws SAXException {
    contentHandler.skippedEntity(name);
  }

  public void startDocument() throws SAXException {
    contentHandler.startDocument();
  }

  public void startPrefixMapping(String prefix, String uri) throws SAXException {
    contentHandler.startPrefixMapping(prefix, uri);
  }


  /* Lexical Handler methods */
  public void comment(char[] ch, int start, int length) throws SAXException {
    lexicalHandler.comment(ch, start, length);
  }

  public void endCDATA() throws SAXException {
    lexicalHandler.endCDATA();
  }

  public void endDTD() throws SAXException {
    lexicalHandler.endDTD();
  }

  public void endEntity(String name) throws SAXException {
    lexicalHandler.endEntity(name);
  }

  public void startCDATA() throws SAXException {
    lexicalHandler.startCDATA();
  }

  public void startDTD(String name, String publicId, String systemId) throws SAXException {
    lexicalHandler.startDTD(name, publicId, systemId);
  }

  public void startEntity(String name) throws SAXException {
    lexicalHandler.startEntity(name);
  }

  public void log(String message) {
      if (verbose) {
          System.out.println(message);
      }
  }


  private static String DEFAULT_FONT = "Palatino";
  private String font = DEFAULT_FONT;
  private String[] fontAttrs;
  private TransCoder tc;
  private Stack<String[]> elements;
  private Stack<String> fonts;
  private Stack<String> parsers;
  private Stack<String> converters;
  private StringBuffer charBuffer = new StringBuffer();
  private String currentElt;
  private Boolean verbose = false;


  // Paragpah Node
  private static String P_NODE = "p";

  // Paragraph Properties Node
  private static String PPR_NODE = "pPr";

  // Text Run Node
  private static String R_NODE = "r";

  // Run Properties for the Paragraph Mark
  // can be under <PPR_NODE> or <R_NODE>
  private static String RPR_NODE = "rPr";
  // Run Fonts Node
  // Always under <RPR_NODE>
  private static String RFONTS_NODE = "rFonts";

  // Text Node
  private static String T_NODE = "t";

  /** The namespace of the <CODE>TranscodingHandler</CODE> component. */
  public static String NAMESPACE = "http://schemas.openxmlformats.org/wordprocessingml/2006/main";
  private ContentHandler contentHandler;
  private LexicalHandler lexicalHandler;
}

