package Pet;
import java.util.*;

public class Pet {
	
	public Pet(String name){
		this.name = name;
		age = 0;
		chengZhang();
	}
	public String name;
	public int age;
	public int heart = 50;
	public int qingjie = 50;
	public int jie = 50;
	public int panni = 50;
	public int level = 50;
	
	public void chengZhang(){
		new Timer().schedule(new TimerTask(){
			@Override
			public void run(){
				level += 10;
				if(level >= 100){
					age += 1;
					level = 0;
				}
				jie -= 10;
				if(jie <= 0){
					System.out.println("饿死了~！");
					System.out.println("Game Over~!");
					System.exit(0);
				}
				qingjie -= 10;
				if(qingjie <= 0){
					System.out.println("脏死了~！快洗澡");
					System.out.println("Game Over~!");
					System.exit(0);
				}
				heart -= 10;
				if(heart <= 0){
					System.out.println("我要离家出走~！");
					System.out.println("Game Over~!");
					System.exit(0);
				}
			}
		}, 0,10000);
	}

}
