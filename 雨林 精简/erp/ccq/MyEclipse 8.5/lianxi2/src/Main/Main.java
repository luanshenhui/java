package Main;

public class Main {

	
	public static void main(String[] args) {
	Sorter sorter1=new Sorter();
	sorter1.add(new PartyMember("����ϲ",20));
	sorter1.add(new PartyMember("�׷�",24));
	sorter1.add(new PartyMember("��˼��",10));
	sorter1.add(new PartyMember("�컢",30));
	
	sorter1.display();
	
	Sorter sorter2=new Sorter();
	sorter2.add(new Employee("Andy",2000));
	sorter2.add(new Employee("Bill",10000));
	sorter2.add(new Employee("Cindy",38000));
	sorter2.add(new Employee("Douglas",7500));
	
	sorter2.display();

	
	}

}
