package day02;
/**
 * String���Խ�����������ʽ�Ĳ����滻Ϊָ������
 * @author Administrator
 *345678910111213
 */
public class replaceAll {
	public static void main(String[] args) {
		/**
		 * �ַ������������ĸ�������ʽ
		 */
		String str = "0123ABSD343423JHFJD34446NSD998SDAKSH";
		/**
		 * �����ֲ����滻Ϊ��#NUMBER#
		 */
		String[] info = {"NND","SB","TMD","TNND","CNM"};
		String rex = "(";
		for(int i =0;i<info.length-1;i++){
			rex += info[i]+"|";
		}
		
		rex += ( info[info.length-1] + ")");
		System.out.println(rex);
		str="NND����װ���ֱ�����,�Ǹ�SB�ų���";
		
		str = str.replaceAll(rex, "***");
		System.out.println(str);
		
	}
}








