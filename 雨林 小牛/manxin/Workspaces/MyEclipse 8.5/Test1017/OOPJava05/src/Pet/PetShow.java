package Pet;
import java.util.*;

public class PetShow {
	public static void main(String[] args){
		
		System.out.println("~~~~~~~~~游戏开始~~~~~~~~");
		System.out.println("请输入宠物的名字：");
		Scanner scan = new Scanner(System.in);
		String strName = scan.nextLine();
		System.out.println(strName+"已诞生~");
		Pet pet = new Pet(strName);
		PetPanel pp = new PetPanel(pet);
		PetFrame pf = new PetFrame();
		pf.add(pp);
		pf.show();
		
		pp.addKeyListener(pp);
		pf.addKeyListener(pp);
	}
}
