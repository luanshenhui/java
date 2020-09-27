package Test;

public class C {

	public static int m1(String str,int c)
	{   
		int m=0;
		char s=String.valueOf(c).charAt(0);//类型转换
		for(int i=0;i<str.length();i++)
		{
			if(s==str.charAt(i))
			{
				m++;
			}
			
			
		}
		
		return m;
		
	}
	
	public char m2(String str)
	{
		char c=str.charAt(0);
		int count=0;
		int m=0;
		for(int i=0;i<str.length();i++)
		{
			//int cc=m3(str,str.charAt(i));
			for(int j=0;j<str.length();j++)
			{
				if(str.charAt(j)==c)
				{
					
					m++;
				}
				
				
			}
			
			
			if(m>count)
			{
				count=m;
				c=str.charAt(i);
			}
			
		}
		return  c;
	}
	
	public int m3(String str,char c)
	{
		int m=0;
		for(int i=0;i<str.length();i++)
		{
			if(str.charAt(i)==c)
			{
				
				m++;
			}
			
			
		}
		return m;
		
	}
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub

		//第三题：统计字符串数组中某数字的个数
//		String str="123333335677987";
//		int count=C.m1(str,3);
//		System.out.println(count);
		
		//第四题：统计字符串中哪个字符出现的次数最多
		String str="aadhhijjjjjjjgh";
		C c=new C();
		char result=c.m2(str);
		System.out.println(result);
		
		
	}

}
