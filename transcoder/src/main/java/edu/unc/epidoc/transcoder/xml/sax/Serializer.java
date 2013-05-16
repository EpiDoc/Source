/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package edu.unc.epidoc.transcoder.xml.sax;

import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

import org.xml.sax.Attributes;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.ext.LexicalHandler;
import org.xml.sax.ext.Locator2;
import org.xml.sax.helpers.DefaultHandler;

/**
 * A sample SAX2 writer. This sample program illustrates how to
 * register a SAX2 ContentHandler and receive the callbacks in
 * order to print a document that is parsed.
 *
 * @author Andy Clark, IBM
 *
 * @version $Id$
 */
public class Serializer
    extends DefaultHandler
    implements LexicalHandler {

    //
    // Constants
    //

    // feature ids

    /** Namespaces feature id (http://xml.org/sax/features/namespaces). */
    protected static final String NAMESPACES_FEATURE_ID = "http://xml.org/sax/features/namespaces";

    /** Namespace prefixes feature id (http://xml.org/sax/features/namespace-prefixes). */
    protected static final String NAMESPACE_PREFIXES_FEATURE_ID = "http://xml.org/sax/features/namespace-prefixes";

    /** Validation feature id (http://xml.org/sax/features/validation). */
    protected static final String VALIDATION_FEATURE_ID = "http://xml.org/sax/features/validation";

    /** Schema validation feature id (http://apache.org/xml/features/validation/schema). */
    protected static final String SCHEMA_VALIDATION_FEATURE_ID = "http://apache.org/xml/features/validation/schema";

    /** Schema full checking feature id (http://apache.org/xml/features/validation/schema-full-checking). */
    protected static final String SCHEMA_FULL_CHECKING_FEATURE_ID = "http://apache.org/xml/features/validation/schema-full-checking";

    /** Honour all schema locations feature id (http://apache.org/xml/features/honour-all-schemaLocations). */
    protected static final String HONOUR_ALL_SCHEMA_LOCATIONS_ID = "http://apache.org/xml/features/honour-all-schemaLocations";

    /** Validate schema annotations feature id (http://apache.org/xml/features/validate-annotations) */
    protected static final String VALIDATE_ANNOTATIONS_ID = "http://apache.org/xml/features/validate-annotations";

    /** Generate synthetic schema annotations feature id (http://apache.org/xml/features/generate-synthetic-annotations). */
    protected static final String GENERATE_SYNTHETIC_ANNOTATIONS_ID = "http://apache.org/xml/features/generate-synthetic-annotations";

    /** Dynamic validation feature id (http://apache.org/xml/features/validation/dynamic). */
    protected static final String DYNAMIC_VALIDATION_FEATURE_ID = "http://apache.org/xml/features/validation/dynamic";

    /** Load external DTD feature id (http://apache.org/xml/features/nonvalidating/load-external-dtd). */
    protected static final String LOAD_EXTERNAL_DTD_FEATURE_ID = "http://apache.org/xml/features/nonvalidating/load-external-dtd";

    /** XInclude feature id (http://apache.org/xml/features/xinclude). */
    protected static final String XINCLUDE_FEATURE_ID = "http://apache.org/xml/features/xinclude";

    /** XInclude fixup base URIs feature id (http://apache.org/xml/features/xinclude/fixup-base-uris). */
    protected static final String XINCLUDE_FIXUP_BASE_URIS_FEATURE_ID = "http://apache.org/xml/features/xinclude/fixup-base-uris";

    /** XInclude fixup language feature id (http://apache.org/xml/features/xinclude/fixup-language). */
    protected static final String XINCLUDE_FIXUP_LANGUAGE_FEATURE_ID = "http://apache.org/xml/features/xinclude/fixup-language";

    // property ids

    /** Lexical handler property id (http://xml.org/sax/properties/lexical-handler). */
    protected static final String LEXICAL_HANDLER_PROPERTY_ID = "http://xml.org/sax/properties/lexical-handler";

    // default settings

    /** Default parser name. */
    protected static final String DEFAULT_PARSER_NAME = "org.apache.xerces.parsers.SAXParser";

    /** Default namespaces support (true). */
    protected static final boolean DEFAULT_NAMESPACES = true;

    /** Default namespace prefixes (false). */
    protected static final boolean DEFAULT_NAMESPACE_PREFIXES = false;

    /** Default validation support (false). */
    protected static final boolean DEFAULT_VALIDATION = false;

    /** Default load external DTD (true). */
    protected static final boolean DEFAULT_LOAD_EXTERNAL_DTD = true;

    /** Default Schema validation support (false). */
    protected static final boolean DEFAULT_SCHEMA_VALIDATION = false;

    /** Default Schema full checking support (false). */
    protected static final boolean DEFAULT_SCHEMA_FULL_CHECKING = false;

    /** Default honour all schema locations (false). */
    protected static final boolean DEFAULT_HONOUR_ALL_SCHEMA_LOCATIONS = false;

    /** Default validate schema annotations (false). */
    protected static final boolean DEFAULT_VALIDATE_ANNOTATIONS = false;

    /** Default generate synthetic schema annotations (false). */
    protected static final boolean DEFAULT_GENERATE_SYNTHETIC_ANNOTATIONS = false;

    /** Default dynamic validation support (false). */
    protected static final boolean DEFAULT_DYNAMIC_VALIDATION = false;

    /** Default XInclude processing support (false). */
    protected static final boolean DEFAULT_XINCLUDE = false;

    /** Default XInclude fixup base URIs support (true). */
    protected static final boolean DEFAULT_XINCLUDE_FIXUP_BASE_URIS = true;

    /** Default XInclude fixup language support (true). */
    protected static final boolean DEFAULT_XINCLUDE_FIXUP_LANGUAGE = true;

    /** Default canonical output (false). */
    protected static final boolean DEFAULT_CANONICAL = false;

    //
    // Data
    //

    /** Print writer. */
    protected PrintWriter fOut;

    /** Canonical output. */
    protected boolean fCanonical;

    /** Element depth. */
    protected int fElementDepth;

    /** Document locator. */
    protected Locator fLocator;

    /** Processing XML 1.1 document. */
    protected boolean fXML11;

    /** In CDATA section. */
    protected boolean fInCDATA;

    protected StringBuffer dtd = new StringBuffer();

    protected boolean milestone = false;

    protected boolean fStandalone = false;
    //
    // Constructors
    //

    /** Default constructor. */
    public Serializer() {
    } // <init>()

    //
    // Public methods
    //

    /** Sets whether output is canonical. */
    public void setCanonical(boolean canonical) {
        fCanonical = canonical;
    } // setCanonical(boolean)

    /** Sets the output stream for printing. */
    public void setOutput(OutputStream stream, String encoding)
        throws UnsupportedEncodingException {

        if (encoding == null) {
            encoding = "UTF8";
        }

        java.io.Writer writer = new OutputStreamWriter(stream, encoding);
        fOut = new PrintWriter(writer);

    } // setOutput(OutputStream,String)

    /** Sets the output writer. */
    public void setOutput(java.io.Writer writer) {

        fOut = writer instanceof PrintWriter
             ? (PrintWriter)writer : new PrintWriter(writer);

    } // setOutput(java.io.Writer)

    /** Sets whether output is standalone. */
    public void setStandalone(boolean standalone) {
        fStandalone = standalone;
    } // setStandalone(boolean)

    //
    // ContentHandler methods
    //

    /** Set Document Locator. */
    @Override
    public void setDocumentLocator(Locator locator) {
    	fLocator = locator;
    } // setDocumentLocator(Locator)

    /** Start document. */
    @Override
    public void startDocument() throws SAXException {

        fElementDepth = 0;
        fXML11 = false;
        fInCDATA = false;

    } // startDocument()

    /** Processing instruction. */
    @Override
    public void processingInstruction(String target, String data)
        throws SAXException {

        if (fElementDepth > 0) {
            fOut.print("<?");
            fOut.print(target);
            if (data != null && data.length() > 0) {
                fOut.print(' ');
                fOut.print(data);
            }
            fOut.print("?>");
            fOut.flush();
        }

    } // processingInstruction(String,String)

    /** Start element. */
    @Override
    public void startElement(String uri, String local, String raw,
                             Attributes attrs) throws SAXException {
        if (milestone) {
            closeElement();
        }
        // Root Element
        if (fElementDepth == 0) {
            String encoding = "UTF-8";
            if (fLocator != null) {
                if (fLocator instanceof Locator2) {
                    Locator2 locator2 = (Locator2) fLocator;
                    fXML11 = "1.1".equals(locator2.getXMLVersion());
                    encoding = locator2.getEncoding();
                    if (encoding == null) {
                        encoding = "UTF-8";
                    }
                }
                fLocator = null;
            }

            // The XML declaration cannot be printed in startDocument because
            // the version and encoding information reported by the Locator
            // cannot be relied on until the next event after startDocument.
            if (!fCanonical) {
                fOut.print("<?xml version=\"");
                fOut.print(fXML11 ? "1.1" : "1.0");
                fOut.print("\" encoding=\"");
                fOut.print(encoding);

                if (fStandalone) {
                    fOut.print("\" standalone=\"yes");
                }

                fOut.println("\"?>");
                fOut.print(dtd);
                fOut.flush();
            }

        }

        fElementDepth++;
        fOut.print('<');
        fOut.print(raw);
        if (attrs != null) {
            attrs = sortAttributes(attrs);
            int len = attrs.getLength();
            for (int i = 0; i < len; i++) {
                fOut.print(' ');
                fOut.print(attrs.getQName(i));
                fOut.print("=\"");
                normalizeAndPrint(attrs.getValue(i), true);
                fOut.print('"');
            }
        }
        if (!fCanonical) {
            milestone = true;
        } else {
            fOut.print(">");
        }
        fOut.flush();

    } // startElement(String,String,String,Attributes)

    /** Characters. */
    @Override
    public void characters(char ch[], int start, int length)
        throws SAXException {
        if (!fCanonical) {
            closeElement();
        }
        if (!fInCDATA) {
            normalizeAndPrint(ch, start, length, false);
        }
        else {
            for (int i = 0; i < length; ++i) {
            	fOut.print(ch[start+i]);
            }
        }
        fOut.flush();

    } // characters(char[],int,int);

    /** Ignorable whitespace. */
    @Override
    public void ignorableWhitespace(char ch[], int start, int length)
        throws SAXException {

        characters(ch, start, length);
        fOut.flush();

    } // ignorableWhitespace(char[],int,int);

    /** End element. */
    @Override
    public void endElement(String uri, String local, String raw)
        throws SAXException {

        fElementDepth--;
        if (milestone) {
            milestone = false;
            fOut.print("/>");
        } else {
            fOut.print("</");
            fOut.print(raw);
            fOut.print('>');
        }
        fOut.flush();

    } // endElement(String)

    //
    // ErrorHandler methods
    //

    /** Warning. */
    @Override
    public void warning(SAXParseException ex) throws SAXException {
        printError("Warning", ex);
    } // warning(SAXParseException)

    /** Error. */
    @Override
    public void error(SAXParseException ex) throws SAXException {
        printError("Error", ex);
    } // error(SAXParseException)

    /** Fatal error. */
    @Override
    public void fatalError(SAXParseException ex) throws SAXException {
        printError("Fatal Error", ex);
        throw ex;
    } // fatalError(SAXParseException)

    //
    // LexicalHandler methods
    //

    /** Start DTD. */
    public void startDTD(String name, String publicId, String systemId)
        throws SAXException {

        dtd.append("<!DOCTYPE "+name);
        if (publicId != null && !"".equals(publicId)) {
            dtd.append(" PUBLIC \""+publicId+"\"");
        }
        if (systemId != null && !"".equals(systemId)) {
            dtd.append(" SYSTEM \""+systemId+"\"");
        }

    } // startDTD(String,String,String)

    /** End DTD. */
    public void endDTD() throws SAXException {
        dtd.append(">\n");
    } // endDTD()

    /** Start entity. */
    public void startEntity(String name) throws SAXException {
    } // startEntity(String)

    /** End entity. */
    public void endEntity(String name) throws SAXException {
    } // endEntity(String)

    /** Start CDATA section. */
    public void startCDATA() throws SAXException {
        if (!fCanonical) {
            closeElement();
            fOut.print("<![CDATA[");
            fInCDATA = true;
        }
    } // startCDATA()

    /** End CDATA section. */
    public void endCDATA() throws SAXException {
        if (!fCanonical) {
            fInCDATA = false;
            fOut.print("]]>");
        }
    } // endCDATA()

    /** Comment. */
    public void comment(char ch[], int start, int length) throws SAXException {
        if (!fCanonical && fElementDepth > 0) {
            closeElement();
            fOut.print("<!--");
            for (int i = 0; i < length; ++i) {
                fOut.print(ch[start+i]);
            }
            fOut.print("-->");
            fOut.flush();
        }
    } // comment(char[],int,int)

    //
    // Protected methods
    //

    /** Returns a sorted list of attributes. */
    protected Attributes sortAttributes(Attributes attrs) {

        AttributesImpl attributes = new AttributesImpl();

        int len = (attrs != null) ? attrs.getLength() : 0;
        for (int i = 0; i < len; i++) {
            String name = attrs.getQName(i);
            int count = attributes.getLength();
            int j = 0;
            while (j < count) {
                if (name.compareTo(attributes.getQName(j)) < 0) {
                    break;
                }
                j++;
            }
            attributes.insertAttributeAt(j, name, attrs.getType(i),
                                         attrs.getValue(i));
        }

        return attributes;

    } // sortAttributes(AttributeList):AttributeList

    /** Normalizes and prints the given string. */
    protected void normalizeAndPrint(String s, boolean isAttValue) {

        int len = (s != null) ? s.length() : 0;
        for (int i = 0; i < len; i++) {
            char c = s.charAt(i);
            normalizeAndPrint(c, isAttValue);
        }

    } // normalizeAndPrint(String,boolean)

    /** Normalizes and prints the given array of characters. */
    protected void normalizeAndPrint(char[] ch, int offset, int length, boolean isAttValue) {
        for (int i = 0; i < length; i++) {
            normalizeAndPrint(ch[offset + i], isAttValue);
        }
    } // normalizeAndPrint(char[],int,int,boolean)

    /** Normalizes and print the given character. */
    protected void normalizeAndPrint(char c, boolean isAttValue) {

        switch (c) {
            case '<': {
                fOut.print("&lt;");
                break;
            }
            case '>': {
                fOut.print("&gt;");
                break;
            }
            case '&': {
                fOut.print("&amp;");
                break;
            }
            case '"': {
                // A '"' that appears in character data
                // does not need to be escaped.
                if (isAttValue) {
                    fOut.print("&quot;");
                }
                else {
                    fOut.print("\"");
                }
                break;
            }
            case '\r': {
            	// If CR is part of the document's content, it
            	// must not be printed as a literal otherwise
            	// it would be normalized to LF when the document
            	// is reparsed.
            	fOut.print("&#xD;");
            	break;
            }
            case '\n': {
                if (fCanonical) {
                    fOut.print("&#xA;");
                    break;
                }
                // else, default print char
            }
            default: {
                // In XML 1.1, control chars in the ranges [#x1-#x1F, #x7F-#x9F] must be escaped.
            	//
            	// Escape space characters that would be normalized to #x20 in attribute values
            	// when the document is reparsed.
            	//
            	// Escape NEL (0x85) and LSEP (0x2028) that appear in content
            	// if the document is XML 1.1, since they would be normalized to LF
            	// when the document is reparsed.
            	if (fXML11 && ((c >= 0x01 && c <= 0x1F && c != 0x09 && c != 0x0A)
            	    || (c >= 0x7F && c <= 0x9F) || c == 0x2028)
            	    || isAttValue && (c == 0x09 || c == 0x0A)) {
            	    fOut.print("&#x");
            	    fOut.print(Integer.toHexString(c).toUpperCase());
            	    fOut.print(";");
                }
                else {
                    fOut.print(c);
                }
            }
        }
    } // normalizeAndPrint(char,boolean)

    /** Prints the error message. */
    protected void printError(String type, SAXParseException ex) {

        System.err.print("[");
        System.err.print(type);
        System.err.print("] ");
        String systemId = ex.getSystemId();
        if (systemId != null) {
            int index = systemId.lastIndexOf('/');
            if (index != -1)
                systemId = systemId.substring(index + 1);
            System.err.print(systemId);
        }
        System.err.print(':');
        System.err.print(ex.getLineNumber());
        System.err.print(':');
        System.err.print(ex.getColumnNumber());
        System.err.print(": ");
        System.err.print(ex.getMessage());
        System.err.println();
        System.err.flush();

    } // printError(String,SAXParseException)

    protected void closeElement() {
        if (milestone) {
            milestone = false;
            fOut.print(">");
        }
    }


    private class AttributesImpl implements Attributes {
        //
    // Data
    //

    /** Head node. */
    private ListNode head;

    /** Tail node. */
    private ListNode tail;

    /** Length. */
    private int length;

    //
    // Attributes methods
    //

    /** Returns the number of attributes. */
    public int getLength() {
        return length;
    }

    /** Returns the index of the specified attribute. */
    public int getIndex(String raw) {
        ListNode place = head;
        int index = 0;
        while (place != null) {
            if (place.raw.equals(raw)) {
                return index;
            }
            index++;
            place = place.next;
        }
        return -1;
    }

    /** Returns the index of the specified attribute. */
    public int getIndex(String uri, String local) {
        ListNode place = head;
        int index = 0;
        while (place != null) {
            if (place.uri.equals(uri) && place.local.equals(local)) {
                return index;
            }
            index++;
            place = place.next;
        }
        return -1;
    }

    /** Returns the attribute URI by index. */
    public String getURI(int index) {

        ListNode node = getListNodeAt(index);
        return node != null ? node.uri : null;

    } // getURI(int):String

    /** Returns the attribute local name by index. */
    public String getLocalName(int index) {

        ListNode node = getListNodeAt(index);
        return node != null ? node.local : null;

    } // getLocalName(int):String

    /** Returns the attribute raw name by index. */
    public String getQName(int index) {

        ListNode node = getListNodeAt(index);
        return node != null ? node.raw : null;

    } // getQName(int):String

    /** Returns the attribute type by index. */
    public String getType(int index) {

        ListNode node = getListNodeAt(index);
        return (node != null) ? node.type : null;

    } // getType(int):String

    /** Returns the attribute type by uri and local. */
    public String getType(String uri, String local) {

        ListNode node = getListNode(uri, local);
        return (node != null) ? node.type : null;

    } // getType(String,String):String

    /** Returns the attribute type by raw name. */
    public String getType(String raw) {

        ListNode node = getListNode(raw);
        return (node != null) ? node.type : null;

    } // getType(String):String

    /** Returns the attribute value by index. */
    public String getValue(int index) {

        ListNode node = getListNodeAt(index);
        return (node != null) ? node.value : null;

    } // getType(int):String

    /** Returns the attribute value by uri and local. */
    public String getValue(String uri, String local) {

        ListNode node = getListNode(uri, local);
        return (node != null) ? node.value : null;

    } // getType(String):String

    /** Returns the attribute value by raw name. */
    public String getValue(String raw) {

        ListNode node = getListNode(raw);
        return (node != null) ? node.value : null;

    } // getType(String):String

    //
    // Public methods
    //

    /** Adds an attribute. */
    public void addAttribute(String raw, String type, String value) {
        addAttribute(null, null, raw, type, value);
    }

    /** Adds an attribute. */
    public void addAttribute(String uri, String local, String raw,
                             String type, String value) {

        ListNode node = new ListNode(uri, local, raw, type, value);
        if (length == 0) {
            head = node;
        }
        else {
            tail.next = node;
        }
        tail = node;
        length++;

    } // addAttribute(String,StringString,String,String)

    /** Inserts an attribute. */
    public void insertAttributeAt(int index,
                                  String raw, String type, String value) {
        insertAttributeAt(index, null, null, raw, type, value);
    }

    /** Inserts an attribute. */
    public void insertAttributeAt(int index,
                                  String uri, String local, String raw,
                                  String type, String value) {

        // if list is empty, add attribute
        if (length == 0 || index >= length) {
            addAttribute(uri, local, raw, type, value);
            return;
        }

        // insert at beginning of list
        ListNode node = new ListNode(uri, local, raw, type, value);
        if (index < 1) {
            node.next = head;
            head = node;
        }
        else {
            ListNode prev = getListNodeAt(index - 1);
            node.next = prev.next;
            prev.next = node;
        }
        length++;

    } // insertAttributeAt(int,String,String,String,String,String)

    /** Removes an attribute. */
    public void removeAttributeAt(int index) {

        if (length == 0) {
            return;
        }

        if (index == 0) {
            head = head.next;
            if (head == null) {
                tail = null;
            }
            length--;
        }
        else {
            ListNode prev = getListNodeAt(index - 1);
            ListNode node = getListNodeAt(index);
            if (node != null) {
                prev.next = node.next;
                if (node == tail) {
                    tail = prev;
                }
                length--;
            }
        }

    } // removeAttributeAt(int)

    /** Removes the specified attribute. */
    public void removeAttribute(String raw) {
        removeAttributeAt(getIndex(raw));
    }

    /** Removes the specified attribute. */
    public void removeAttribute(String uri, String local) {
        removeAttributeAt(getIndex(uri, local));
    }

    //
    // Private methods
    //

    /** Returns the node at the specified index. */
    private ListNode getListNodeAt(int i) {

        for (ListNode place = head; place != null; place = place.next) {
            if (--i == -1) {
                return place;
            }
        }

        return null;

    } // getListNodeAt(int):ListNode

    /** Returns the first node with the specified uri and local. */
    public ListNode getListNode(String uri, String local) {

        if (uri != null && local != null) {
            ListNode place = head;
            while (place != null) {
                if (place.uri != null && place.local != null &&
                    place.uri.equals(uri) && place.local.equals(local)) {
                    return place;
                }
                place = place.next;
            }
        }
        return null;

    } // getListNode(String,String):ListNode

    /** Returns the first node with the specified raw name. */
    private ListNode getListNode(String raw) {

        if (raw != null) {
            for (ListNode place = head; place != null; place = place.next) {
                if (place.raw != null && place.raw.equals(raw)) {
                    return place;
                }
            }
        }

        return null;

    } // getListNode(String):ListNode

    //
    // Object methods
    //

    /** Returns a string representation of this object. */
        @Override
    public String toString() {
        StringBuffer str = new StringBuffer();

        str.append('[');
        str.append("len=");
        str.append(length);
        str.append(", {");
        for (ListNode place = head; place != null; place = place.next) {
            str.append(place.toString());
            if (place.next != null) {
                str.append(", ");
            }
        }
        str.append("}]");

        return str.toString();

    } // toString():String

    //
    // Classes
    //



} // class AttributesImpl

    /**
     * An attribute node.
     */
    static class ListNode {

        //
        // Data
        //

        /** Attribute uri. */
        public String uri;

        /** Attribute local. */
        public String local;

        /** Attribute raw. */
        public String raw;

        /** Attribute type. */
        public String type;

        /** Attribute value. */
        public String value;

        /** Next node. */
        public ListNode next;

        //
        // Constructors
        //

        /** Constructs a list node. */
        public ListNode(String uri, String local, String raw,
                        String type, String value) {

            this.uri   = uri;
            this.local = local;
            this.raw   = raw;
            this.type  = type;
            this.value = value;

        } // <init>(String,String,String,String,String)

        //
        // Object methods
        //

        /** Returns string representation of this object. */
        @Override
        public String toString() {
            return raw != null ? raw : local;
        }

    } // class ListNode

} // class Writer
