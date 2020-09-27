package test;

import java.util.ArrayList;
import java.util.List;

public class Demo1 {
	public static void main(String[] args) {
		List list = new ArrayList();
		list.add(1);
		list.add("ss");
		
		//实际开发中 你往list必须放的是某一类的对象 不可能会出现放很多中类
		//型的对象  你还想使用集合
		//<>叫泛型  规定集合只能放哪种类型的数据
		List<String> list1 = new ArrayList<String>();
		list1.add("s");
	}
}
