package com.mir3.licensetool;

import com.mir3.util.LicenseFileProperty;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.filechooser.FileNameExtensionFilter;

public class Main extends JFrame {

    public Main() {
        super("License Viewer (MIR3 USE ONLY)");
        setSize(640, 480);
        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
        Box hbox = Box.createHorizontalBox();
        fileField = new JTextField(40);
        licenseArea = new JTextArea(10, 40);
        licenseArea.setEditable(false);
        licenseArea.setText("\n\nNo License Loaded");
        licenseArea.setEditable(false);
        JLabel label = new JLabel("License File:");
        label.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 15));
        hbox.add(label);
        hbox.add(fileField);
        JButton browseButton = new JButton("Browse...");
        browseButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                JFileChooser chooser = new JFileChooser();
                chooser.setFileFilter(new FileNameExtensionFilter("License Files", "license"));
                int ret = chooser.showOpenDialog(Main.this);
                if(ret == JFileChooser.APPROVE_OPTION) {
                    fileField.setText( chooser.getSelectedFile().getPath() );
                }
            }
        });
        hbox.add(browseButton);
        JButton loadButton = new JButton("Load");
        loadButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                try {
                    LicenseFileProperty license = new LicenseFileProperty(fileField.getText());
                    String contents = new String(license.getDecryptedContents(), "UTF-8");
                    licenseArea.setText(contents);
                }
                catch(Exception ex) {
                    licenseArea.setText("ERROR LOADING LICENSE:\n----------------------\n" + ex);
                }
            }
        });
        hbox.add(loadButton);
        add(hbox, BorderLayout.NORTH);
        JScrollPane scrollPane = new JScrollPane(licenseArea, JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_AS_NEEDED);
        add(scrollPane, BorderLayout.CENTER);
    }

    public static void main(String[] args) throws Exception {
        Main frame = new Main();
        frame.setVisible(true);
    }

    private JTextField fileField;
    private JTextArea licenseArea;
}
