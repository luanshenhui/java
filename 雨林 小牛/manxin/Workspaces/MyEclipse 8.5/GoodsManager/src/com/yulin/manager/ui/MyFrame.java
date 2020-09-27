package com.yulin.manager.ui;

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import com.yulin.manager.bean.Goods;
import com.yulin.manager.control.Control;

public class MyFrame extends JFrame {
	/**
	 * ��ҳ��ѯ�� ���ַ�ҳ���ԣ� һ�����ڲ�ѯ�ķ�ҳ ÿһҳ��Ҫ��ʾ����Ϣ����Ҫ��ѯһ�����ݿ⣬����SQL����������ɷ�ҳ
	 * �����ݿ�ͷ�������ѹ���Ƚϴ󣬵��ǶԻ���/�ڴ��ѹ���Ƚ�С
	 * 
	 * �������ڻ���ķ�ҳ һ���Բ�ѯ�����е����ݣ����뻺��/�ڴ��� ��һ�����бȽ����������ݿ�ͷ�������ѹ���Ƚ�С �Ի���/�ڴ��ѹ���Ƚϴ�
	 */

	private Control control;
	private int page = 1;// ��ǰ��ҳ��
	JPanel gridPanel = new JPanel(new GridLayout(6, 6));;
	JLabel pages = new JLabel("��1ҳ");

	public MyFrame(Control control) {
		this.control = control;
		control.setMf(this);
		init();
	}

	private void init() {
		setSize(500, 400);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocationRelativeTo(null);
		add(createContent());
	}

	private JPanel createContent() {
		JPanel panel = new JPanel(new BorderLayout(10, 10));
		JLabel label = new JLabel("���ʹ���ϵͳ", JLabel.CENTER);
		label.setFont(new Font("����", Font.BOLD, 40));
		panel.add(label, BorderLayout.NORTH);
		panel.add(createCenterPanel(), BorderLayout.CENTER);
		panel.add(createSouthPanel(), BorderLayout.SOUTH);
		return panel;
	}

	private JButton pre;
	private JButton next;

	private Component createSouthPanel() {
		JPanel panel = new JPanel();
		pre = new JButton("��һҳ");
		pre.setEnabled(false);
		pre.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				// ��һҳ
				page--;
				if (page == 1) {
					pre.setEnabled(false);
					next.setEnabled(true);
				}
				next.setEnabled(true);
				control.getGs().findByPage(page);
				updateGrid();
				pages.setText("��" + page + "ҳ");
			}
		});
		next = new JButton("��һҳ");
		next.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				pre.setEnabled(true);
				// ҳ��+1���ٴβ�ѯ���ݿ⣬���±��
				page++;
				int count = control.getCount();
				int pagemax;
				if(count % 5 == 0){
					pagemax = count/5;
				}else{
					pagemax = (count / 5) + 1;
				}
				control.getGs().findByPage(page);// ���²�ѯ���ݿ�
				updateGrid();
				pages.setText("��" + page + "ҳ");
				 if (page == pagemax) {
					 next.setEnabled(false);
				 }
			}
		});
		JButton add = new JButton("���");
		add.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				// ���
				control.myFrameToAddFrame();
			}
		});
		panel.add(pages);
		panel.add(pre);
		panel.add(next);
		panel.add(add);
		return panel;
	}

	private Component createCenterPanel() { // �������
		control.getGs().findByPage(page);// ��õ�һҳ������
		updateGrid();// ���±���е�����
		return gridPanel;
	}

	private void updateGrid() {// ���±���е�����
		gridPanel.removeAll();

		gridPanel.add(new JLabel("���", JLabel.CENTER));
		gridPanel.add(new JLabel("����", JLabel.CENTER));
		gridPanel.add(new JLabel("����", JLabel.CENTER));
		gridPanel.add(new JLabel("���ʱ��", JLabel.CENTER));
		gridPanel.add(new JLabel("��", JLabel.RIGHT));
		gridPanel.add(new JLabel("��", JLabel.LEFT));
		for (int i = 1; i <= 5; i++) {// ��ʾ����е�����
			Goods good = null;
			if (i <= control.getGs().getGoods().size()) {
				good = control.getGs().getGoods().get(i - 1);
			}
			createContextPanel(gridPanel, good);
			// panel ������壬�ڶ��������Ǳ���е�����
		}
	}

	private Component createContextPanel(JPanel panel, Goods goods) {
		final JTextField num = createText(goods == null ? "" : ""
				+ goods.getId());// ���
		final JTextField cls = createText(goods == null ? "" : goods.getCls()); // ����
		final JTextField name = createText(goods == null ? "" : goods.getName()); // ����
		final JTextField date = createText(goods == null ? "" : goods
				.getInput_time()); // ʱ��
		final JButton btndelete = new JButton("ɾ��");
		btndelete.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// ɾ��
				int idGood = Integer.parseInt(num.getText());
				if(control.deleteGood(idGood)){
					JOptionPane.showMessageDialog(null, "ɾ���ɹ�!");
				}else{
					JOptionPane.showMessageDialog(null, "ɾ��ʧ�ܣ�");
				}
			}
		});
		final JButton btn = new JButton("�༭");
		
		btn.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				if (btn.getText().equals("�༭")) {
					btn.setText("����");
					
					// �޸�

					cls.setEditable(true);
					name.setEditable(true);
					date.setEditable(true);
				} else if (btn.getText().equals("����")) {
					btn.setText("�༭");

					int idGood = Integer.parseInt(num.getText());
					String clsGood = cls.getText();
					String nameGood = name.getText();
					String timeGood = date.getText();
					if (control
							.updateGoods(idGood, clsGood, nameGood, timeGood)) {
						JOptionPane.showMessageDialog(null, "�޸ĳɹ���");
					} else {
						JOptionPane.showMessageDialog(null, "�޸�ʧ�ܣ�");
					}

					cls.setEditable(false);
					name.setEditable(false);
					date.setEditable(false);
				}
			}
		});

		panel.add(num);
		panel.add(cls);
		panel.add(name);
		panel.add(date);
		panel.add(btn);
		panel.add(btndelete);
		return panel;
	}

	private JTextField createText(String str) {
		JTextField text = new JTextField(str);
		text.setEditable(false);
		text.setText(str);
		text.setHorizontalAlignment(JTextField.CENTER);
		return text;
	}

	public static void main(String[] args) {
		Control control = new Control();
		MyFrame mf = new MyFrame(control);
		AddFrame af = new AddFrame(control);
		mf.setVisible(true);
	}
}
