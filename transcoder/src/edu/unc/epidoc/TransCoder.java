/*
 * TransCoderjava
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc;

import java.io.*;

/**
 *
 * @author  Hugh A. Cayless <hcayless@email.unc.edu>
 * @version 0.3
 *
 * TransCoder is the main class of the program.  It can be  incorporated 
 * into any other Java program.  TransCoder expects the user to set the 
 * encoding type of any text that is being read and the desired output 
 * encoding.  If you are using one of the types that has been implemented 
 * in the edu.unc.epidoc package, then all you need to do is provide its name
 * within the package.  Otherwise, you will need to provide the fully-
 * qualified name of the parser or converter class you wish to use (and
 * make sure that class is in your Classpath).  
 * 
 */
public class TransCoder { 
    private Parser p;
    private Converter conv;
    private StringBuffer out = new StringBuffer();

    /** Creates new Transliterator */
    public TransCoder() {
    }
    
    public TransCoder(String from, String to) throws Exception {
        /** Load the appropriate Parser class. */
        setSourceEncoding(from);
        /** Load the appropriate Converter class */
        setResultEncoding(to);
    }

    public void setSourceEncoding(String from) throws Exception {
        /** Load the appropriate Parser class. */
        String className;
        if (from.indexOf(46) > 0) {
            className = from;
        } else {
            className = "edu.unc.epidoc."+from+"Parser";
        }
        try {
            Class c = Class.forName(className);
            p = (Parser)c.newInstance();     
        } catch (Exception e) {
            throw e;
        }
    }
    
    public void setResultEncoding(String to) throws Exception {
        /** Load the appropriate Converter class */
        String className;
        if (to.indexOf(46) > 0) {
            className = to;
        } else {
            className = "edu.unc.epidoc."+to+"Converter";
        }
        try {
            Class c = Class.forName(className);
            conv = (Converter)c.newInstance();             
        } catch (Exception e) {
            throw e;
        }
    }
    
    /** Get the result String from the input String.  Note: this method will
     *  not produce satisfactory results unless the encoding of the input
     *  has been read in properly.
     */
    public String getString(String in) throws UnsupportedEncodingException {
        out.delete(0,out.length());
        p.setString(in);
        while (p.hasNext()) {
            out.append(conv.convertToString(p.next()));
        }
        return out.toString();
    }
    
    /** Get the result as a String from an input File.  Should work with any type
     *  of encoding.
     */
    public String getString(File in) throws FileNotFoundException, IOException, UnsupportedEncodingException {
        InputStreamReader isw = new InputStreamReader(new FileInputStream(in), p.getParameter("ENCODING"));
        StringBuffer strb = new StringBuffer();
        int chr = isw.read();
        while (chr > 0) {
            strb.append((char)chr);
            chr = isw.read();
        }
        isw.close();
        out.delete(0,out.length());
        p.setString(strb.toString());
        while (p.hasNext()) {
            out.append(conv.convertToString(p.next()));
        }
        return out.toString();
    }
    
    public String getCharacterEntities(String in) throws UnsupportedEncodingException {
        out.delete(0,out.length());
        p.setString(in);
        while (p.hasNext()) {
            out.append(conv.convertToCharacterEntity(p.next()));
        }
        return out.toString();
    }
    
}
