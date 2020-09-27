import java.util.ArrayList;
import java.util.Arrays;


public class AAA {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int index=1;
		Boolean[] test=new Boolean[3];
		System.out.println(Arrays.toString(test));
		Boolean foo=test[index];
		System.out.println(foo);


	}
	private boolean checkFlag(String s){
		boolean flag=false;
		if(s.equals("error")){
			flag=true;
			//return flag;
		}
		return flag;
	}
		
	}


