package user;

import java.awt.*;
import java.awt.event.*;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.RuleBasedCollator;

import javax.swing.*;
import exam_util.exam_sql;;

public class LoginFrame extends JFrame{
	
	ControlShow cs;
	/*登陆界面*/
	public LoginFrame(ControlShow cs){
		init();
		this.cs = cs;
		cs.setLogin(this);
	}

	exam_sql sql = new exam_sql();//数据库
	Connection conn = null;
	private void init() {
		// 页面设置
		setSize(400,300);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false);
		setLocation(400, 300);
		showFrame();
	}

	private void showFrame() {
		// 页面
		JPanel context = new JPanel(new BorderLayout(20,30));
		JPanel northPanel = createNorthPanel();
		JPanel centerPanel = createCenterPanel();
		JPanel southPanel = createSouthPanel();
		context.add(northPanel,BorderLayout.NORTH);	 //北面板
		context.add(centerPanel,BorderLayout.CENTER);	//中间面板
		context.add(southPanel,BorderLayout.SOUTH);	 //南面板
		add(context);
	}

	private JPanel createNorthPanel() {
		// 北面板
		JPanel panel = new JPanel(new BorderLayout(0,20));
		JPanel textPanel = new JPanel();
		JLabel text = new JLabel("登  录");
		text.setFont(new Font("宋体",Font.BOLD,20));	//更改字体
		textPanel.add(text);
		panel.add(new JLabel(" "),BorderLayout.NORTH);
		panel.add(textPanel,BorderLayout.CENTER);
		return panel;
	}

	private JPanel createCenterPanel() {
		// 中间面板
		JPanel panel = new JPanel(new BorderLayout());
		panel.add(caeateIDPanel(),BorderLayout.NORTH);	//用户名面板
		panel.add(createPWDPanel(),BorderLayout.SOUTH);	//密码面板
		return panel;
	}

	private JTextField idText;
	private Component caeateIDPanel() {
		// 用户名面板
		JPanel panel = new JPanel();
		JLabel text = new JLabel("账号：");
		idText = new JTextField();
		idText.setColumns(20);	//宽度为20个字符
		panel.add(text);
		panel.add(idText);
		return panel;
	}

	private JPasswordField pwdText;
	private Component createPWDPanel() {
		// 密码面板
		JPanel panel = new JPanel();
		JLabel text = new JLabel("密码：");
		pwdText = new JPasswordField();
		pwdText.setColumns(20);	//宽度为20个字符
		panel.add(text);
		panel.add(pwdText);
		return panel;
	}

	private String user_id;
	private String user_pwd;
	private JPanel createSouthPanel() {
		// 南面板
		JPanel jp = new JPanel(new BorderLayout(0,10));
		JPanel panel = new JPanel();
		JButton btnLogin = new JButton("登录");
		btnLogin.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 登录
				conn = sql.exam_Date();
				String id = idText.getText();
				String pwd = pwdText.getText();
				try {
					Statement stmt = conn.createStatement();
					String strSql = "select * from user_m";
					ResultSet rs = stmt.executeQuery(strSql);
					while(rs.next()){
						user_id = rs.getString("user_id");
						user_pwd = rs.getString("user_pwd");
						if(id.equals(user_id) && pwd.equals(user_pwd)){
//							System.out.println(user_id+","+user_pwd);
							//TODO
							String user_name = rs.getString("user_name");	//名字传值？	
							JOptionPane.showMessageDialog(null, "登录成功！");
							cs.showMenu();
						}
					}
					rs.close();
					stmt.close();
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
					System.out.println("数据库访问失败");
				}
			}
		});
		
		JButton btnRegist = new JButton("注册");
		btnRegist.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// 注册
				cs.showRegist();
			}
		});
		panel.add(btnLogin);
		panel.add(new JLabel(" "));//调整两个按钮间的距离
		panel.add(new JLabel(" "));
		panel.add(new JLabel(" "));
		panel.add(btnRegist);
		jp.add(panel,BorderLayout.CENTER);
		jp.add(new JLabel(" "),BorderLayout.SOUTH);
		return jp;
	}

}
