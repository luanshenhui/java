package Test;

/*
 * java中的数据类型只有两种  基本数据类型  引用类型（系统提供的类  还有 你自己定义的类）
 * 除了基本数据类型就是引用类型
 * 字符串的length（）  数组的length区别？ 
 * 字符串是一个经过优化的非标准的一个类
 * String a = "a";
 * 0  48   a 97  A 65
 * 字符串方法 length（） indexOf() lastIndexOf  charAt  spilt  toUpperCase
 * toLowwerCase  startsWith  endsWith  contains  valuesOf toCharArray
 * equals  tostring  replaceAll subString
 * 字符串底层维护的是字符数组    同样重写了java 中Object类的tostring方法和equals方法
 */
public class A {

	
	
	public static void main(String[] args) {
		int[] b = {1,2};
		System.out.println(b.toString());
		String c = "s";
		System.out.println(c.toString());
		// TODO Auto-generated method stub

        //Java的类型分为两类：
		//（1）基本数据类型
		//（2）类类型   
		
	    //String字符串：使用频率比数字类型的总和还要多。
		
		//(1)创建字符串方法有二
		//1
		String str=new String("hello");
		//2
		System.out.println(str);
		//因为用的太多，所以也可简化这样写,建议使用字面值的写法创建字符串
		String str1="hhahah";
        System.out.println(str1);
		
        //(2)判断字符串相等的方法：equals方法。相等返回true，不等返回false
        //基本数据类型判断相等时使用“==”
        //类类型判断相等时都使用equals方法
        /*String s1="djnfjj";
        String s2="dkdj";
        boolean boo=s1.equals(s2);
        System.out.println(boo);*/
        
        //字符串的本质：是字符数组char[].
        //(3)从String中获取字符的方法:charAt方法。参数是下标，返回对应的下标. char类型
       /* String s3="dhudhw";
        char c=s3.charAt(0);
        System.out.println(c);
        //遍历字符串数组，打印出每个字符
        for(int i=0;i<s3.length();i++)
        {
        	char s=s3.charAt(i);
        	System.out.println(s+"  ");
        	
        }*/
          //(4)截取字符串的方法：substring方法，两个参数表是下标
         //注意：begindex < =字符串< endIndex
        
//        String str6="fhfk";
//        String s=str6.substring(2,3);
//        System.out.println(s);
        //(5)startwith方法：判断是否以指定字符串开头，是返回true，否则返回false。布尔类型
        //同理：endwith方法：判断是否已指定字符串结尾，是则返回true，否则返回false，布尔类型
        /*String s="fjuew";
        boolean b=s.startsWith("fju");
        boolean b1=s.endsWith("ew");
        System.out.println(b1);*/
        //（6）contains方法：判断字符串是否包含当前字符串。是则返回true，否则返回false。布尔值
//        String s="dmkwdk";
//        boolean boo=s.contains("msk");
//        System.out.println(boo);
        //(7)indexOf方法：在字符串中查找当前字符串的起始下标，找到则返回其起始下标，未找到则返回-1.int 型
//        String s="djiujhfnjrg";
//        int i=s.indexOf("jou");
//        System.out.println(i);
        //(8)toUpperCase方法：把当前字符串都变为大写。无参数。
        //   toLowerCase方法：把当前字符串都变为小写。无参数。
       /* String s="djAhjkhjkFG";
        String s1=s.toUpperCase();
        String s2=s.toLowerCase();
        System.out.println(s1);
        System.out.println(s2);*/
     //(9)split方法：以参数为分隔符返回一个字符串数组
//        String s="jdwjd,jdifgt,ffewfik";
//        String[] arr=s.split(",");
//        for(int i=0;i<arr.length;i++)
//        {
//        	System.out.println(arr[i]);
//        }
        //(10)基本数据类型转化为字符串. String.valOf方法。返回String类型的字符串
        
//        double i=10;
//        String s1=String.valueOf(i);
//        System.out.println(s1);
        
        
	}
      
	
}
