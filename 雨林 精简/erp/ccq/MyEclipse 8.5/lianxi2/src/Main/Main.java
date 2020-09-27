package Main;

public class Main {

	
	public static void main(String[] args) {
	Sorter sorter1=new Sorter();
	sorter1.add(new PartyMember("王进喜",20));
	sorter1.add(new PartyMember("雷锋",24));
	sorter1.add(new PartyMember("张思德",10));
	sorter1.add(new PartyMember("徐虎",30));
	
	sorter1.display();
	
	Sorter sorter2=new Sorter();
	sorter2.add(new Employee("Andy",2000));
	sorter2.add(new Employee("Bill",10000));
	sorter2.add(new Employee("Cindy",38000));
	sorter2.add(new Employee("Douglas",7500));
	
	sorter2.display();

	
	}

}
