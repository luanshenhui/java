import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

public class Client {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		File file = new File("f:\\员工信息.txt");
		List<Member> list = menthod(file);
		for (Member m : list) {
			System.out.println(m);
		}

	}

	private static List<Member> menthod(File file) {
		String name;
		char sex;
		int age;
		double salary;
		FileReader in;
		try {
			in = new FileReader(file);
			BufferedReader io = new BufferedReader(in);
			String str = "";
			while ((str = io.readLine()) != null) {
				List<String> list = new ArrayList<String>();
				String[] arr = str.split(",");
//				Member m = new Member(name, sex, age, salary);
//				m.setName(arr[0]);
//				m.setSex(arr[1].charAt(0));
//				m.setAge(Integer.parseInt(arr[2]));
//				m.setSalary(Double.parseDouble(arr[3]));
//				list.add(m);
				list.add(new Member(arr[0], arr[1].charAt(0), Integer
						.parseInt(arr[2]), Double.parseDouble(arr[3])));

			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	
		return list;
	}

}
