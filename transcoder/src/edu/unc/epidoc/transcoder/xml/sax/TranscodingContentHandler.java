package edu.unc.epidoc.transcoder.xml.sax;

/*
 * TranscodingContentHandler.java
 *
 * Created on October 27, 2002, 3:39 PM
 */

import edu.unc.epidoc.transcoder.*;
import java.lang.reflect.*;
import java.util.*;
import org.xml.sax.*;
import org.xml.sax.ext.*;

/** The TranscodingContentHandler is a SAX <code>ContentHandler</code>.  
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
 * @version 1.1
 */
public class TranscodingContentHandler implements ContentHandler, LexicalHandler {
    
    /**
     * Set the <code>SourceResolver</code>, objectModel <code>Map</code>,
     * the source and sitemap <code>Parameters</code> used to process the request.
     * @param contentHandler a SAX ContentHandler to be wrapped by the TranscodingContentHandler
     * @param lexicalHandler a SAX LexicalHandler to be wrapped
     * @param parser a transcoder <code>Parser</code>
     * @param converter a transcoder <code>Converter</code>
     * @param useAttribute the name of the attribute to use to signal encoding changes
     * @param lang 
     * @throws java.lang.Exception 
     */
    public void setup(ContentHandler contentHandler, LexicalHandler lexicalHandler, String parser, String converter, String useAttribute, String lang) throws Exception {
        tc = new TransCoder();
        if (parser != null) {
            tc.setParser(parser);
        }
        if (converter != null) {
            tc.setConverter(converter);
        }
        this.setup(contentHandler, lexicalHandler, tc, useAttribute, lang);
    }
    
    public void setup(ContentHandler ch, LexicalHandler lh, TransCoder tc, String useAttribute, String lang) throws Exception {
        this.contentHandler = ch;
        this.lexicalHandler = lh;
        this.tc = tc;
        if (useAttribute != null) {
            this.langAttr = useAttribute;
        } else {
            langAttr = "lang";
        }
        this.elements = new Stack();
        this.languages = new Stack();
        if (lang != null) {
            languages.push(lang);
        } else {
            languages.push(DEFAULT_LANG);
        }
        this.parsers = new Stack();
        this.parsers.push(tc.getParser().getClass().getName());
        this.converters = new Stack();
        this.converters.push(tc.getConverter().getClass().getName());
    }
    
