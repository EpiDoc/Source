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
public class TranscodingTransformer extends AbstractTransformer {
    
    /**
     * Set the <code>SourceResolver</code>, objectModel <code>Map</code>,
     * the source and sitemap <code>Parameters</code> used to process the request.
     */   
    public void setup(org.apache.cocoon.environment.SourceResolver sourceResolver, java.util.Map map, String str, org.apache.avalon.framework.parameters.Parameters parameters) throws org.apache.cocoon.ProcessingException, org.xml.sax.SAXException, java.io.IOException {
        getLogger().debug("TranscodingTransformer setup");
        tc = new TransCoder();
        try {
            tc.setParser(parameters.getParameter("parser", "BetaCode"));
            tc.setConverter(parameters.getParameter("converter", "Unicode"));
            
            attributeName = parameters.getParameter("useAttribute", "lang");
            String setLanguage = parameters.getParameter("setLanguage");
            if (setLanguage != null) {
                String[] arr = (String[])tc.getParser().getProperty("supported-languages");
                String[] arr2 = new String[arr.length + 1];
                System.arraycopy(arr, 0, arr2, 0, arr.length);
                arr2[arr.length] = setLanguage;
                tc.getParser().setProperty("supported-languages", arr2);
                arr = (String[])tc.getConverter().getProperty("supported-languages");
                arr2 = new String[arr.length + 1];
                System.arraycopy(arr, 0, arr2, 0, arr.length);
                arr2[arr.length] = setLanguage;
                tc.getConverter().setProperty("supported-languages", arr2);
            }
        } catch (Exception e) {
            getLogger().error("TranscodingTransformer setup", e);
        }
        elements = new Stack();
        languages = new Stack();
        languages.push(parameters.getParameter("language", DEFAULT_LANG));
    }
    
    /** Clean up the TranscodingTransformer's members. */
    public void recycle() {
        language = null;
        tc = null;
        elements = null;
        languages = null;
    }
    
    /**
     * Handle the start of an element in the source document.
     */
    public void startElement(String uri, String name, String raw, org.xml.sax.Attributes attributes)
    throws SAXException {
        if (NAMESPACE.equals(uri) && name.equals(TC_NAME)) {
            language = attributes.getValue("lang");
            languages.push(attributes.getValue("lang"));
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
                getLogger().error("TranscodingTransformer characters", e);
            }
        }
        this.contentHandler.characters(strb.toString().toCharArray(), start, length);
    }
    
    private static String DEFAULT_LANG = "eng";
    private String language;
    private String attributeName = "lang";
    private TransCoder tc;
    private Stack elements;
    private Stack languages;
    /** The namespace of the <CODE>TranscodingTransformer</CODE> component. */    
    public static String NAMESPACE = "http://stoa.org/2002/transcoder";
    private static String TC_NAME = "transcode";
    
}

