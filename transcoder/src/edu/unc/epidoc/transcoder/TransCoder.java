/*
 * TransCoderjava
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.io.*;
import java.util.*;

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
    private Properties parsers;
    private Properties converters;
    private String[] ps;
    private String[] cv;
    
    /** Creates new Transliterator */
    public TransCoder() {
        init();
        try {
            setParser("edu.unc.epidoc.transcoder.BetaCodeParser");
            setConverter("edu.unc.epidoc.transcoder.BetaCodeConverter");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public TransCoder(String from, String to) throws Exception {
        init();
        /** Load the appropriate Parser class. */
        setParser(from);
        /** Load the appropriate Converter class */
        setConverter(to);
    }    
    
    private void init() {
        Class c = this.getClass();
        parsers = new Properties();
        converters = new Properties();
        try {
            parsers.load(c.getResourceAsStream("parsers.properties"));
            converters.load(c.getResourceAsStream("converters.properties"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public Parser getParser() {
        return p;
    }
    
    public void setParser(String from) throws Exception {
        /** Load the appropriate Parser class. */
        String className;
        if (parsers.containsKey(from))
            className = (String)parsers.get(from);
        else {
            if (from.indexOf('.') > 0) {
                className = from;
            } else {
                className = "edu.unc.epidoc.transcoder."+from+"Parser";
            }
        }
        try {
            Class c = Class.forName(className);
            p = (Parser)c.newInstance();
        } catch (Exception e) {
            throw e;
        }
    }
    
    public Converter getConverter() {
        return conv;
    }
    
    public void setConverter(String to) throws Exception {
        /** Load the appropriate Converter class */
        String className;
        if (converters.containsKey(to))
            className = (String)converters.get(to);
        else {
            if (to.indexOf('.') > 0) {
                className = to;
            } else {
                className = "edu.unc.epidoc.transcoder."+to+"Converter";
            }
        }
        try {
            Class c = Class.forName(className);
            conv = (Converter)c.newInstance();
        } catch (Exception e) {
            throw e;
        }
    }
    
    public void addParser(String name, String className) {
        try {
            if (!parsers.containsValue(className)) {
                parsers.put(name, className);
                parsers.store(new FileOutputStream(this.getClass().getResource("parsers.properties").getPath()), "Parsers");
                ps = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public String[] getParsers() {
        if (ps == null) {
            ps = new String[parsers.size()];
            Enumeration e = parsers.keys();
            for (int i = 0; i < ps.length; i++)
                ps[i] = (String)e.nextElement();
        }
        return ps;
    }
    
    public void addConverter(String name, String className) {
        try {
            if (!converters.containsValue(className)) {
                converters.put(name, className);
                converters.store(new FileOutputStream(this.getClass().getResource("converters.properties").getPath()), "Converters");
                cv = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public String[] getConverters() {
        if (cv == null) {
            cv = new String[converters.size()];
            Enumeration e = converters.keys();
            for (int i = 0; i < cv.length; i++)
                cv[i] = (String)e.nextElement();
        }
        return cv;
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
            char c = out.charAt(out.length()-1);
        }
        return out.toString();
    }
    
    /** Get the result as a String from an input File.  Should work with any type
     *  of encoding.
     */
    public String getString(File in) throws FileNotFoundException, IOException, UnsupportedEncodingException {
        InputStreamReader isw = new InputStreamReader(new FileInputStream(in), p.getEncoding());
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
            String temp = conv.convertToString(p.next());
//            System.out.println((int)temp.charAt(0));
            out.append(temp);
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
