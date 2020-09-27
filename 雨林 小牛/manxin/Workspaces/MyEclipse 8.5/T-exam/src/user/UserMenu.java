package user;

import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.*;
import exam_util.exam_sql;

public class UserMenu extends JFrame{
	/*�˵�ҳ��*/
	ControlShow cs;
	//����
	public UserMenu(ControlShow cs){
		init();	
		this.cs = cs;
		cs.setMenu(this);
	}

	private void init() {
		// ����ҳ��
		setSize(500, 400);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setLocation(400, 300);
		setResizable(false);	//��С�޷����ı�
		showFrame();
	}

	private void showFrame() {
		JPanel context = new JPanel(new BorderLayout(350,80));
		JPanel northPanel = createNorthPanel();
		JPanel conterPanel = createConterPanel();
		JPanel southPanel = createSouthPanel();
		context.add(northPanel, BorderLayout.NORTH);
		context.add(conterPanel, BorderLayout.CENTER);
		context.add(southPanel, BorderLayout.SOUTH);
		add(context);
	}

	private JLabel nameText;//��ʾ����
	private JPanel createNorthPanel() {
		// ����棬JLabelͼƬ
		JPanel panel = new JPanel(new BorderLayout());
		JLabel label1 = new JLabel(new ImageIcon("src/img/3.png"),JLabel.LEFT);
		JLabel label2 = new JLabel(new ImageIcon("src/img/3.png"),JLabel.RIGHT);
		JLabel textLabel = new JLabel("��ӭ���ٿ���ϵͳ",JLabel.CENTER);
		textLabel.setFont(new Font("����",Font.BOLD,25));
		nameText = new JLabel("",JLabel.CENTER);
		panel.add(label1,BorderLayout.WEST);
		panel.add(label2,BorderLayout.EAST);
		panel.add(textLabel,BorderLayout.CENTER);
		panel.add(nameText,BorderLayout.SOUTH);
		return panel;
	}
	
	public void updateNameText(){//�޸�����
		nameText.setText(cs.getUser().getUser_name());
		nameText.repaint();
	}
	
	private JButton btn1;
	private JButton btn2;
	private JButton btn3;
	private JButton btn4;
	private JPanel createConterPanel() {
		//�м���壬ͼƬ��ť
		JPanel panel = new JPanel();		
		btn1 = createImageButton("��ʼ","1.png");		
		btn2 = createImageButton("����","4.png");		
		btn3 = createImageButton("����","5.png");		
		btn4 = createImageButton("�뿪","6.png");
		
		panel.add(btn1);
		panel.add(btn2);
		panel.add(btn3);
		panel.add(btn4);		
		return panel;
	}

	private JButton createImageButton(String text, String image) {
		// ����ͼƬ��ť�ķ���
		JButton btn = new JButton(text,new ImageIcon("src/img/" + image));
		btn.setHorizontalTextPosition(JButton.CENTER);
		btn.setVerticalTextPosition(JButton.BOTTOM);
		return btn;
	}
	
	private JPanel createSouthPanel() {
		//����� LaboyͼƬ
		JPanel panel = new JPanel(new BorderLayout());
		JLabel label = new JLabel("��Ȩ����  ��ð�ؾ�",JLabel.RIGHT);
		panel.add(label);
		return panel;
	}
}
