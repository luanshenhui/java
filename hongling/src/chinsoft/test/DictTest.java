package chinsoft.test;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.DictManager;
import chinsoft.entity.Dict;

public class DictTest extends HttpServlet{
	
	private static final long serialVersionUID = 6140187872634594375L;

		@Override
		protected void service(HttpServletRequest arg0, HttpServletResponse arg1)
			throws ServletException, IOException {
			System.out.println(DictManager.getDicts(2, 1).get(0).getCode()+"vvvvvvv");
			System.out.println(DictManager.getDicts(2).get(1).getCode()+"vvvvvvvvv");
			System.out.println(CDict.YES.getCode());
		}
		//@Test
		public void save() {
			Dict dict=new Dict();
			dict.setCategoryID(2);
			dict.setName("男");
			dict.setExtension("只读的");
			dict.setConstDefine("111111");
			dict.setParentID(1);
			dict.setStatusID(1);
			dict.setID(2);
			dict.setCode("00010002");
			DictManager dictManager=new DictManager();
			dictManager.saveDict(dict);
		}
		//@Test
		public void get() {
			DictManager dictManager=new DictManager();
			System.out.println(dictManager.getDictFromDB(2).getCode());
		}
		//@Test
		public void get2(){
			System.out.println(DictManager.getDictByID(2).getCode());
		}
		 
		//@Test
		public void get3() {
			System.out.println(DictManager.getDicts(2, 1).get(0).getCode()+"vvvvvvv");
			System.out.println(DictManager.getDicts(2).get(1).getCode()+"vvvvvvvvv");
			System.out.println(CDict.YES.getCode());
		}
}
