/*
 * TransCoderPlugin.java - Plugin for TransCoder
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
*/

package edu.unc.epidoc.transcoder.jEdit;
import edu.unc.epidoc.transcoder.*;
import java.util.*;

import org.gjt.sp.jedit.*;
import org.gjt.sp.jedit.gui.OptionsDialog;

/**
*	The class is designed for use with jEdit for converting Greek from
*   one encoding to another.  The user enters the Greek in the text box
*   and chooses the source and destination encoding.  The user can choose
*   between transforming the current buffer or his own Greek.  The plugin
*   takes the Greek and performs the transformation.
*
*   @author  Michael Jones
*/

public class TransCoderPlugin extends EBPlugin {
	private static TransCoderControl tcControl = null;

	/**
	 * Initializes the TransCoderAction and registers it with jEdit.
	 */
	public void start() {
	}

	/**
	 * Create the "TransCoder" menu item.
	 * @param menuItems Used to add menu items
	 */
	public void createMenuItems(Vector menuItems) {
		menuItems.addElement(GUIUtilities.loadMenuItem("transcoder.display-dialog"));
	}

	/**
	 * Called when the user selects "TransCoder" from the "Plugins" menu.
	 * Create the TransCoder controller, if necessary, and display the GUI.
	 * @param jeditView The jEdit view from which the menu selection was made.
	 */
	public static void displayDialog(View jeditView) {
		// If the TransCoder controller is not yet created, then create it
		if (tcControl == null) { 
			tcControl = new TransCoderControl();
			tcControl.setJeditView(jeditView);
		}
		// Display the GUI
		tcControl.displayView();
	}
}