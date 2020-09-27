package CaiShuGame;
import java.util.*;

public class Game {

	/**
	 * ��������Ϸ��
	 *	1.�������4����λ��
	 *	2.�����̨������µ���
	 *	3.��ʾ��µĽ��a,b
	 *	4.a��ʾ���Եĸ���
	 *	5.b��ʾ������λ�ö��Եĸ���
	 *	6.ȫ��������Ϸ��������ʾ�µĴ���
	 *	
	 *	������ѡ����Ϸ�ȼ����򵥣��м������ѣ���ʦ���ֱ��4,6,8,10������
	 *
	 *	δ�������ʦ�����鳤�Ȳ���
	 */
	public static void main(String[] args) {
		Game g = new Game();
		g.show();

	}
	//��������ظ�������
	public int[] create(){
		Random rd = new Random();
		int[] arr = new int[10];
		for(int i = 0; i < arr.length; i++){
			int in = rd.nextInt(10);
			arr[i] = in;
			for(int j = 0; j < i; j++){
				if(arr[j] == in){
					i--;
				}
			}
		}
		return arr;
	}
	
	//����4λ��
	public int[] input(){
		Scanner scan = new Scanner(System.in);
		int[] input = new int[10];
		System.out.println("������0-9֮������֣�");
		int in = scan.nextInt();
		int length = Integer.toString(in).length();
		input = Arrays.copyOf(input, length);
		for(int i = input.length - 1; i >= 0; i--){
			input[i] = in % 10;
			in /= 10;
		}
		return input;
	}
	
	//���Եķ���
	public int check1(int[] arr,int[] input){
		int count = 0;
		for(int i = 0; i < arr.length; i++){
			for(int j = 0; j < input.length; j++){
				if(arr[i] == input[j]){
					count ++ ;
					break;
				}
			}
		}
		return count;
	}
	
	//����λ�ö��Ե�
	public int check2(int[] arr,int[] input){
		int count = 0;
		for(int i = 0; i < arr.length; i++){
			if(arr[i] == input[i]){
				count ++ ;
			}
		}
		return count;
	}
	
	//�Ѷ�����
	int leven = 0;
	public int[] select(){
		System.out.println("��ѡ���Ѷȣ�");
		System.out.println("1.��   2.�м�   3.����    4.��ʦ");
		Scanner scan = new Scanner(System.in);
		int in = scan.nextInt();
		int[] arr = create();
		if(in == 1){
			arr = Arrays.copyOf(arr, 4);
			leven = 4;
		}else if(in == 2){
			arr = Arrays.copyOf(arr, 6);
			leven = 6;
		}else if(in == 3){
			arr = Arrays.copyOf(arr, 8);
			leven = 8;
		}else if(in == 4){
			arr = Arrays.copyOf(arr, 10);
			leven = 10;
		}
		return arr;
	}
	
	public void show(){
		System.out.println("*********��Ϸ��ʼ*********");
		int[] arr = select();
		System.out.println("����������飺" + Arrays.toString(arr));
		int[] input = input();
		System.out.println("����������ǣ�" + Arrays.toString(input));
		int count = 1;
		while(true){
			int a = check1(arr,input);
			int b = check2(arr,input);
			System.out.println(a + "," + b);
			if(b == leven){
				System.out.println("��Ϸ����");
				System.out.println("������" + count + "��");
				break;
			}else{
				input = input();
				count++;
			}
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
