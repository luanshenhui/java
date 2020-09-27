package Test;

public class B {

	public void printAll(String str)
	{
	for(int i=0;i<str.length();i++)
	{
		System.out.print(str.charAt(i)+" ");
		
	}
	}
	
	public static char[] toArray(String str)
	{
		
		char[] arr=new char[str.length()];
		
		for(int i=0;i<str.length();i++)
		{
			
			arr[i]=str.charAt(i);
		}
		
		
			return null;
	}
	
	public static void main(String[] args) 
	{
		// TODO Auto-generated method stub
     
		//第一题：打印字符串的各个字符
		String str="abcde";
		B b=new B();
		b.printAll(str);
		
		
		//第二题：实现toArray，返回字符数组
		char[] arr=B.toArray(str);
		for(int i=0;i<arr.length;i++)
		{
			System.out.println(arr[i]);
		}
		
	}

}
