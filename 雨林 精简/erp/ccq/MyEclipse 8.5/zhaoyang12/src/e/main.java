package e;

public class main {
	public static void main(String[] args){
		City city=new City("����");
		Person person =new Person("����");
		//�����˵ĳ���
		person.setCity(city);
		city.setPerson(person);
		System.out.println(person);
		System.out.println(city);
		
	}
	

}
