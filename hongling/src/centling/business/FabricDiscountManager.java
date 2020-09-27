package centling.business;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.hibernate.Query;
import org.hibernate.Session;

import centling.entity.FabricDiscount;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Member;

/**
 * 面料促销活动Manager
 * @author Dirk
 *
 */
public class FabricDiscountManager {
	DataAccessObject dao = new DataAccessObject();

	/**
	 * 根据条件分页查询活动
	 * @param nPageIndex 当前页
	 * @param pageSize 每页显示条数
	 * @param startDate 开始日期
	 * @param endDate 结束日期
	 * @param fabricCode 面料编号
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<FabricDiscount> getFabricDiscounts(int nPageIndex, int pageSize, String startDate, String endDate, String fabricCode) {
		List<FabricDiscount> list = new ArrayList<FabricDiscount>();
		StringBuffer hql = new StringBuffer("");
		hql.append("From FabricDiscount f WHERE f.FabricCode=:fabricCode ");
		if (startDate != null) {
			hql.append(" AND TO_CHAR(f.StartDate,'yyyy-MM-dd') >= :startDate ");
		}
		if (endDate != null) {
			hql.append(" AND TO_CHAR(f.EndDate, 'yyyy-MM-dd') >= :endDate ");
		}
		hql.append(" ORDER BY f.StartDate desc, f.EndDate desc");
		try {
			Query query = DataAccessObject.openSession().createQuery(hql.toString());
			query.setString("fabricCode", fabricCode);
			if (startDate != null) {
				query.setString("startDate", startDate);
			}
			if (endDate != null) {
				query.setString("endDate", endDate);
			}
			query.setFirstResult(nPageIndex * pageSize);
			query.setMaxResults(pageSize);
			list = query.list();
		}  catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}

	/**
	 * 根据条件查询总条数
	 * @param startDate 开始日期
	 * @param endDate 结束日期
	 * @param fabricCode 面料编号
	 * @return
	 */
	public long getFabricDiscountCount(String startDate, String endDate, String fabricCode) {
		long count = 0;
		StringBuffer hql = new StringBuffer("");
		hql.append("SELECT COUNT(*) From FabricDiscount f WHERE f.FabricCode=:fabricCode ");
		if (startDate != null) {
			hql.append(" AND TO_CHAR(f.StartDate,'yyyy-MM-dd') >= :startDate ");
		}
		if (endDate != null) {
			hql.append(" AND TO_CHAR(f.EndDate, 'yyyy-MM-dd') >= :endDate ");
		}
		hql.append(" ORDER BY f.StartDate desc, f.EndDate desc");
		try {
			Query query = DataAccessObject.openSession().createQuery(hql.toString());
			query.setString("fabricCode", fabricCode);
			if (startDate != null) {
				query.setString("startDate", startDate);
			}
			if (endDate != null) {
				query.setString("endDate", endDate);
			}
			count=Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}

	/**
	 * 保存面料打折促销
	 * @param fabricDiscount
	 */
	@SuppressWarnings("deprecation")
	public void save(FabricDiscount fabricDiscount, String memberIds) {
		// 保存面料促销主表信息
		dao.saveOrUpdate(fabricDiscount);
		
		// 保存面料子表信息
		String[] arrMemberId = memberIds.split(",");
		
		Session session = DataAccessObject.openSession();
		Connection conn=session.connection(); 
		String sql = "insert into fabricdiscountdetail(id,fabricdiscountid, memberid) values(?, ?, ?)";
		try {
			PreparedStatement stmt=conn.prepareStatement(sql,ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			for (String memeberId: arrMemberId) {
				stmt.setString(1, UUID.randomUUID().toString());
				stmt.setString(2, fabricDiscount.getID());
				stmt.setString(3, memeberId);
				stmt.addBatch();
			}
			stmt.executeBatch();
			conn.commit();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			try {
				conn.close();
			} catch (SQLException e) {
				LogPrinter.error(e.getMessage());
			}
		}
	}

	/**
	 * 根据主键删除打折促销
	 * @param id
	 */
	public void removeFabricDiscount(String id) {
		// 删除 子表内容
		String hql = "DELETE FROM FabricDiscountDetail f WHERE f.FabricDiscountId=:fabricDiscountId";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("fabricDiscountId", id);
			query.executeUpdate();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		// 删除主表内容
		dao.remove(FabricDiscount.class, id);
	}
	
	/**
	 * 查询当前日期指定用户指定面料是否有打折促销活动
	 * @param fabricCode 面料编号
	 * @param memberId 用户编号
	 * @return 查询到的打折促销实体
	 */
	@SuppressWarnings("unchecked")
	public FabricDiscount getFabricDiscountByMemberAndFabricAndDate(String fabricCode, String memberId) {
		FabricDiscount fabricDiscount = null;
		String sql = "SELECT f.* FROM FabricDiscount f , FabricDiscountDetail fd WHERE f.ID=fd.FabricDiscountId AND MemberId=:memberId " + 
				" AND TO_CHAR(sysdate,'yyyy-MM-dd')>= TO_CHAR(StartDate,'yyyy-MM-dd') " + 
				" AND TO_CHAR(sysdate,'yyyy-MM-dd')<= TO_CHAR(EndDate,'yyyy-MM-dd') " +
				" AND FabricCode=:fabricCode" ;
		try {
			Query query = DataAccessObject.openSession().createSQLQuery(sql).addEntity(FabricDiscount.class);
			query.setString("memberId", memberId);
			query.setString("fabricCode", fabricCode);
			List<FabricDiscount> list = query.list();
			if (list != null && !list.isEmpty()) {
				fabricDiscount = list.get(0);
			}
		} catch (Exception e){
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return fabricDiscount;
	}

	/**
	 * 根据主键获取面料促销信息
	 * @param id
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public FabricDiscount getFabricDiscountById(String id) {
		// 得到面料折扣信息
		FabricDiscount fabricDiscount = (FabricDiscount)DataAccessObject.openSession().get(FabricDiscount.class, id);
		
		// 根据面料编号，查询用户信息
		String sql = "SELECT m.* FROM MEMBER m LEFT JOIN FABRICDISCOUNTDETAIL fd ON m.ID=fd.MEMBERID  WHERE fd.FABRICDISCOUNTID=:fabricDiscountId";
		
		try {
			Query query = DataAccessObject.openSession().createSQLQuery(sql).addEntity(Member.class);
			query.setString("fabricDiscountId", id);
			List<Member> list = query.list();
			StringBuffer users = new StringBuffer("");
			if (list != null && !list.isEmpty()) {
				for (int i=0; i<list.size(); i++) {
					Member member = list.get(i);
					users.append(member.getUsername());
					users.append(",");
					if (i!=0 && i%5==0) {
						users.append("\n");
					}
				}
			}
			String userNames = users.toString().substring(0, users.toString().length()-1);
			fabricDiscount.setUsers(userNames);
		} catch (Exception e){
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return fabricDiscount;
	}
}