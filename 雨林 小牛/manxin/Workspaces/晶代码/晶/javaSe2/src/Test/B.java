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
     
		//��һ�⣺��ӡ�ַ����ĸ����ַ�
		String str="abcde";
		B b=new B();
		b.printAll(str);
		
		
		//�ڶ��⣺ʵ��toArray�������ַ�����
		char[] arr=B.toArray(str);
		for(int i=0;i<arr.length;i++)
		{
			System.out.println(arr[i]);
		}
		
	}

}
