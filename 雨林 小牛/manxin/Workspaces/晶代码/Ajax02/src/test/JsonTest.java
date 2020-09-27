package test;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import bean.Stock;

public class JsonTest {
	/*
	 *{"code":"600015","name":"山东高速","price":10}
	 *
	 */
	public static void test1(){
		Stock s = new Stock();
		s.setCode("600015");
		s.setName("山东高速");
		s.setPrice(10);
		JSONObject jsonObj = 
			JSONObject.fromObject(s);
		String jsonStr = jsonObj.toString();
		System.out.println(jsonStr);
	}
	
	/*
	 * [{"code":"600010","name":"山东高速","price":10},
	 * {"code":"600011","name":"山东高速1","price":10},
	 * {"code":"600012","name":"山东高速2","price":10}]
	 */
	public static void test2(){
		List<Stock> stocks = 
			new ArrayList<Stock>();
		for(int i=0;i<3;i++){
			Stock s = new Stock();
			s.setCode("60001"+i);
			s.setName("山东高速" + i);
			s.setPrice(10);
			stocks.add(s);
		}
		JSONArray jsonArr = 
			JSONArray.fromObject(stocks);
		String jsonStr = jsonArr.toString();
		System.out.println(jsonArr);
	}
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		test2();
	}

}
