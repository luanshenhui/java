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
	private JTextArea area; // 文本框
	private JButton pre; // 上一题按钮
	private JButton next; // 下一题按钮
	private JButton result; // 交卷按钮
	// private Control control; // 控制层
	private JLabel examInfo; // 考试信息标签
	private JLabel timer; // 记录考试时间标签
	private JLabel questionNum; // 题木标签

	public Dframe() {
		init();

	}

	private void init() {
		this.setTitle("雨琳科技考试系统");
		this.setSize(600, 400);
		this.setLocationRelativeTo(null);
		this.setResizable(false);
		this.add(createContentPane());
		this.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);// 设置关闭什么也不干
		addWindowListener(new WindowAdapter() {
			/* 关闭交卷 */
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
		p.add(examInfo = new JLabel("考生姓名：XXX", JLabel.CENTER),
				BorderLayout.NORTH);
		p.add(createQuestionPane(), BorderLayout.CENTER);
		return p;
	}

	private JScrollPane createQuestionPane() {
		JScrollPane p = new JScrollPane();
		p.setBorder(new TitledBorder("选择题"));// 添加一个带标题的边框
		area = new JTextArea(5, 5); // 初始大小为5行，5列
		area.setText("选啥？\nA\nB");
		area.setLineWrap(true); // 自动换行
		area.setEditable(false); // 不可编辑
		p.getViewport().add(area); // 置顶添加
		return p;
	}

	private JPanel createSouthPane() {
		JPanel p = new JPanel(new BorderLayout());
		p.setBorder(new EmptyBorder(10, 10, 10, 10));
		p.add(questionNum = new JLabel("第1题/共20题", JLabel.LEFT),
				BorderLayout.WEST);
		p.add(createButtonPanel(), BorderLayout.CENTER);
		p.add(timer = new JLabel("考试剩余时间:0秒", JLabel.RIGHT), BorderLayout.EAST);
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

		pre = new JButton("上一题");
		pre.setEnabled(false);

		next = new JButton("下一题");

		result = new JButton("交卷");

		result.setEnabled(false);// 默认为false//---

		p.add(pre);
		p.add(next);
		p.add(result);
		return p;
	}

	protected void getUserAnswer() {

		/**
		 * 获得用户在当前题的答案 将答案显示在页面中
		 */

	}

	protected void saveUserAnswer() {

		/**
		 * 获得用户答案 保存用户答案
		 */

		String userAnswer = "";
		if (optionA.isSelected()) { // 判断复选框A是否被选中
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
