package com.yulin.manager.ui;

import java.awt.*;
import java.awt.event.*;

import javax.swing.*;
import com.yulin.manager.bean.Goods;
import com.yulin.manager.control.Control;

public class MyFrame extends JFrame {
	/**
	 * 分页查询： 两种分页策略： 一、基于查询的分页 每一页需要显示的信息都需要查询一次数据库，利用SQL语句帮我们完成分页
	 * 对数据库和服务器的压力比较大，但是对缓存/内存的压力比较小
	 * 
	 * 二、基于缓存的分页 一次性查询出所有的数据，放入缓存/内存中 第一次运行比较慢，对数据库和服务器的压力比较小 对缓存/内存的压力比较大
	 */

	private Control control;
	private int page = 1;// 当前的页数
	JPanel gridPanel = new JPanel(new GridLayout(6, 6));;
	JLabel pages = new JLabel("第1页");

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
		JLabel label = new JLabel("物资管理系统", JLabel.CENTER);
		label.setFont(new Font("黑体", Font.BOLD, 40));
		panel.add(label, BorderLayout.NORTH);
		panel.add(createCenterPanel(), BorderLayout.CENTER);
		panel.add(createSouthPanel(), BorderLayout.SOUTH);
		return panel;
	}

	private JButton pre;
	private JButton next;

	private Component createSouthPanel() {
		JPanel panel = new JPanel();
		pre = new JButton("上一页");
		pre.setEnabled(false);
		pre.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				// 上一页
				page--;
				if (page == 1) {
					pre.setEnabled(false);
					next.setEnabled(true);
				}
				next.setEnabled(true);
				control.getGs().findByPage(page);
				updateGrid();
				pages.setText("第" + page + "页");
			}
		});
		next = new JButton("下一页");
		next.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				pre.setEnabled(true);
				// 页数+1，再次查询数据库，更新表格
				page++;
				int count = control.getCount();
				int pagemax;
				if(count % 5 == 0){
					pagemax = count/5;
				}else{
					pagemax = (count / 5) + 1;
				}
				control.getGs().findByPage(page);// 重新查询数据库
				updateGrid();
				pages.setText("第" + page + "页");
				 if (page == pagemax) {
					 next.setEnabled(false);
				 }
			}
		});
		JButton add = new JButton("添加");
		add.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				// 添加
				control.myFrameToAddFrame();
			}
		});
		panel.add(pages);
		panel.add(pre);
		panel.add(next);
		panel.add(add);
		return panel;
	}

	private Component createCenterPanel() { // 表格区域
		control.getGs().findByPage(page);// 获得第一页的数据
		updateGrid();// 更新表格中的数据
		return gridPanel;
	}

	private void updateGrid() {// 更新表格中的数据
		gridPanel.removeAll();

		gridPanel.add(new JLabel("编号", JLabel.CENTER));
		gridPanel.add(new JLabel("分类", JLabel.CENTER));
		gridPanel.add(new JLabel("名称", JLabel.CENTER));
		gridPanel.add(new JLabel("入库时间", JLabel.CENTER));
		gridPanel.add(new JLabel("操", JLabel.RIGHT));
		gridPanel.add(new JLabel("作", JLabel.LEFT));
		for (int i = 1; i <= 5; i++) {// 显示表格中的数据
			Goods good = null;
			if (i <= control.getGs().getGoods().size()) {
				good = control.getGs().getGoods().get(i - 1);
			}
			createContextPanel(gridPanel, good);
			// panel 表格的面板，第二个参数是表格中的数据
		}
	}

	private Component createContextPanel(JPanel panel, Goods goods) {
		final JTextField num = createText(goods == null ? "" : ""
				+ goods.getId());// 编号
		final JTextField cls = createText(goods == null ? "" : goods.getCls()); // 分类
		final JTextField name = createText(goods == null ? "" : goods.getName()); // 名称
		final JTextField date = createText(goods == null ? "" : goods
				.getInput_time()); // 时间
		final JButton btndelete = new JButton("删除");
		btndelete.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 删除
				int idGood = Integer.parseInt(num.getText());
				if(control.deleteGood(idGood)){
					JOptionPane.showMessageDialog(null, "删除成功!");
				}else{
					JOptionPane.showMessageDialog(null, "删除失败！");
				}
			}
		});
		final JButton btn = new JButton("编辑");
		
		btn.addActionListener(new ActionListener() {

			@Override
			public void actionPerformed(ActionEvent e) {
				if (btn.getText().equals("编辑")) {
					btn.setText("保存");
					
					// 修改

					cls.setEditable(true);
					name.setEditable(true);
					date.setEditable(true);
				} else if (btn.getText().equals("保存")) {
					btn.setText("编辑");

					int idGood = Integer.parseInt(num.getText());
					String clsGood = cls.getText();
					String nameGood = name.getText();
					String timeGood = date.getText();
					if (control
							.updateGoods(idGood, clsGood, nameGood, timeGood)) {
						JOptionPane.showMessageDialog(null, "修改成功！");
					} else {
						JOptionPane.showMessageDialog(null, "修改失败！");
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
