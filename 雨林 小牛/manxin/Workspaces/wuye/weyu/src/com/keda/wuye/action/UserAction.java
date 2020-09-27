package com.keda.wuye.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;

import com.keda.wuye.biz.AlarmBiz;
import com.keda.wuye.biz.UserBiz;
import com.keda.wuye.biz.impl.AlarmBizImpl;
import com.keda.wuye.biz.impl.UserBizImpl;
import com.keda.wuye.entity.Alarm;
import com.keda.wuye.entity.User;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

public class UserAction extends ActionSupport {
	private String errornessage;
	private String username;
	private String password;
	private String path;
	private String s;
	private List<User> getdata;
	

	public String login() throws IOException {
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		UserBiz userBiz = new UserBizImpl();
		boolean b = userBiz.login(username, password);
		boolean a=userBiz.login(username, password);
		Map<String, String> session =ActionContext.getContext().getSession();
		session.put("admin", username);
		if (b == true||a==true) {
			out.print(0);
			
		} else {
			out.print(1);
		}
		out.flush();
		return NONE;
	}
	
	//��ȡС����?
	public String getUser()
	{
		UserBiz userBiz = new UserBizImpl();
		getdata = userBiz.getUser();
		path = "user_ui.jsp";
		return SUCCESS;			
	}
	//��ȡС����?
	public String selectlike()
	{
		UserBiz userBiz = new UserBizImpl();
		getdata = userBiz.select(s);
		path = "user_ui.jsp";
		return SUCCESS;			
	}
	//��ʾ
	public String notice() throws IOException
	{
		HttpServletResponse resp = ServletActionContext.getResponse();
		resp.setHeader("pragma", "no-cache");
		resp.setHeader("cache-control", "no-cache");
		PrintWriter out = resp.getWriter();
		UserBiz userBiz = new UserBizImpl();
		//���com_id�ظ�
		if(userBiz.nameEqual(username)==true)
		{
			//������ʾҳ��
			out.println(1);
		}
		else
		{
			out.println(0);
		}
		out.flush();
		return NONE;
	}
	
	//���
	public String insert()
	{
		UserBiz userBiz = new UserBizImpl();
		userBiz.insert(username, password);
		path = "user_getUser";
		return SUCCESS;		
	}
	
	//ɾ����Ϣ
	private String checkbox[];
	
	public String[] getCheckbox() {
		return checkbox;
	}

	public void setCheckbox(String[] checkbox) {
		this.checkbox = checkbox;
	}
	
	public String delete()
	{	
		UserBiz userBiz = new UserBizImpl();
		for(int i=0;i<checkbox.length;i++)
		{
			userBiz.delete(checkbox[i]);
		}
		path = "user_getUser";
		return SUCCESS;	
	}
	
	//��ѯһ����Ϣ
	public String select()
	{
		UserBiz userBiz = new UserBizImpl();
		User user = new User();
		user = userBiz.getUser(username);
		if(null==user)
		{
			return INPUT;
		}
		
		username = user.getUsername();
		password = user.getPassword();
		
		path = "user_edit.jsp";
		return SUCCESS;	
	}
	
	//�޸���Ϣ
	public String update()
	{
		UserBiz userBiz = new UserBizImpl();
		userBiz.update(username, password);
		path = "user_getUser";
		return SUCCESS;		
	}

	public String getPath() {
		return path;
	}

	public String getErrornessage() {
		return errornessage;
	}

	public void setErrornessage(String errornessage) {
		this.errornessage = errornessage;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public List<User> getGetdata() {
		return getdata;
	}

	public void setGetdata(List<User> getdata) {
		this.getdata = getdata;
	}

	public String getS() {
		return s;
	}

	public void setS(String s) {
		this.s = s;
	}
}
