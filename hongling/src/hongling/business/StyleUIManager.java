package hongling.business;

import hongling.entity.Assemble;
import hongling.entity.KitStyle;
import java.util.ArrayList;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;

import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;

public class StyleUIManager {
	DataAccessObject dao = new DataAccessObject();
	
	//根据clothingID获取全部款式组合信息
	/*public List<Assemble> getAllAssemblesByClothingID(String strClothingID,String styleID,String strStyle) {
		List<Assemble> tempList = new ArrayList<Assemble>();
		String[] style = Utility.getStrArray(styleID);
		String hql = "from Assemble ab where ab.status='1' ";
		if(!"".equals(strClothingID)){
			hql += " and ab.clothingID=:clothingID ";
		}
		if(!"".equals(styleID)){
			hql += " and ab.styleID=:styleID ";
		}
		if(!"".equals(strStyle)){
			hql += " and ab.ID=:ID ";
		}
		hql += " ORDER BY ab.createTime desc";
		try {
			Query query = (Query) DataAccessObject.openSession().createQuery(hql);
			if(!"".equals(strClothingID)){
				query.setInteger("clothingID", Utility.toSafeInt(strClothingID));
			}
			if(!"".equals(styleID)){
				query.setInteger("styleID", Utility.toSafeInt(styleID));
			}
			if(!"".equals(strStyle) && style.length ==1){
				query.setString("ID", strStyle);
			}
			tempList = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return tempList;
	}*/
	
	//根据clothingID获取全部款式组合信息(包括试用面料)
		public List<Assemble> getAllStyleByClothingID(String strClothingID,String styleID,String strStyle) {
			List<Object[]> tempList = new ArrayList<Object[]>();
			List<Assemble> assembles = new ArrayList<Assemble>(); 
			String[] style = Utility.getStrArray(styleID);
			String hql = "select ab.clothingID,ab.styleID,sp.styleCode,sp.fabricCode,sp.process,sp.specialProcess,ab.brands,ab.TITLE_CN,ab.TITLE_EN from STYLE ab inner join StyleProcess sp on (ab.code=sp.styleCode) where ab.status='1' ";
			if(!"".equals(strClothingID)){
				hql += " and ab.clothingID=:clothingID ";
			}
			if(!"".equals(styleID)){
				hql += " and ab.styleID=:styleID ";
			}
			if(!"".equals(strStyle)){
				hql += " and sp.styleCode=:styleCode ";
			}
			hql += " ORDER BY sp.styleCode,ab.createTime desc";
			try {
				SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
				if(!"".equals(strClothingID)){
					query.setInteger("clothingID", Utility.toSafeInt(strClothingID));
				}
				if(!"".equals(styleID)){
					query.setInteger("styleID", Utility.toSafeInt(styleID));
				}
				if(!"".equals(strStyle) && style.length ==1){
					query.setString("styleCode", strStyle);
				}
				tempList = query.list();
				if(tempList.size()>0){
					for (int i=0; i<tempList.size(); i++){
						Object[] obj = tempList.get(i);
						Assemble assemble = new Assemble();
						assemble.setClothingID(Utility.toSafeInt(obj[0]));
						assemble.setStyleID(Utility.toSafeInt(obj[1]));
						assemble.setCode(Utility.toSafeString(obj[2]));
						assemble.setDefaultFabric(Utility.toSafeString(obj[3]));
						assemble.setProcess(obj[4]==null?"":Utility.toSafeString(obj[4]));
						assemble.setSpecialProcess(obj[5]==null?"":Utility.toSafeString(obj[5]));
						assemble.setBrands(obj[6]==null?"":Utility.toSafeString(obj[6]));
						assemble.setTitleCn(obj[7]==null?"":Utility.toSafeString(obj[7]));
						assemble.setTitleEn(obj[8]==null?"":Utility.toSafeString(obj[8]));
						assembles.add(assemble);
					}
				}
			} catch (HibernateException e) {
				LogPrinter.error(e.getMessage());
			} finally {
				DataAccessObject.closeSession();
			}
			return assembles;
		}
	
	//获取全部套装款式组合信息
	public List<KitStyle> getAllKitStylesByClothingID(String strClothingID,String strStyle,String strStyleID) {
		List<KitStyle> kitStyles = new ArrayList<KitStyle>();
		String hql = "from KitStyle k where k.status='1' and k.clothingID=:clothingID ";
		if(!"".equals(strStyle)){
			hql += " and k.ID=:ID ";
		}
		if(!"".equals(strStyleID)){
			hql += " and k.styleID=:styleID ";
		}
		hql +=" ORDER BY k.createTime desc";
		try {
			Query query = (Query) DataAccessObject.openSession().createQuery(hql);
			query.setInteger("clothingID", Utility.toSafeInt(strClothingID));
			if(!"".equals(strStyle)){
				query.setString("ID", strStyle);
			}
			if(!"".equals(strStyleID)){
				query.setInteger("styleID", Utility.toSafeInt(strStyleID));
			}
			kitStyles = query.list();
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return kitStyles;
	}
	
	/*public Assemble getAssembleByCode(String strCode) {
		List<Assemble> tempList = new ArrayList<Assemble>();
		Assemble assemble = new Assemble();
		String hql = "from Assemble ab where ab.status='1' and ab.code =:code ORDER BY ab.createTime desc";
		try {
			Query query = (Query) DataAccessObject.openSession().createQuery(hql);
			query.setString("code", strCode);
			tempList = query.list();
			assemble = tempList.get(0);
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return assemble;
	}*/
	
	/*
	 * 根据款式号和面料号查询
	 */
	public Assemble getStyleByCode(String strCode,String strFabric) {
		List<Object[]> tempList = new ArrayList<Object[]>();
		Assemble assemble = new Assemble();
		String hql = "select ab.clothingID,ab.styleID,sp.styleCode,sp.fabricCode,sp.process,sp.specialProcess,ab.brands,ab.TITLE_CN,ab.TITLE_EN from STYLE ab inner join StyleProcess sp on (ab.code=sp.styleCode) where ab.status='1' and ab.code =:code and sp.fabricCode =:fabricCode";
		try {
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
			query.setString("code", strCode);
			query.setString("fabricCode", strFabric);
			tempList = query.list();
			if(tempList.size() >0){
				Object[] obj = tempList.get(0);
				assemble.setClothingID(Utility.toSafeInt(obj[0]));
				assemble.setStyleID(Utility.toSafeInt(obj[1]));
				assemble.setCode(Utility.toSafeString(obj[2]));
				assemble.setDefaultFabric(Utility.toSafeString(obj[3]));
				assemble.setProcess(obj[4]==null?"":Utility.toSafeString(obj[4]));
				assemble.setSpecialProcess(obj[5]==null?"":Utility.toSafeString(obj[5]));
				assemble.setBrands(obj[6]==null?"":Utility.toSafeString(obj[6]));
				assemble.setTitleCn(obj[7]==null?"":Utility.toSafeString(obj[7]));
				assemble.setTitleEn(obj[8]==null?"":Utility.toSafeString(obj[8]));
				String str = "";
				str = assemble.getSpecialProcess();
				if(!"".equals(str)){
					str = new AssembleManager().parseSpecialProcess(str);
					assemble.setSpecialProcess(str);
				}
			}
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return assemble;
	}
}