    /**
     * Handle the start of an element in the source document.
     * @param name the local name (without prefix), or the
     *        empty string if Namespace processing is not being
     *        performed
     * @param raw the qualified name (with prefix), or the
     *        empty string if qualified names are not available
     * @param attributes the attributes attached to the element.  If
     *        there are no attributes, it shall be an empty
     *        Attributes object.  The value of this object after
     *        startElement returns is undefined
     */
    public void startElement(String uri, String name, String raw, org.xml.sax.Attributes attributes)
    throws SAXException {
        if ("p".equals(name)) {
            this.eventBufferOn = true;
            this.charBuffer = new StringBuffer();
        }
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"startElement",uri,name,raw,attributes});
        } else {
            //true if this is a transcode element
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
                if (attributes.getValue(langAttr) != null) {
                    language = attributes.getValue(langAttr);
                }
                elements.push(new String[] {name, attributes.getValue(langAttr)});
                this.contentHandler.startElement(uri, name, raw, attributes);
            }
        }
    }
    /**
     * Handle the end of an element in the source document.
     * @param name the local name (without prefix), or the
     *        empty string if Namespace processing is not being
     *        performed
     * @param raw the qualified XML name (with prefix), or the
     *        empty string if qualified names are not available
     */
    public void endElement(String uri, String name, String raw)
    throws SAXException {
        if ("p".equals(name) && !this.flushingBuffer) {
            this.eventBufferOn = false;
            this.flushingBuffer = true;
            flushEventBuffer();
            this.flushingBuffer = false;
        }
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"endElement",uri,name,raw});
        } else {
            //true if this was a transcode element
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
                elements.pop();
                language = "eng";
                if (elements.size() > 0) {
                    String[] elt = (String[])elements.peek();
                    if (elt[1] != null) {
                       language = elt[1]; 
                    }
                } 

                this.contentHandler.endElement(uri, name, raw);
            }
        }
    }
    
    /**
     * Handle character data.  Since character data != all of the text inside
     * and element, the data is buffered and then flushed when an element
     * close or open event occurs.
     * @param c the character array
     * @param start the position in the array from which to start reading
     * @param len how far to read
     */
    public void characters(char c[], int start, int len)
    throws SAXException {
        if (this.eventBufferOn) {
            int offset = charBuffer.length();
            charBuffer.append(c, start, len);
            char[] ctmp = new char[0];
            this.eventBuffer.add(new Object[] {"characters",ctmp,offset,len});
        } else {
            if (charBuffer.length() > 0) {
                if(tc.getParser().supportsLanguage(language)) {
                    String in = "";
                    String out = "";
                    try {
                        out = this.tc.getString(this.charBuffer, start, len);
                        this.contentHandler.characters(out.toCharArray(), 0, out.length());
                    } catch (Exception e) {
                        throw new SAXException(e);
                    }
                } else {
                    this.contentHandler.characters(this.charBuffer.substring(start, len).toCharArray(), 0, len);
                }
            } else {
                this.contentHandler.characters(c, start, len);
            }
        }
    }
    
    private synchronized void flushEventBuffer() throws SAXException {
        while (!this.eventBuffer.isEmpty()) {
            Object[] o = this.eventBuffer.remove(0);
            Method[] methods = this.getClass().getMethods();
            try {
                
                Method m = null;
                for (int j = 0; j < methods.length; j++) {
                    if (o[0].equals(methods[j].getName())) {
                        m = methods[j];
                    }
                }
                if (o.length > 1) {
                    Object[] params = new Object[o.length - 1];
                    System.arraycopy(o, 1, params, 0, params.length);
                    m.invoke(this, params);
                } else {
                   m.invoke(this, (Object[])null); 
                }
            } catch (Exception e) {
                throw new SAXException(e);
            }
        }
        this.charBuffer = new StringBuffer();
    }
    
    public void endDocument() throws SAXException {
        contentHandler.endDocument();
    }
    
    public void endPrefixMapping(String prefix) throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"endPrefixMapping"});
        } else {
            contentHandler.endPrefixMapping(prefix);
        }
    }
    
    public void ignorableWhitespace(char[] ch, int start, int length) throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"ignorableWhitespace", ch, start, length});
        } else {
            contentHandler.ignorableWhitespace(ch, start, length);
        }
    }
    
    public void processingInstruction(String target, String data) throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"processingInstruction", target, data});
        } else {
            contentHandler.processingInstruction(target, data);
        }
    }
    
    public void setDocumentLocator(Locator locator) {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"setDocumentLocator", locator});
        } else {
            contentHandler.setDocumentLocator(locator);
        }
    }
    
    public void skippedEntity(String name) throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"skippedEntity", name});
        } else {
            contentHandler.skippedEntity(name);
        }
    }
    
    public void startDocument() throws SAXException {
        contentHandler.startDocument();
    }
    
    public void startPrefixMapping(String prefix, String uri) throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"startPrefixMapping", prefix, uri});
        } else {
            contentHandler.startPrefixMapping(prefix, uri);
        }
    }
    
    public void comment(char[] ch, int start, int length) throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"comment", ch, start, length});
        } else {
            lexicalHandler.comment(ch, start, length);
        }
    }
    
    public void endCDATA() throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"endCDATA"});
        } else {
            lexicalHandler.endCDATA();
        }
    }
    
    public void endDTD() throws SAXException {
        lexicalHandler.endDTD();
    }
    
    public void endEntity(String name) throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"endEntity", name});
        } else {
            lexicalHandler.endEntity(name);
        }
    }
    
    public void startCDATA() throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"startCDATA"});
        } else {
            lexicalHandler.startCDATA();
        }
    }
    
    public void startDTD(String name, String publicId, String systemId) throws SAXException {
        lexicalHandler.startDTD(name, publicId, systemId);
    }
    
    public void startEntity(String name) throws SAXException {
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"startEntity", name});
        } else {
            lexicalHandler.startEntity(name);
        }
    }
    
    private static String DEFAULT_LANG = "eng";
    private String language;
    private String langAttr = "lang";
    private TransCoder tc;
    private Stack elements;
    private Stack languages;
    private Stack parsers;
    private Stack converters;
    private List<Object[]> eventBuffer = new ArrayList();
    private StringBuffer charBuffer = new StringBuffer();
    private boolean eventBufferOn = false;
    private boolean flushingBuffer = false;
    private StringBuffer strb;
    /** The namespace of the <CODE>TranscodingHandler</CODE> component. */
    public static String NAMESPACE = "http://stoa.org/2002/transcoder";
    private static String TC_NAME = "transcode";
    private ContentHandler contentHandler;
    private LexicalHandler lexicalHandler;
    

    
}

