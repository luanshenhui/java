package day02;
/**
 * String可以将满足正则表达式的部分替换为指定内容
 * @author Administrator
 *345678910111213
 */
public class replaceAll {
	public static void main(String[] args) {
		/**
		 * 字符串是数组和字母穿插的形式
		 */
		String str = "0123ABSD343423JHFJD34446NSD998SDAKSH";
		/**
		 * 将数字部分替换为：#NUMBER#
		 */
		String[] info = {"NND","SB","TMD","TNND","CNM"};
		String rex = "(";
		for(int i =0;i<info.length-1;i++){
			rex += info[i]+"|";
		}
		
		rex += ( info[info.length-1] + ")");
		System.out.println(rex);
		str="NND今天装备又被黑了,那个SB团长！";
		
		str = str.replaceAll(rex, "***");
		System.out.println(str);
		
	}
}








