package edu.unc.epidoc.transcoder.xml;

/*
 * TranscodingHandler.java
 *
 * Created on October 27, 2002, 3:39 PM
 */

import edu.unc.epidoc.transcoder.*;
import java.util.Stack;
import org.xml.sax.*;
import org.xml.sax.ext.*;

/** The TranscodingTransformer is a Cocoon ({@link http://cocoon.apache.org})
 * Transformer which allows the integration of the Transcoder into Cocoon's
 * processing pipelines.  In order to use it, you will need to add the line:
 * <PRE>
 * &lt;map:transformer logger="sitemap.transformer.transcoding" name="transcoder" src="edu.unc.epidoc.transcoder.cocoon.TranscodingTransformer"/&gt;
 * </PRE>
 * to the &lt;map:transformers/&gt;area of the sitemap and call the TranscodingTransformer
 * in any desired pipelines.  The TranscodingTransformer can be invoked against XML with "lang"
 * attributes on any elements or on any area enclosed by the element "transcode" in the
 * TranscodingTransformer's namespace (http://stoa.org/2002/transcoder).  For example, both:
 * <PRE>
 * &lt;foreign lang="grc"&gt;OI) ME\N I)PPH/WN&lt;/foreign&gt;
 * </PRE>
 * and
 * <PRE>
 * &lt;transcode xmlns="http://stoa.org/2002/transcoder"&gt;A)SPIDI ME\N *SAI/+WM TIS A)GA/LLETAI&lt;transcoder&gt;
 * </PRE>
 * will cause the transcoder to be invoked against their content.  In order to enable
 * the TranscodingTransformer for any pipeline, add something like:
 * <PRE>
 * &lt;map:transform type="transcoder"&gt;
 *    &lt;map:parameter name="parser" value="BetaCode"/&gt;
 *    &lt;map:parameter name="converter" value="UnicodeC"/&gt;
 * &lt;/map:transform&gt;
 * </PRE>
 * to the pipeline.
 * @author Hugh A. Cayless (hcayless@email.unc.edu)
 * @version 0.9
 */
public class TranscodingHandler implements ContentHandler, LexicalHandler {
    
    /**
     * Set the <code>SourceResolver</code>, objectModel <code>Map</code>,
     * the source and sitemap <code>Parameters</code> used to process the request.
     */
    public void setup(ContentHandler contentHandler, LexicalHandler lexicalHandler, String parser, String converter, String useAttribute, String lang) throws Exception {
        this.contentHandler = contentHandler;
        tc = new TransCoder();
        if (parser != null)
            tc.setParser(parser);
        if (converter != null)
            tc.setConverter(converter);
        if (useAttribute != null)
            attributeName = useAttribute;
        else
            attributeName = "lang";
        
        elements = new Stack();
        languages = new Stack();
        if (lang != null)
            languages.push(lang);
        else
            languages.push(DEFAULT_LANG);
        parsers = new Stack();
        parsers.push(tc.getParser().getClass().getName());
        converters = new Stack();
        converters.push(tc.getConverter().getClass().getName());
    }
    
    /**
     * Handle the start of an element in the source document.
     */
    public void startElement(String uri, String name, String raw, org.xml.sax.Attributes attributes)
    throws SAXException {
        if (NAMESPACE.equals(uri) && name.equals(TC_NAME)) {
            language = attributes.getValue("lang");
            languages.push(attributes.getValue("lang"));
            if (attributes.getValue("source") != null) {
                parsers.push(attributes.getValue("source"));
                try {
                    tc.setParser((String)parsers.peek());
                } catch (Exception e) {
                    throw new SAXException(e);
                }
            }
            if (attributes.getValue("result") != null) {
                converters.push(attributes.getValue("result"));
                try {
                    tc.setConverter((String)converters.peek());
                } catch (Exception e) {
                    throw new SAXException(e);
                }
            }
        } else {
            if (attributes.getValue(attributeName) != null) {
                language = attributes.getValue(attributeName);
                elements.push(new String[] {name, language});
            }
            this.contentHandler.startElement(uri, name, raw, attributes);
        }
    }
    /**
     * Handle the end of an element in the source document.
     */
    public void endElement(String uri, String name, String raw)
    throws SAXException {
        if (NAMESPACE.equals(uri) && name.equals(TC_NAME)) {
            languages.pop();
            language = (String)languages.peek();
            if (parsers.size() > 1) {
                parsers.pop();
                try {
                    tc.setParser((String)parsers.peek());
                } catch (Exception e) {
                    throw new SAXException(e);
                }
            }
            if (converters.size() > 1) {
                converters.pop();
                try {
                    tc.setConverter((String)converters.peek());
                } catch (Exception e) {
                    throw new SAXException(e);
                }
            }
        } else {
            if (elements.size() > 0) {
                String[] elt = (String[])elements.peek();
                if (elt[0].equals(name)) {
                    elements.pop();
                    if (elements.size() > 0) {
                        elt = (String[])elements.peek();
                        language = elt[1];
                    } else
                        language = "eng";
                }
            }
            this.contentHandler.endElement(uri, name, raw);
        }
    }
    
    /**
     * Handle character data.
     */
    public void characters(char c[], int start, int len)
    throws SAXException {
        StringBuffer strb = new StringBuffer();
        int length = len;
        strb.append(c);
        if(tc.getParser().supportsLanguage(language)) {
            try {
                String in = new String(c, start, len);
                String out = tc.getString(in);
                strb.delete(start, start+len);
                strb.insert(start, out);
                length = out.length();
            } catch (Exception e) {
                throw new SAXException(e);
            }
        }
        this.contentHandler.characters(strb.toString().toCharArray(), start, length);
    }
    
    public void endDocument() throws SAXException {
        contentHandler.endDocument();
    }
    
    public void endPrefixMapping(String prefix) throws SAXException {
        contentHandler.endPrefixMapping(prefix);
    }
    
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
    
    private static String DEFAULT_LANG = "eng";
    private String language;
    private String attributeName = "lang";
    private TransCoder tc;
    private Stack elements;
    private Stack languages;
    private Stack parsers;
    private Stack converters;
    /** The namespace of the <CODE>TranscodingHandler</CODE> component. */
    public static String NAMESPACE = "http://stoa.org/2002/transcoder";
    private static String TC_NAME = "transcode";
    private ContentHandler contentHandler;
    private LexicalHandler lexicalHandler;
}

