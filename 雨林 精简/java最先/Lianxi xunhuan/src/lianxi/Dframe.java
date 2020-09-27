package lianxi;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.*;
import java.util.ArrayList;

import javax.swing.*;
import javax.swing.border.*;

public class Dframe extends JFrame {
	private static final long serialVersionUID = -1L;
	private JTextArea area; // �ı���
	private JButton pre; // ��һ�ⰴť
	private JButton next; // ��һ�ⰴť
	private JButton result; // ����ť
	// private Control control; // ���Ʋ�
	private JLabel examInfo; // ������Ϣ��ǩ
	private JLabel timer; // ��¼����ʱ���ǩ
	private JLabel questionNum; // ��ľ��ǩ

	public Dframe() {
		init();

	}

	private void init() {
		this.setTitle("���տƼ�����ϵͳ");
		this.setSize(600, 400);
		this.setLocationRelativeTo(null);
		this.setResizable(false);
		this.add(createContentPane());
		this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);// ���ùر�ʲôҲ����
		addWindowListener(new WindowAdapter() {
			/* �رս��� */
			@Override
			public void windowClosing(WindowEvent e) {

			}

		});
	}

	private JPanel createContentPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.add(new JLabel(new ImageIcon("src/com/yulin/am/exam_title.png"),
				JLabel.CENTER), BorderLayout.NORTH);
		p.add(createCenterPane(), BorderLayout.CENTER);
		p.add(createSouthPane(), BorderLayout.SOUTH);
		return p;
	}

	private JPanel createCenterPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.add(examInfo = new JLabel("����������XXX", JLabel.CENTER),
				BorderLayout.NORTH);
		p.add(createQuestionPane(), BorderLayout.CENTER);
		return p;
	}

	private JScrollPane createQuestionPane() {
		JScrollPane p = new JScrollPane();
		p.setBorder(new TitledBorder("ѡ����"));// ���һ��������ı߿�
		area = new JTextArea(5, 5); // ��ʼ��СΪ5�У�5��
		area.setText("ѡɶ��\nA\nB");
		area.setLineWrap(true); // �Զ�����
		area.setEditable(false); // ���ɱ༭
		p.getViewport().add(area); // �ö����
		return p;
	}

	private JPanel createSouthPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.setBorder(new EmptyBorder(10, 10, 10, 10));
		p.add(questionNum = new JLabel("��1��/��20��", JLabel.LEFT),
				BorderLayout.WEST);
		p.add(createButtonPanel(), BorderLayout.CENTER);
		p.add(timer = new JLabel("����ʣ��ʱ��:0��", JLabel.RIGHT), BorderLayout.EAST);
		p.add(createOptionsPane(), BorderLayout.NORTH);
		return p;
	}

	private JCheckBox optionA;
	private JCheckBox optionB;
	private JCheckBox optionC;
	private JCheckBox optionD;

	private JPanel createOptionsPane() {
		JPanel p = new JPanel();
		optionA = new JCheckBox("A");
		optionB = new JCheckBox("B");
		optionC = new JCheckBox("C");
		optionD = new JCheckBox("D");
		p.add(optionA);
		p.add(optionB);
		p.add(optionC);
		p.add(optionD);
		return p;
	}

	private JPanel createButtonPanel() {
		JPanel p = new JPanel();

		pre = new JButton("��һ��");
		pre.setEnabled(false);

		next = new JButton("��һ��");

		result = new JButton("����");

		result.setEnabled(false);// Ĭ��Ϊfalse//---

		p.add(pre);
		p.add(next);
		p.add(result);
		return p;
	}

	protected void getUserAnswer() {

		/**
		 * ����û��ڵ�ǰ��Ĵ� ������ʾ��ҳ����
		 */

	}

	protected void saveUserAnswer() {

		/**
		 * ����û��� �����û���
		 */

		String userAnswer = "";
		if (optionA.isSelected()) { // �жϸ�ѡ��A�Ƿ�ѡ��
			userAnswer += optionA.getText();
		}
		if (optionB.isSelected()) {
			userAnswer += optionB.getText();
		}
		if (optionC.isSelected()) {
			userAnswer += optionC.getText();
		}
		if (optionD.isSelected()) {
			userAnswer += optionD.getText();
		}

	}

	private void updateQuestion(int index) {

	}

	public void showExamFrame() {
		updateQuestion(0);
		setVisible(true);

	}

	public static void main(String[] args) {
		Dframe d = new Dframe();

		d.setVisible(true);
	}
}
