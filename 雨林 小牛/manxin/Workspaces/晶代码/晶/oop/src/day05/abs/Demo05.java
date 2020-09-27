package day05.abs;

import java.util.Timer;
import java.util.TimerTask;

public class Demo05 {
	public static void main(String[] args) {
		Timer timer = new Timer();
		timer.schedule(new DemoTask(),0, 1000/10);
	}
}
class DemoTask extends TimerTask{
	String[] ary = {
			">>        <<", //0
			" >>      << ", //1
			"  >>    <<  ", //2
			"   >>  <<   ", //3
			"    >><<    ", //4
			"     ><     ", //5
			">          <"};//6
	int i=0;
	public void run() {
		i++;//i=8
		String s = ary[i%ary.length];
		//每次执行run方法会周期性的输出数组中的每个字符串
		System.out.println(s); 
	}
}




