package Text;

import java.util.Timer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class TaskListener implements ServletContextListener{
	private Timer timer = new Timer();
	public void contextDestroyed(ServletContextEvent arg0) {
		System.out.println("servletContext被销毁了...");
		//取消一个任务
		timer.cancel();
	}
	
	public void contextInitialized(ServletContextEvent arg0) {
		System.out.println("servletContext 创建了...");
		//启动一个任务
		System.out.println("aaaaa");
		timer.schedule(new MyTask(), 1000, 5000);
	}
}
