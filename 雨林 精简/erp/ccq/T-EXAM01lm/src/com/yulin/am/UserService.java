package com.yulin.am;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

public class UserService {
	private static String userDataPath = "src/user.data";
	private static String scorePath = "src/score.text";
	
	public User login(String id, String pwd){
		ArrayList<String> list = null;
		try {
			list = FileUtil.read(userDataPath);
		} catch (IOException e) {
			e.printStackTrace();
		}
		for(String s : list){
			String[] ss = s.split("#");
			//��һ��Ԫ�غ͵ڶ���Ԫ�طֱ����û��������룬����������Ϣ�����бȽ�
			if(id.equals(ss[0]) && pwd.equals(ss[1])){
				User u = new User(ss[0], ss[1], ss[2], ss[3]);
				
				u.setScore(getscore(ss[0]));//��õ÷֣����÷����Ը�ֵ
				
				return u;
			}
		}
		return null;
	}
	
	private int getscore(String id) {
		// TODO Auto-generated method stub��õ�½�û��ĵ÷� ���
		try{
		ArrayList<String>list=FileUtil.read(scorePath);
		for(String s:list){
			String[]ss=s.split("#");
			if(id.equals(ss[0])){
				return Integer.parseInt(ss[2]);
			}
		}
	} catch (IOException e){
		e.printStackTrace();
	}
		
		return -1;
	}

	public boolean regist(String id,String pwd1,String pwd2
			, String name, String email){
		if(checkID(id) && checkPWD(pwd1, pwd2)){
			String context = id+"#"+pwd1+"#"+name+"#"+email;
			try {
				FileUtil.write("src/user.data", context);
			} catch (IOException e) {
				e.printStackTrace();
			}
			return true;
		}else{
			return false;
		}
	}

	private boolean checkPWD(String pwd1, String pwd2) {
		// TODO Auto-generated method stub
		return false;
	}

	private boolean checkID(String id) {
		// TODO Auto-generated method stub
		return false;
	}

	public ArrayList<String> getUserAnswers(String  loginID) {
		// TODO Auto-generated method stub
			ArrayList<String>list=new ArrayList<String>();
			try {
				ArrayList<String>strs=FileUtil.read(scorePath);
				for(String s:strs){
					String[]ss=s.trim().split("#");
					if(ss[0].equals(loginID)){
//						list=(ArrayList<String>)//ǿ������װ��list-object-string?,����װ��
//						Arrays.asList(ss[3].split(" "));//�û���
						for(String us:ss[3].split(" ")){
							list.add(us);
						}
					}
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		return null;
	}
}
