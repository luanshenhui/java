package user;

import java.awt.*;
import java.awt.event.*;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.*;
import javax.swing.text.StyleContext.SmallAttributeSet;

import exam_util.exam_sql;

public class RegistFrame extends JFrame{
	/*注册*/
	ControlShow cs;
	Connection conn;
	exam_sql sql = new exam_sql();
	public RegistFrame(ControlShow cs){
		init();
		this.cs = cs;
		cs.setRegist(this);
	}

	private void init() {
		setSize(500, 400);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false);	//大小无法被改变
		setLocation(400, 300);
		showFrame();
	}

	private void showFrame() {
		JPanel context = new JPanel(new BorderLayout(80, 50));
		JPanel northPanel = createNorthPanel();	//北面板
		JPanel southPanel = createSouthPanel();//南面板
		context.add(northPanel,BorderLayout.NORTH);
		context.add(southPanel,BorderLayout.SOUTH);
		context.add(new JLabel(" "), BorderLayout.EAST);
		context.add(new JLabel(" "), BorderLayout.WEST);
		context.add(createCenterPanel());//中间面板
		add(context);
	}

	private JPanel createNorthPanel() {
		// 北面板
		JPanel panel = new JPanel(new BorderLayout(0,30));
		JPanel textPanel = new JPanel();
		JLabel text = new JLabel("注   册");
		text.setFont(new Font("宋体", Font.BOLD,20));
		textPanel.add(text);
		panel.add(new JLabel(" "),BorderLayout.NORTH);
		panel.add(textPanel,BorderLayout.CENTER);
		return panel;
	}

	private JTextField idText;
	private JPasswordField pwdText;
	private JPasswordField pwdsText;
	private JTextField nameText;
	private JTextField emailText;
	private JPanel createCenterPanel() {
		//中间面板
		GridLayout gl = new GridLayout(5,2);
		JPanel panel = new JPanel(gl);		
		panel.add(new JLabel("输入账号："));
		idText = new JTextField();
		idText.setColumns(20);
		panel.add(idText);
		panel.add(new JLabel("输入密码："));
		pwdText = new JPasswordField();
		pwdText.setColumns(20);
		panel.add(pwdText);
		panel.add(new JLabel("确认密码："));
		pwdsText = new JPasswordField();
		pwdsText.setColumns(20);
		panel.add(pwdsText);
		panel.add(new JLabel("真实姓名："));
		nameText = new JTextField();
		nameText.setColumns(20);
		panel.add(nameText);
		panel.add(new JLabel("电子邮箱："));
		emailText = new JTextField();
		emailText.setColumns(20);
		panel.add(emailText);
		return panel;
	}

	private String id;
	private String pwd1;
	private String pwd2;
	private String name;
	private String email;
	private JPanel createSouthPanel() {
		//南面板
		JPanel jPanel = new JPanel(new BorderLayout(0,20));
		JPanel panel = new JPanel();
		JButton btnRegist = new JButton("注册");
		btnRegist.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 注册
				conn = sql.exam_Date();
				Statement stmt;
				id = idText.getText();
				pwd1 = pwdText.getText();
//				pwd2 = pwdsText.getText();
				name = nameText.getText();
				email = emailText.getText();
				try {
					stmt = conn.createStatement();
					String strSql = "select user_id from user_m";
					ResultSet rs = stmt.executeQuery(strSql);
					while(rs.next()){
						if(id.equals(rs.getString("user_id"))){
							JOptionPane.showMessageDialog(null, "注册的用户已存在！");
						}
					}
					if(cs.insert(id,pwd1,name,email)){
						JOptionPane.showMessageDialog(null, "注册成功！");
						cs.showLogin();
					}else{
						JOptionPane.showMessageDialog(null, "注册失败！");
					}
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		});
		JButton btnTurn = new JButton("返回");
		btnTurn.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 返回菜单
				cs.showLogin();
			}
		});
		panel.add(btnRegist);
		panel.add(new JLabel("  "));
		panel.add(new JLabel("  "));
		panel.add(new JLabel("  "));
		panel.add(btnTurn);
		jPanel.add(panel,BorderLayout.CENTER);
		jPanel.add(new JLabel("  "),BorderLayout.SOUTH);
		return jPanel;
	}
}
