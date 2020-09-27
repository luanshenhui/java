package Main;

public class Sorter {
	private Person[] arr = new Person[4];

	private int i = 0;

	public Sorter() {

	}

	public void add(Person person) {
		// TODO Auto-generated method stub
		arr[i++] = person;
	}

	public void display() {
		sort();
		for (Person per : arr) {
			System.out.println(per);
		}

	}

	public void sort() {
		for(int i=0;i<arr.length;i++){
			for(int j=0;j<arr.length-i-1;j++){
				if(arr[j].ms(arr[j+1])){
					Person t=arr[j];
					arr[j]=arr[j+1];
					arr[j+1]=t;
				}
			}
			
		}

	}

}
