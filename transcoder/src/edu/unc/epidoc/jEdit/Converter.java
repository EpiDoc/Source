/*
 * Converter.java
 *
 * (c) Hugh A. Cayless <hcayless@email.unc.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details. */

/**
 *
 * @author  Hugh A. Cayless
 * @version
 *
 * A Converter's function is to take a character or the name
 * of a character as input and return that character in the
 * desired encoding. If the result encoding does not contain
 * the named character, then the converter will return the
 * character it is passed.
 */
public interface Converter {

    public String convertToString(String in);

    public String convertToCharacterEntity(String in);

    public void setProperty(String name, Object value);

    public Object getProperty(String name);

    public String getEncoding();

    public boolean supportsLanguage(String lang);

}
