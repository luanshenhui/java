package day01;
/**
 * �쳣��������е�try catch
 * @author Administrator
 *dao  
 */
public class ExceptionDemo {
	public static void main(String[] args) {
		try{
			//����һ���ַ���
			String str = "123,0";
			//����ַ�������
			//������ָ���쳣 NullPointerException
			/**
			 * ����str.length()��仰����ʱ����������ָ���쳣
			 * JVM�ᴴ��һ��NullPointerExceptionʵ����������
			 * �������ϸ��Ϣ�����ʵ���У��������׳���length()
			 * �����⡣֮��JVM����main����֮���Ƿ���try���
			 * ������������д��룬��û�����׳���main������
			 * ���У����Խ�NullPointerExceptionʵ��ͨ������
			 * ����ʽ���ݵ�catchԲ����ָ���Ŀ�ָ���쳣������ȥ
			 * �����
			 */
			System.out.println(str.length());
			
			String[] array = str.split(",");
			
			//����ֵ��ַ���ת��Ϊ����
			int a = Integer.parseInt(array[0]); 
			//�������������±�Խ��
			int b = Integer.parseInt(array[1]);
			
			int c = a/b;//���ֳ�������Ϊ0����ѧ�쳣
			
		}catch(NullPointerException e){
			System.out.println("���ֿ�ָ����!");
//			throw e;//�����׳��쳣
		}catch(ArrayIndexOutOfBoundsException e){
			System.out.println("����������Խ���ˣ�");
		}catch(NumberFormatException e){
			System.out.println("���������ָ�ʽ�쳣!");
		}catch(Exception e){
			/**
			 * �����쳣�ĺ�ϰ�ߣ�Ҫ�����һ��catch�в���
			 * Exception����쳣��
			 */
			System.out.println("��֮�ǳ�����!");
		}
		
		System.out.println("���������");
	}
}


