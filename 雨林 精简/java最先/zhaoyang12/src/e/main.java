package e;

public class main {
	public static void main(String[] args){
		City city=new City("大连");
		Person person =new Person("青青");
		//设置人的城市
		person.setCity(city);
		city.setPerson(person);
		System.out.println(person);
		System.out.println(city);
		
	}
	

}
