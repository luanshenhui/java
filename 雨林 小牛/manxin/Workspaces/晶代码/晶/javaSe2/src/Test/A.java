package Test;

/*
 * java�е���������ֻ������  ������������  �������ͣ�ϵͳ�ṩ����  ���� ���Լ�������ࣩ
 * ���˻����������;�����������
 * �ַ�����length����  �����length���� 
 * �ַ�����һ�������Ż��ķǱ�׼��һ����
 * String a = "a";
 * 0  48   a 97  A 65
 * �ַ������� length���� indexOf() lastIndexOf  charAt  spilt  toUpperCase
 * toLowwerCase  startsWith  endsWith  contains  valuesOf toCharArray
 * equals  tostring  replaceAll subString
 * �ַ����ײ�ά�������ַ�����    ͬ����д��java ��Object���tostring������equals����
 */
public class A {

	
	
	public static void main(String[] args) {
		int[] b = {1,2};
		System.out.println(b.toString());
		String c = "s";
		System.out.println(c.toString());
		// TODO Auto-generated method stub

        //Java�����ͷ�Ϊ���ࣺ
		//��1��������������
		//��2��������   
		
	    //String�ַ�����ʹ��Ƶ�ʱ��������͵��ܺͻ�Ҫ�ࡣ
		
		//(1)�����ַ��������ж�
		//1
		String str=new String("hello");
		//2
		System.out.println(str);
		//��Ϊ�õ�̫�࣬����Ҳ�ɼ�����д,����ʹ������ֵ��д�������ַ���
		String str1="hhahah";
        System.out.println(str1);
		
        //(2)�ж��ַ�����ȵķ�����equals��������ȷ���true�����ȷ���false
        //�������������ж����ʱʹ�á�==��
        //�������ж����ʱ��ʹ��equals����
        /*String s1="djnfjj";
        String s2="dkdj";
        boolean boo=s1.equals(s2);
        System.out.println(boo);*/
        
        //�ַ����ı��ʣ����ַ�����char[].
        //(3)��String�л�ȡ�ַ��ķ���:charAt�������������±꣬���ض�Ӧ���±�. char����
       /* String s3="dhudhw";
        char c=s3.charAt(0);
        System.out.println(c);
        //�����ַ������飬��ӡ��ÿ���ַ�
        for(int i=0;i<s3.length();i++)
        {
        	char s=s3.charAt(i);
        	System.out.println(s+"  ");
        	
        }*/
          //(4)��ȡ�ַ����ķ�����substring�������������������±�
         //ע�⣺begindex < =�ַ���< endIndex
        
//        String str6="fhfk";
//        String s=str6.substring(2,3);
//        System.out.println(s);
        //(5)startwith�������ж��Ƿ���ָ���ַ�����ͷ���Ƿ���true�����򷵻�false����������
        //ͬ��endwith�������ж��Ƿ���ָ���ַ�����β�����򷵻�true�����򷵻�false����������
        /*String s="fjuew";
        boolean b=s.startsWith("fju");
        boolean b1=s.endsWith("ew");
        System.out.println(b1);*/
        //��6��contains�������ж��ַ����Ƿ������ǰ�ַ��������򷵻�true�����򷵻�false������ֵ
//        String s="dmkwdk";
//        boolean boo=s.contains("msk");
//        System.out.println(boo);
        //(7)indexOf���������ַ����в��ҵ�ǰ�ַ�������ʼ�±꣬�ҵ��򷵻�����ʼ�±꣬δ�ҵ��򷵻�-1.int ��
//        String s="djiujhfnjrg";
//        int i=s.indexOf("jou");
//        System.out.println(i);
        //(8)toUpperCase�������ѵ�ǰ�ַ�������Ϊ��д���޲�����
        //   toLowerCase�������ѵ�ǰ�ַ�������ΪСд���޲�����
       /* String s="djAhjkhjkFG";
        String s1=s.toUpperCase();
        String s2=s.toLowerCase();
        System.out.println(s1);
        System.out.println(s2);*/
     //(9)split�������Բ���Ϊ�ָ�������һ���ַ�������
//        String s="jdwjd,jdifgt,ffewfik";
//        String[] arr=s.split(",");
//        for(int i=0;i<arr.length;i++)
//        {
//        	System.out.println(arr[i]);
//        }
        //(10)������������ת��Ϊ�ַ���. String.valOf����������String���͵��ַ���
        
//        double i=10;
//        String s1=String.valueOf(i);
//        System.out.println(s1);
        
        
	}
      
	
}
