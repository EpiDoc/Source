/*
 * TransCoderView.java - The user interface class for the TransCoder
 * jEdit plugin.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

package edu.unc.epidoc.transcoder.jEdit;

import edu.unc.epidoc.transcoder.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.EmptyBorder;

import org.gjt.sp.jedit.*;

/**
*	The class is designed for use with jEdit.  It is the user interface
*   class for the TransCoder plugin.
*
*   @author  Michael Jones
*/
public class TransCoderView extends JFrame {
	protected static String GREEK = "Enter the Greek you want to transform and press the \n" +
									"\"Transform Text Below\" button.  To transform the \n" +
									"current buffer, press the \"Transform Buffer\" button." ;
	private static String[] sourceEncodings = {"BetaCode", "SPIonic", "SGreek", "GreekKeys", "Unicode"};
	private static String[] destinationEncodings = {"BetaCode", "SPIonic", "SGreek", "GreekXLit", "UnicodeC", "UnicodeD"};

	protected JComboBox sourceList;
	protected JComboBox destinationList;
	protected JTextArea greekText;

	private JLabel viewTitle;
	private JLabel sourcePrompt;
	private JLabel destinationPrompt;
	private JButton transformTextButton;
	private JButton transformBufferButton;

	private TransCoderControl myController;

	//Constructors
	public TransCoderView(TransCoderControl controller) {
		super("TransCoder");
		myController = controller;
		init();
	}

	/**
	 * Initialize the TransCoder window GUI.
	 */
	private void init() {
		JPanel p = new JPanel();
		p.setLayout(new BorderLayout());
		p.setBorder(new EmptyBorder(5,5,5,5));

		viewTitle = new JLabel("TransCoder", SwingConstants.CENTER);
		sourcePrompt = new JLabel("Source Encoding: ", SwingConstants.RIGHT);
		destinationPrompt = new JLabel("Destination Encoding: ", SwingConstants.RIGHT);

		sourceList = new JComboBox(sourceEncodings);
		destinationList = new JComboBox(destinationEncodings);

		p.add(viewTitle, BorderLayout.NORTH);
		p.add(transCoderPanel(), BorderLayout.CENTER);
		p.add(buttonPanel(), BorderLayout.SOUTH);
		JPanel mainPanel = new JPanel();
		mainPanel.setLayout(new BorderLayout());
		mainPanel.add(p, BorderLayout.NORTH);
		greekText = new JTextArea(GREEK, 10, 15);
		mainPanel.add(new JScrollPane(greekText), BorderLayout.CENTER);
		setContentPane(mainPanel);
	}

	/**
	 * Build the main section of the TransCoder window.
	 * @return transCoderPanel A JPanel containing the main section of the TransCoder window.
	 */
	private JPanel transCoderPanel() {
		GridBagLayout gb = new GridBagLayout();
		JPanel transCoderPanel = new JPanel(gb);
		transCoderPanel.setBorder(new EmptyBorder(5,5,5,5));
		GridBagConstraints gbc = new GridBagConstraints();
		gbc.gridx = 0;
		gbc.gridy = 0;
		gbc.fill = GridBagConstraints.NONE;
		gbc.insets = new Insets(10,10,10,10);
		gbc.anchor = GridBagConstraints.EAST;
		gb.setConstraints(sourcePrompt,gbc);
		transCoderPanel.add(sourcePrompt);
		gbc.gridy = 1;
		gb.setConstraints(destinationPrompt, gbc);
		transCoderPanel.add(destinationPrompt);
		gbc.gridx = 1;
		gbc.gridy = 0;
		gbc.fill = GridBagConstraints.HORIZONTAL;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		gb.setConstraints(sourceList,gbc);
		transCoderPanel.add(sourceList);
		sourceList.addItemListener(myController);
		gbc.gridy=1;
		gbc.fill = GridBagConstraints.HORIZONTAL;
		gbc.anchor = GridBagConstraints.CENTER;
		gbc.weightx = 1;
		gb.setConstraints(destinationList,gbc);
		transCoderPanel.add(destinationList);
		destinationList.addItemListener(myController);

		return transCoderPanel;
	}

	/**
	 * Create the button panel for the TransCoder GUI.
	 * @return buttonPanel A JPanel containing buttons for the TransCoder GUI.
	 */
	private JPanel buttonPanel() {
		transformTextButton = new JButton("Transform Text Below");
		transformTextButton.setActionCommand("Text");
		transformBufferButton = new JButton("Transform Buffer");
		transformBufferButton.setActionCommand("Buffer");
		JPanel buttonPanel = new JPanel();
		buttonPanel.setBorder(new EmptyBorder(5,5,5,5));
		JPanel p1 = new JPanel(new GridLayout(1,4,30,5));
		p1.add(transformTextButton);
		transformTextButton.addActionListener(myController);
		p1.add(transformBufferButton);
		transformBufferButton.addActionListener(myController);
		buttonPanel.add(p1);
 
		return buttonPanel;
	}
}