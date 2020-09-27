package centling.business;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import centling.entity.FabricPrice;
import chinsoft.business.DictManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Fabricconsume;

/**
 * 面料价格Manager
 * 
 * @author Dirk
 * 
 */
public class FabricPriceManager {

	DataAccessObject dao = new DataAccessObject();

	/**
	 * 根据面料编号分页查询面料价格
	 * 
	 * @param nPageIndex
	 *            开始条数
	 * @param pageSize
	 *            每页显示条数
	 * @param fabricCode
	 *            面料编号
	 * @return
	 */
	@SuppressWarnings({ "unchecked" })
	public List<FabricPrice> getFabricPriceList(int nPageIndex, int pageSize,
			String fabricCode) {
		List<FabricPrice> list = new ArrayList<FabricPrice>();
		String hql = "FROM FabricPrice f WHERE FabricCode=:fabricCode";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setFirstResult(nPageIndex * pageSize);
			query.setMaxResults(pageSize);
			query.setString("fabricCode", fabricCode);
			list = query.list();

			// 设置区域名称
			for (FabricPrice fabricPrice : list) {
				fabricPrice.setAreaName(DictManager.getDictNameByID(fabricPrice
						.getAreaId()));
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}

	/**
	 * 根据面料编号查询面料条数
	 * 
	 * @param fabricCode
	 *            面料编号
	 * @return
	 */
	public long getFabricPriceCount(String fabricCode) {
		long count = 0;
		String hql = "SELECT COUNT(*) FROM FabricPrice f WHERE FabricCode=:fabricCode";

		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("fabricCode", fabricCode);
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}

	/**
	 * 保存或更新面料价格
	 * 
	 * @param fabricPrice
	 */
	public void saveOrUpdate(FabricPrice fabricPrice) {
		dao.saveOrUpdate(fabricPrice);
	}

	/**
	 * 根据主键查询面料价格
	 * 
	 * @param strFabricPriceId
	 * @return
	 */
	public FabricPrice getFabricPriceById(String strFabricPriceId) {
		return (FabricPrice) dao.getEntityByID(FabricPrice.class,
				strFabricPriceId);
	}

	/**
	 * 删除指定的面料价格
	 * 
	 * @param removeIDs
	 * @return
	 */
	public String removeFabricPrice(String removeIDs) {
		if ("".equals(removeIDs)) {
			return "请选择待删除项";
		}

		// 得到待删除的面料价格ID
		String[] arrFabricPriceIDs = Utility.getStrArray(removeIDs);

		Transaction transaction = null;
		Session session = null;

		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();

			for (String fabricPriceID : arrFabricPriceIDs) {
				if (fabricPriceID != null && !"".equals(fabricPriceID)) {
					FabricPrice fabricPrice = (FabricPrice) session.load(
							FabricPrice.class, fabricPriceID);
					session.delete(fabricPrice);
				}
			}
			transaction.commit();
			return Utility.RESULT_VALUE_OK;
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		} finally {
			DataAccessObject.closeSession();
		}
	}

	/**
	 * 根据用户所在区域及面料编号查询面料价格
	 * 
	 * @param businessUnit
	 *            用户经营单位
	 * @param fabricCode
	 *            面料编号
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public FabricPrice getFabricPriceByAreaAndFabric(Integer businessUnit,
			String fabricCode) {
		FabricPrice fabricPrice = null;
		String hql = "FROM FabricPrice f WHERE f.AreaId=:areaId AND f.FabricCode=:fabricCode";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger("areaId", businessUnit);
			query.setString("fabricCode", fabricCode);
			List<FabricPrice> list = query.list();
			if (list != null && !list.isEmpty()) {
				fabricPrice = list.get(0);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return fabricPrice;
	}

	/**
	 * 根据用户和服装分类获得用户单耗
	 * 
	 * @param strUsername
	 *            客户
	 * @param strSort
	 *            服装分类
	 * @return
	 */
	public Fabricconsume getFabricConsume(String strUsername, String strSort) {
		Fabricconsume fabricconsume = null;
		String hql = " FROM Fabricconsume fc where fc.username=:strUsername and sort=:strSort";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("strUsername", strUsername);
			query.setString("strSort", strSort);
			@SuppressWarnings("unchecked")
			List<Fabricconsume> list = query.list();
			if (list != null && !list.isEmpty()) {
				fabricconsume = list.get(0);
			}
		} catch (Exception e) {
			// TODO: handle exception
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return fabricconsume;
	}

	public List<FabricPrice> findFabricPriceByCode(String code) {
		List<FabricPrice> tempList = new ArrayList<FabricPrice>();
		String hql = "FROM FabricPrice fp where fp.FabricCode = '" + code + "'";

		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			tempList = query.list();
		} catch (HibernateException e) {
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}
		return tempList;
	}

}