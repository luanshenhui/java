package Pet;
import java.util.*;

public class PetShow {
	public static void main(String[] args){
		
		System.out.println("~~~~~~~~~��Ϸ��ʼ~~~~~~~~");
		System.out.println("�������������֣�");
		Scanner scan = new Scanner(System.in);
		String strName = scan.nextLine();
		System.out.println(strName+"�ѵ���~");
		Pet pet = new Pet(strName);
		PetPanel pp = new PetPanel(pet);
		PetFrame pf = new PetFrame();
		pf.add(pp);
		pf.show();
		
		pp.addKeyListener(pp);
		pf.addKeyListener(pp);
	}
}
