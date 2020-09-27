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
	/*��½����*/
	public LoginFrame(ControlShow cs){
		init();
		this.cs = cs;
		cs.setLogin(this);
	}

	exam_sql sql = new exam_sql();//���ݿ�
	Connection conn = null;
	private void init() {
		// ҳ������
		setSize(400,300);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setResizable(false);
		setLocation(400, 300);
		showFrame();
	}

	private void showFrame() {
		// ҳ��
		JPanel context = new JPanel(new BorderLayout(20,30));
		JPanel northPanel = createNorthPanel();
		JPanel centerPanel = createCenterPanel();
		JPanel southPanel = createSouthPanel();
		context.add(northPanel,BorderLayout.NORTH);	 //�����
		context.add(centerPanel,BorderLayout.CENTER);	//�м����
		context.add(southPanel,BorderLayout.SOUTH);	 //�����
		add(context);
	}

	private JPanel createNorthPanel() {
		// �����
		JPanel panel = new JPanel(new BorderLayout(0,20));
		JPanel textPanel = new JPanel();
		JLabel text = new JLabel("��  ¼");
		text.setFont(new Font("����",Font.BOLD,20));	//��������
		textPanel.add(text);
		panel.add(new JLabel(" "),BorderLayout.NORTH);
		panel.add(textPanel,BorderLayout.CENTER);
		return panel;
	}

	private JPanel createCenterPanel() {
		// �м����
		JPanel panel = new JPanel(new BorderLayout());
		panel.add(caeateIDPanel(),BorderLayout.NORTH);	//�û������
		panel.add(createPWDPanel(),BorderLayout.SOUTH);	//�������
		return panel;
	}

	private JTextField idText;
	private Component caeateIDPanel() {
		// �û������
		JPanel panel = new JPanel();
		JLabel text = new JLabel("�˺ţ�");
		idText = new JTextField();
		idText.setColumns(20);	//���Ϊ20���ַ�
		panel.add(text);
		panel.add(idText);
		return panel;
	}

	private JPasswordField pwdText;
	private Component createPWDPanel() {
		// �������
		JPanel panel = new JPanel();
		JLabel text = new JLabel("���룺");
		pwdText = new JPasswordField();
		pwdText.setColumns(20);	//���Ϊ20���ַ�
		panel.add(text);
		panel.add(pwdText);
		return panel;
	}

	private String user_id;
	private String user_pwd;
	private JPanel createSouthPanel() {
		// �����
		JPanel jp = new JPanel(new BorderLayout(0,10));
		JPanel panel = new JPanel();
		JButton btnLogin = new JButton("��¼");
		btnLogin.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// ��¼
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
							String user_name = rs.getString("user_name");	//���ִ�ֵ��	
							JOptionPane.showMessageDialog(null, "��¼�ɹ���");
							cs.showMenu();
						}
					}
					rs.close();
					stmt.close();
					conn.close();
				} catch (SQLException e1) {
					e1.printStackTrace();
					System.out.println("���ݿ����ʧ��");
				}
			}
		});
		
		JButton btnRegist = new JButton("ע��");
		btnRegist.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				// ע��
				cs.showRegist();
			}
		});
		panel.add(btnLogin);
		panel.add(new JLabel(" "));//����������ť��ľ���
		panel.add(new JLabel(" "));
		panel.add(new JLabel(" "));
		panel.add(btnRegist);
		jp.add(panel,BorderLayout.CENTER);
		jp.add(new JLabel(" "),BorderLayout.SOUTH);
		return jp;
	}

}
