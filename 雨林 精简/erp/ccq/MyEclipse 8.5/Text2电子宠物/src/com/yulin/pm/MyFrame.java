package com.yulin.pm;

import java.awt.*;
import java.awt.event.*;

public class MyFrame extends Frame {
	public MyFrame() {
		setSize(1000, 800);
		setBackground(Color.green);
		setAlwaysOnTop(true);
		addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				System.exit(0);
			}
		});
	}

}
