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
import org.xml.sax.helpers.AttributesImpl;

/** The TranscodingContentHandler is a SAX <code>ContentHandler</code>.  If 
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
public class TranscodingContentHandler implements ContentHandler, LexicalHandler {
    
    /**
     * The setup method must be called before the ContentHandler is used
     * @param ch A SAX ContentHandler
     * @param lh A SAX Lexical Handler
     * @param tc A pre-configured TransCoder
     * @param useAttribute The local name of an attribute to be used as a 
     * signal to transcode the contents of an element (default "lang").
     * @param lang THe default language (default "eng").
     * @param flowTerminators A List of String triples 
     * ([namespace, name, container|milestone]) that  will cause the 
     * TranscodingContentHandler's text buffer to flush.  The default are <p> 
     * and <lb/> tags.
     * Important if you are using large documents
     * @throws java.lang.Exception
     */
    public void setup(ContentHandler ch, LexicalHandler lh, TransCoder tc, String useAttribute, String lang, List<String[]> flowTerminators ) throws Exception {
        this.contentHandler = ch;
        this.lexicalHandler = lh;
        this.tc = tc;
        if (useAttribute != null) {
            this.langAttrs = new String[]{useAttribute};
        } else {
            langAttrs = new String[]{"lang", "xml:lang"};
        }
        this.elements = new Stack<String[]>();
        this.languages = new Stack<String>();
        if (lang != null) {
            languages.push(lang);
        } else {
            languages.push(DEFAULT_LANG);
        }
        this.parsers = new Stack<String>();
        this.parsers.push(tc.getParser().getClass().getName());
        this.converters = new Stack<String>();
        this.converters.push(tc.getConverter().getClass().getName());
        this.flowTerminators = new ArrayList<String[]>();
        if (flowTerminators == null) {
            this.flowTerminators.add(new String[]{"", "div([0-7])?", "container"});
            this.flowTerminators.add(new String[]{"", "p", "container"});
            this.flowTerminators.add(new String[]{"", "lb", "milestone"});
            this.flowTerminators.add(new String[]{"", "l", "container"});
            this.flowTerminators.add(new String[]{"http://www.tei-c.org/ns/1.0", "div([0-7])?", "container"});
            this.flowTerminators.add(new String[]{"http://www.tei-c.org/ns/1.0", "p", "container"});
            this.flowTerminators.add(new String[]{"http://www.tei-c.org/ns/1.0", "lb", "milestone"});
            this.flowTerminators.add(new String[]{"http://www.tei-c.org/ns/1.0", "l", "container"});
        } else {
            for (Iterator<String[]> i = flowTerminators.iterator(); i.hasNext();) {
                String[] ft = i.next();
                //do some scrubbing: namespace/name pairs only, no null or empty names, set null namespaces to empty String.
                if (ft.length == 3 && ft[1] != null && !"".equals(ft[1])) {
                    if (ft[0] == null) {
                        ft[0] = "";
                    }
                    this.flowTerminators.add(ft);
                }
            }
        }
    }
    
    public void setup(ContentHandler ch, LexicalHandler lh, TransCoder tc) throws Exception {
        this.setup(ch, lh, tc, null, null, null);
    }
    
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
        for (Iterator<String[]> i = this.flowTerminators.iterator(); i.hasNext();) {
            String[] ft = i.next();
            if (ft[0].equals(uri) && ft[1].matches(name) && !this.flushingBuffer) {
                if (this.eventBufferOn) {
                    this.eventBufferOn = false;
                    this.flushingBuffer = true;
                    flushEventBuffer();
                    this.flushingBuffer = false;
                    this.eventBufferOn = true;
                } else {
                    this.eventBufferOn = true;
                    this.charBuffer = new StringBuffer();
                }
            }
        }
        if (this.eventBufferOn) {
            this.eventBuffer.add(new Object[] {"startElement",uri,name,raw,new AttributesImpl(attributes)});
        } else {
            //true if this is a transcode element
            if (NAMESPACE.equals(uri) && name.equals(TC_NAME)) {
                for (String lang : langAttrs) {
                    if (attributes.getValue(lang) != null) {
                        language = attributes.getValue(lang);
                        break;
                    }
                }
                languages.push(new String(language));
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
                for (String lang : langAttrs) {
                    if (attributes.getValue(lang) != null) {
                        language = attributes.getValue(lang);
                        break;
                    }
                }
                elements.push(new String[] {name, new String(language)});
                this.contentHandler.startElement(uri, name, raw, attributes);
            }
        }
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
        for (Iterator<String[]> i = this.flowTerminators.iterator(); i.hasNext();) {
            String[] ft = i.next();
            if (ft[0].equals(uri) && name.matches(ft[1]) && !this.flushingBuffer && !"milestone".equals(ft[2])) {
                this.eventBufferOn = false;
                this.flushingBuffer = true;
                flushEventBuffer();
                this.flushingBuffer = false;
                break;
            }
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
                    String[] elt = elements.peek();
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
     * @throws org.xml.sax.SAXException 
     */
    public void characters(char c[], int start, int len)
    throws SAXException {
        try {
            if (this.eventBufferOn) {
                int offset = charBuffer.length();
                charBuffer.append(c, start, len);
                char[] ctmp = new char[0];
                this.eventBuffer.add(new Object[] {"characters",ctmp,offset,len});
            } else {
                if (charBuffer.length() > 0) {
                    if(tc.getParser().supportsLanguage(language)) {
                        String out = "";
                        try {
                            out = this.tc.getString(this.charBuffer, start, len);
                            this.contentHandler.characters(out.toCharArray(), 0, out.length());
                        } catch (Exception e) {
                            throw new SAXException(e);
                        }
                    } else {
                        this.contentHandler.characters(this.charBuffer.substring(start, start+len).toCharArray(), 0, len);
                    }
                } else {
                    if(tc.getParser().supportsLanguage(language)) {
                        String out = "";
                        try {
                            out = this.tc.getString(new String(c, start, len));
                            this.contentHandler.characters(out.toCharArray(), 0, out.length());
                        } catch (Exception e) {
                            throw new SAXException(e);
                        }
                    } else {
                        this.contentHandler.characters(c, start, len);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new SAXException(e);
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
                e.printStackTrace();
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
        if (this.eventBufferOn) {
            charBuffer.append(ch, start, length);
            char[] ctmp = new char[length];
            System.arraycopy(ch, start, ctmp, 0, length);
            this.eventBuffer.add(new Object[] {"ignorableWhitespace", ctmp, 0, length});
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
    private String language = DEFAULT_LANG;
    private String[] langAttrs;
    private TransCoder tc;
    private Stack<String[]> elements;
    private Stack<String> languages;
    private Stack<String> parsers;
    private Stack<String> converters;
    private List<Object[]> eventBuffer = new ArrayList<Object[]>();
    private StringBuffer charBuffer = new StringBuffer();
    private boolean eventBufferOn = false;
    private boolean flushingBuffer = false;
    private String currentElt;

    /** The namespace of the <CODE>TranscodingHandler</CODE> component. */
    public static String NAMESPACE = "http://stoa.org/2002/transcoder";
    private static String TC_NAME = "transcode";
    private ContentHandler contentHandler;
    private LexicalHandler lexicalHandler;
    private List<String[]> flowTerminators;

    
}

