package day01;
/**
 * boolean ����
 * 1) ֻ������ֵ��true ��, false ��
 * 2) ������ʾ�жϽ��״̬�� 
 */
public class Demo07 {
  public static void main(String[] args) {
    int age = 18;
    boolean isChild = age < 16;//false
    //��������ʾ������С��
    System.out.println(isChild); //false
  
    boolean isMan = true; //isMan ��ү���𣿴�ү��
    boolean used = true;  //�ù�,����
    boolean pause = false;//��ͣ
    
    boolean f = true;//���û������!
    
    if(pause){
      System.out.println("��[C]��������...");
    }else{
      System.out.println("��[P]��ͣ");
    }
    if(used){
      System.out.println("���˼ۣ����ۣ�"); 
    }
  }
}





