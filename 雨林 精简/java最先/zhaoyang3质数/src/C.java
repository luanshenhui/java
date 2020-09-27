
public class C {

	public Employee m(Employee[] arr) {
		// TODO Auto-generated method stub
		Employee emp=arr[0];
		for(int i=0;i<arr.length;i++){
			if(arr[0].getSalary()<arr[i].getSalary()){
				emp=arr[i];
			}
		}
		return emp;
	}

}
