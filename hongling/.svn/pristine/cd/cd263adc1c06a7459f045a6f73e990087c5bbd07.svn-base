package hongling.business;

import hongling.entity.StyleProcess;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;

public class StyleProcessManager {
	DataAccessObject dao = new DataAccessObject();

	/**
	 * 批量保存
	 * 
	 * @param assembles
	 */
	public void saveStyleProcessList(List<StyleProcess> styleProcess) {

		Session session = DataAccessObject.openSession();
		Transaction tx = session.beginTransaction();
		try {
			for (int i = 0; i < styleProcess.size(); i++) {
				session.saveOrUpdate(styleProcess.get(i));
				if (i % 20 == 0) {
					// 20，与JDBC批量设置相同
					// 将本批插入的对象立即写入数据库并释放内存
					session.flush();
					session.clear();
				}
			}

		} catch (HibernateException e) {
			tx.rollback();
			e.printStackTrace();
		}
		tx.commit();
		session.close();
	}
	/**
	 * 验证code唯一性
	 * 
	 * @param code
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public int validateCode(String code) {
		int temp = 0;
		List<StyleProcess> tempList = new ArrayList<StyleProcess>();
		try {
			Query query = DataAccessObject.openSession().createQuery(
					"from StyleProcess av where av.styleCode = '"
							+ code + "'");
			tempList = query.list();
			if (!tempList.isEmpty()) {
				temp = tempList.size();
			}
		} catch (HibernateException e) {
			// e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return temp;
	}
	//根据款式号和面料号查询订单
	public StyleProcess getStyleProcessByCode(String strCode,String strFabric) {
		List<StyleProcess> tempList = new ArrayList<StyleProcess>();
		StyleProcess styleProcess = new StyleProcess();
		String hql = "from StyleProcess sp where sp.styleCode =:styleCode and sp.fabricCode =:fabricCode";
		try {
			Query query = (Query) DataAccessObject.openSession().createQuery(hql);
			query.setString("styleCode", strCode);
			query.setString("fabricCode", strFabric);
			tempList = query.list();
			if(tempList.size()>0){
				styleProcess = tempList.get(0);
			}
			
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return styleProcess;
	}

}
