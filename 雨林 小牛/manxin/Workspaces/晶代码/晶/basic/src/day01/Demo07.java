package day01;
/**
 * boolean 类型
 * 1) 只有两个值：true 真, false 假
 * 2) 用来表示判断结果状态的 
 */
public class Demo07 {
  public static void main(String[] args) {
    int age = 18;
    boolean isChild = age < 16;//false
    //这个结果表示：不是小孩
    System.out.println(isChild); //false
  
    boolean isMan = true; //isMan 是爷们吗？纯爷们
    boolean used = true;  //用过,二手
    boolean pause = false;//暂停
    
    boolean f = true;//这个没有意义!
    
    if(pause){
      System.out.println("按[C]继续运行...");
    }else{
      System.out.println("按[P]暂停");
    }
    if(used){
      System.out.println("跳了价，八折！"); 
    }
  }
}





