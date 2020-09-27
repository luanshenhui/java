package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;

import chinsoft.core.DataAccessObject;
import chinsoft.entity.Companys;

public class CompanysManager {
	// 查询合作者企业信息
	public Companys getCompanyByCode(String strCode) {
		StringBuffer bufferHQL = new StringBuffer(
				"  FROM Companys where companycode= :Code");
		Query query = DataAccessObject.openSession().createQuery(
				bufferHQL.toString());
		query.setString("Code", strCode);
		Companys companys = (Companys) query.uniqueResult();
		return companys;
	}
	//封装指定数据放入表单发送到指定地址
	public static String packageForm(String strForm,String strURL,String strParamName){
		StringBuffer buffer=new StringBuffer("<form id='myForm' name='myForm' ");
		buffer.append("action='") .append(strURL).append( "' method='post'>");
		buffer.append("<input type='hidden' name='").append(strParamName).append("' value='").append(strForm ).append("'/></form>");
		System.out.println(buffer);
		return buffer.toString();
	}

	// 根据WebSerivce发送数据
	public static String SendToCompanys() {

		return "";
	}

	public List<Companys> findAll() {
		List<Companys> companysList = new ArrayList<Companys>();
		String hql = "from Companys c";
		Query query = DataAccessObject.openSession().createQuery(hql);
		companysList = query.list();
		return companysList;
	}
}
