package edu.unc.epidoc.transcoder.cocoon;

/*
 * TranscodingTransformer.java
 *
 * Created on October 27, 2002, 3:39 PM
 */

import edu.unc.epidoc.transcoder.*;
import java.util.Stack;
import org.apache.cocoon.transformation.AbstractTransformer;
import org.xml.sax.SAXException;

/**
 *
 * @author  hcayless
 */
public class TranscodingTransformer extends AbstractTransformer {
    
    public void setup(org.apache.cocoon.environment.SourceResolver sourceResolver, java.util.Map map, String str, org.apache.avalon.framework.parameters.Parameters parameters) throws org.apache.cocoon.ProcessingException, org.xml.sax.SAXException, java.io.IOException {
        getLogger().debug("TranscodingTransformer setup");
        tc = new TransCoder();
        try {
            tc.setParser(parameters.getParameter("parser", "BetaCode"));
            tc.setConverter(parameters.getParameter("converter", "Unicode"));
        } catch (Exception e) {
            getLogger().error("TranscodingTransformer setup", e);
        }
        elements = new Stack();
        languages = new Stack();
        languages.push(parameters.getParameter("language", DEFAULT_LANG));
    }
    
    public void recycle() {
        language = null;
        tc = null;
        elements = null;
        languages = null;
    }
    
    public void startElement(String uri, String name, String raw, org.xml.sax.Attributes attributes)
    throws SAXException {
        if (uri != null && uri.equals(namespace) && name.equals(tcName)) {
            language = attributes.getValue("lang");
            languages.push(attributes.getValue("lang"));
        } else {
            if (attributes.getValue("lang") != null) {
                language = attributes.getValue("lang");
                elements.push(new String[] {name, language});
            }
            this.contentHandler.startElement(uri, name, raw, attributes);
        }
    }
    
    public void endElement(String uri, String name, String raw)
    throws SAXException {
        if (uri != null && uri.equals(namespace) && name.equals(tcName)) {
            languages.pop();
            language = (String)languages.peek();
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
                getLogger().error("TranscodingTransformer characters", e);
            }
        }
        this.contentHandler.characters(strb.toString().toCharArray(), start, length);
    }
    
    private static String DEFAULT_LANG = "eng";
    private String language;
    private TransCoder tc;
    private Stack elements;
    private Stack languages;
    private static String namespace = "http://stoa.org/2002/transcoder";
    private static String tcName = "transcode";
    
}

