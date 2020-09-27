package chinsoft.business;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSONObject;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import sun.text.normalizer.CharTrie.FriendAgent;

import centling.entity.FabricPrice;
import chinsoft.core.ConfigHelper;
import chinsoft.core.DataAccessObject;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Errors;
import chinsoft.entity.Fabric;
import chinsoft.entity.FabricVO;
import chinsoft.entity.Member;
import chinsoft.wsdl.IServiceToBxppServiceLocator;

public class FabricManager {

	DataAccessObject dao = new DataAccessObject();
	private String WebService_Erp_Address = Utility.toSafeString(ConfigHelper
			.getContextParam().get("WebService_Erp_Address"));
	private String WebService_NameSpace = Utility.toSafeString(ConfigHelper
			.getContextParam().get("WebService_NameSpace"));
	private String WebService_Bxpp_Address = Utility.toSafeString(ConfigHelper
			.getContextParam().get("WebService_Bxpp_Address"));

	// 查询库存-ERP
	public Double getFabricInventory(String strCode) {
		Double dblResult = 0.0;
		try {
			Object[] params = new Object[] { strCode };
			dblResult = Utility.toSafeDouble(XmlManager.invokeService(
					WebService_Erp_Address, WebService_NameSpace,
					"getFabricStock", params, new Class[] { String.class }));
			dblResult = Utility
					.toSafeDouble(new java.text.DecimalFormat("#.00")
							.format(dblResult));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dblResult;
	}

	// 查询默认面料
	public String getDefaultFabricCode(String strClothingID,Member member) {
		Integer nClothingID = Utility.toSafeInt(strClothingID);
		Integer unitid=member.getBusinessUnit();
		if (CDict.ClothingSuit2PCS.getID().equals(nClothingID)
				|| CDict.ClothingSuit3PCS.getID().equals(nClothingID)
				|| CDict.ClothingShangYi.getID().equals(nClothingID)
				|| CDict.ClothingSuit2PCS_XFMJ.getID().equals(nClothingID)) {
			String fabricCode="";
			//二件套 三件套  上衣
			switch (unitid) {
			case 20137:
				// 青岛红领制衣有限公司
				fabricCode=this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "MTDsuit");
				break;
			case 20138:
				//青岛凯妙服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DDA1379");
				break;
			case 20139:
				//青岛RCMTM制衣有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "MTDsuit");
				break;
			case 20140:
				//青岛瑞璞服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK264A");
				break;
			case 20144:
				//凯妙加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DDA1379");
				break;
			case 20145:
				//大中华区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			case 20146:
				//美洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			case 20147:
				//欧洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			case 20148:
				//电商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DSA061A");
				break;
			case 20149:
				//瑞璞加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DDA1379");
				break;
			default:
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			}
			return fabricCode;
		}
		
		//裤子
		if (CDict.ClothingPants.getID().equals(nClothingID)) {
			String fabricCode ="";
			switch (unitid) {
			case 20137:
				// 青岛红领制衣有限公司
				fabricCode=this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "MTDsuit");
				break;
			case 20138:
				//青岛凯妙服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DDA1379");
				break;
			case 20139:
				//青岛RCMTM制衣有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "MTDsuit");
				break;
			case 20140:
				//青岛瑞璞服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK264A");
				break;
			case 20144:
				//凯妙加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DDA1379");
				break;
			case 20145:
				//大中华区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			case 20146:
				//美洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			case 20147:
				//欧洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			case 20148:
				//电商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DSA061A");
				break;
			case 20149:
				//瑞璞加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DDA1379");
				break;
			default:
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			}
			return fabricCode;
		}
		if (CDict.ClothingChenYi.getID().equals(nClothingID)) {
			String fabricCode ="";
			switch (unitid) {
			case 20137:
				// 青岛红领制衣有限公司
				fabricCode=this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "MTDshirt");
				break;
			case 20138:
				//青岛凯妙服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "SSA303A");
				break;
			case 20139:
				//青岛RCMTM制衣有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "MTDshirt");
				break;
			case 20140:
				//青岛瑞璞服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "SBM017A");
				break;
			case 20144:
				//凯妙加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "SSA303A");
				break;
			case 20145:
				//大中华区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "SAF191A");
				break;
			case 20146:
				//美洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "SAF191A");
				break;
			case 20147:
				//欧洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "SAF191A");
				break;
			case 20148:
				//电商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "SDA041A");
				break;
			case 20149:
				//瑞璞加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "SBM017A");
				break;
			default:
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "SAF191A");
				break;
			}
			return fabricCode;
		}
		//马甲
		if (CDict.ClothingMaJia.getID().equals(nClothingID) || CDict.ClothingSuit2PCS_MJXK.getID().equals(nClothingID)) {
			String fabricCode="";
			switch (unitid) {
			case 20137:
				// 青岛红领制衣有限公司
				fabricCode=this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "MTDsuit");
				break;
			case 20138:
				//青岛凯妙服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DDA1379");
				break;
			case 20139:
				//青岛RCMTM制衣有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "MTDsuit");
				break;
			case 20140:
				//青岛瑞璞服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK264A");
				break;
			case 20144:
				//凯妙加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DDA1379");
				break;
			case 20145:
				//大中华区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			case 20146:
				//美洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			case 20147:
				//欧洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			case 20148:
				//电商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DSA061A");
				break;
			case 20149:
				//瑞璞加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DDA1379");
				break;
			default:
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			}
			return fabricCode;
		}
		
		//大衣
		if (CDict.ClothingDaYi.getID().equals(nClothingID)) {
			String fabricCode="";
			switch (unitid) {
			case 20137:
				// 青岛红领制衣有限公司
				fabricCode=this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			case 20138:
				//青岛凯妙服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			case 20139:
				//青岛RCMTM制衣有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			case 20140:
				//青岛瑞璞服饰股份有限公司
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			case 20144:
				//凯妙加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			case 20145:
				//大中华区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			case 20146:
				//美洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			case 20147:
				//欧洲区
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			case 20148:
				//电商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			case 20149:
				//瑞璞加盟商
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBL513A");
				break;
			default:
				fabricCode = this.defaultFabricCode(CDict.ClothingSuit_CATEGORYID, "DBK053A");
				break;
			}
			return fabricCode;
		}
		String fabricCode = this.defaultFabricCode(CDict.ClothingChenYi_CATEGORYID, "SAK069A");
//		System.out.println("默认的CODE："+fabricCode);
		return fabricCode;
	}

	public String defaultFabricCode(int nCategoryId, String strCode) {
		Fabric defaultFabric = this.getFabricByCode(strCode);
		String fabricCode = "";
		if (Utility.toSafeInt(defaultFabric.getIsStop()) == CDict.YES.getID()) {
			List<Fabric> fabrics = this.getFabricsByCategory(0, 10000,
					nCategoryId);
			Fabric fabric = fabrics.get(0);
			fabricCode = fabric.getCode();
		} else {
			fabricCode = strCode;
		}
		return fabricCode;
	}

	// 预占用操作-ERP
	public String occupyFabric(String strUsername, String strCode,
			String strAmount, String strMemo) {
		String strResult = "";
		try {
			String strState = "N";
			Object[] params = new Object[] { strUsername, strState, strCode,
					strAmount, strMemo };
			Class<?>[] classTypes = new Class<?>[] { String.class,
					String.class, String.class, String.class, String.class };
			strResult = Utility.toSafeString(XmlManager.invokeService(
					WebService_Erp_Address, WebService_NameSpace,
					"doAdvanceAccountFabric", params, classTypes));
			if (strResult.length() > 0) {
				Errors errors = (Errors) XmlManager.doStrXmlToObject(strResult,
						Errors.class);
				strResult = errors.getList().get(0).getContent();
			} else {
				strResult = Utility.RESULT_VALUE_OK;
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		return strResult;
	}

	// 面料特例放行-BXPP
	public String releaseFabric(String strCode, String strOrdenId) {
		String strResult = "";
		try {
			Object[] params = new Object[] { strCode, strOrdenId };
			Class<?>[] classTypes = new Class<?>[] { String.class, String.class };
			strResult = Utility.toSafeString(XmlManager.invokeService(
					WebService_Bxpp_Address, WebService_NameSpace,
					"doFabricDischarged", params, classTypes));
			if (strResult.length() > 0) {
				Errors errors = (Errors) XmlManager.doStrXmlToObject(strResult,
						Errors.class);
				strResult = errors.getList().get(0).getContent();
			} else {
				strResult = Utility.RESULT_VALUE_OK;
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		return strResult;
	}

	// 预占用查询-ERP
	public Object getFabricOccupys(String strUsername) {
		try {
			// strUsername = "K532H014@redcollar.cn";
			Object[] params = new Object[] { strUsername, "N" };
			Class<?>[] classTypes = new Class<?>[] { String.class, String.class };
			return XmlManager.invokeService(WebService_Erp_Address,
					WebService_NameSpace, "getAdvanceAccountFabric", params,
					classTypes);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "NO_DATA";
	}

	// 获取BXPP数据库面料信息-BXPP
	public Object getClientPieceFabric(String strPageIndex, String strPageSize,
			String strKeyword, String strIsValid, String strCategoryID,
			String strArriveDate, String strArrivedateEnd) {
		try {
			String strOrdenPre = CurrentInfo.getCurrentMember().getOrdenPre();
			// Object[] params = new Object[]
			// {strPageIndex,strPageSize,strOrdenPre,strKeyword,strIsValid,strCategoryID,strArriveDate,strArrivedateEnd};
			String result = new IServiceToBxppServiceLocator()
					.getIServiceToBxppPort().getFabrics(strPageIndex,
							strPageSize, strOrdenPre, strKeyword, strIsValid,
							strCategoryID, strArriveDate, strArrivedateEnd);
			// Class<?>[] classTypes=new
			// Class<?>[]{String.class,String.class,String.class,String.class,String.class,String.class,String.class,String.class};
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "NO_DATA";
	}

	@SuppressWarnings("unchecked")
	public List<Fabric> getFabricByKeyword(String strKeyword,
			String strClothingid) {
		List<Fabric> list = new ArrayList<Fabric>();
		try {
			String strCategortid = "";
			if (!"".equals(strClothingid) && strClothingid != null) {
				strCategortid = " and f.CategoryID = :CategoryID ";
			}
			String hql = "FROM Fabric f WHERE (f.Code LIKE ? OR f.Code LIKE ? ) AND f.IsStop = 10051 "
					+ strCategortid + " ORDER BY f.SequenceNo,f.Code";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, strKeyword + "%");
			query.setString(1, Utility.toSafeString(strKeyword).toUpperCase()
					+ "%");
			if (!"".equals(strClothingid) && strClothingid != null) {
				int nCategortid = 8001;
				if ("3000".equals(strClothingid)
						|| "5000".equals(strClothingid)) {
					nCategortid = 8030;
				} else if ("6000".equals(strClothingid)) {
					nCategortid = 8050;
				}
				query.setInteger("CategoryID", nCategortid);
			}
			list = query.list();
			for (Fabric fabric : list) {
				try {
					fabric.setCategoryName(DictManager.getDictNameByID(fabric
							.getCategoryID()));
				} catch (Exception e) {
					LogPrinter.debug(e.getMessage());
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return list;
	}

	/**
	 * 只查 当前登陆用户所在 区域 维护过价格的面料
	 * 
	 * @param strKeyword
	 * @param strClothingid
	 * @param areaid
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Fabric> getFabricByKeyword(String strKeyword,
			String strClothingid, Integer areaid,Integer limit) {
		List<Fabric> list = new ArrayList<Fabric>();
		try {
			String strCategortid = "";
			if (!"".equals(strClothingid) && strClothingid != null) {
				strCategortid = " and f.CategoryID = :CategoryID ";
			}
			String hql = "FROM Fabric f WHERE f.Code in (SELECT fp.FabricCode FROM FabricPrice fp WHERE fp.AreaId = "
					+ areaid
					+ ") AND (f.Code LIKE ? OR f.Code LIKE ? ) AND f.IsStop = 10051 "
					+ strCategortid + " ORDER BY f.SequenceNo,f.Code";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, strKeyword + "%");
			query.setString(1, Utility.toSafeString(strKeyword).toUpperCase()
					+ "%");
			if (!"".equals(strClothingid) && strClothingid != null) {
				int nCategortid = 8001;
				if ("3000".equals(strClothingid)
						|| "5000".equals(strClothingid)) {
					nCategortid = 8030;
				} else if ("6000".equals(strClothingid)) {
					nCategortid = 8050;
				}
				query.setInteger("CategoryID", nCategortid);
			}
			if(null!=limit && !"".equals(limit) && limit>0){
				query.setMaxResults(limit);
			}
			
			list = query.list();
			for (Fabric fabric : list) {
				try {
					fabric.setCategoryName(DictManager.getDictNameByID(fabric
							.getCategoryID()));
				} catch (Exception e) {
					LogPrinter.debug(e.getMessage());
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return list;
	}
	
	/**
	 * 只查 当前登陆用户所在 区域 维护过价格的面料
	 * 
	 * @param strKeyword
	 * @param strClothingid
	 * @param areaid
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Fabric> getFabricByKeyword(int clothingID,String strKeyword,
			String strClothingid, Integer areaid,Integer limit) {
		List<Fabric> list = new ArrayList<Fabric>();
		try {
			String strCategortid = "";
			if (!"".equals(strClothingid) && strClothingid != null) {
				strCategortid = " and f.CategoryID = :CategoryID ";
			}
			String clothID = "";
			if (0 != clothingID && -1 != clothingID) {
				switch (clothingID) {
				case 1:clothID = "f.CategoryID = 8001 and ";break;
				case 2:clothID = "f.CategoryID = 8001 and ";break;
				case 3:clothID = "f.CategoryID = 8001 and ";break;
				case 2000:clothID = "f.CategoryID =  8001 and ";break;
				case 3000:clothID = "f.CategoryID = 8030 and ";break;
				case 4000:clothID = "f.CategoryID = 8001 and ";break;
				case 5000:clothID = "";break;//配件全显示
				case 6000:clothID = "f.CategoryID = 8050 and ";break;
				default:clothID = "f.CategoryID = 8001 and ";break;
				}
			}
			String hql = "FROM Fabric f WHERE "+clothID+" f.Code in (SELECT fp.FabricCode FROM FabricPrice fp WHERE fp.AreaId = "
					+ areaid
					+ ") AND (f.Code LIKE ? OR f.Code LIKE ? ) AND f.IsStop = 10051 "
					+ strCategortid + " ORDER BY f.SequenceNo,f.Code";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, strKeyword + "%");
			query.setString(1, Utility.toSafeString(strKeyword).toUpperCase()
					+ "%");
			if (!"".equals(strClothingid) && strClothingid != null) {
				int nCategortid = 8001;
				if ("3000".equals(strClothingid)
						|| "5000".equals(strClothingid)) {
					nCategortid = 8030;
				} else if ("6000".equals(strClothingid)) {
					nCategortid = 8050;
				}
				query.setInteger("CategoryID", nCategortid);
			}
			if(null!=limit && !"".equals(limit) && limit>0){
				query.setMaxResults(limit);
			}
			
			list = query.list();
			for (Fabric fabric : list) {
				try {
					fabric.setCategoryName(DictManager.getDictNameByID(fabric
							.getCategoryID()));
				} catch (Exception e) {
					LogPrinter.debug(e.getMessage());
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return list;
	}
	
	public List<FabricVO> getFabricByClothingID(int clothingID, Integer areaid) {
		List<FabricVO> fabricList = new ArrayList<FabricVO>();
		List<Fabric> list = new ArrayList<Fabric>();
		try {
			String clothID = "";
			if (0 != clothingID && -1 != clothingID) {
				switch (clothingID) {
				case 3000:clothID = "f.CategoryID = 8030 and ";break;
				case 5000:clothID = "";break;//配件全显示
				case 6000:clothID = "f.CategoryID = 8050 and ";break;
				default:clothID = "f.CategoryID = 8001 and ";break;
				}
			}
			String hql = "FROM Fabric f WHERE "+clothID+" f.Code in (SELECT fp.FabricCode FROM FabricPrice fp " +
					" WHERE fp.AreaId = " + areaid + ") AND f.IsStop = 10051 ORDER BY f.SequenceNo,f.Code";
			Query query = DataAccessObject.openSession().createQuery(hql);
			list = query.list();
			FabricVO vo = null;
			for (Fabric fabric : list) {
				vo = new FabricVO();
				vo.setId(fabric.getID());
				vo.setCode(fabric.getCode());
				vo.setCategoryName(DictManager.getDictNameByID(fabric.getCategoryID()));
				vo.setFabricSupplyCategoryID(fabric.getFabricSupplyCategoryID());
				fabricList.add(vo);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return fabricList;
	}

	private List<Fabric> extendFabric(List<Fabric> list) {
		for (Fabric fabric : list) {
			extendFabric(fabric);
		}
		return list;
	}

	private void extendFabric(Fabric fabric) {
		try {
			fabric.setCategoryName(DictManager.getDictNameByID(fabric
					.getCategoryID()));
			fabric.setFabricSupplyCategoryName(DictManager
					.getDictNameByID(fabric.getFabricSupplyCategoryID()));
			fabric.setColorName(DictManager.getDictNameByID(fabric.getColorID()));
			fabric.setCompositionName(DictManager.getDictNameByID(fabric
					.getCompositionID()));
			fabric.setFlowerName(DictManager.getDictNameByID(fabric
					.getFlowerID()));
			fabric.setSeriesName(DictManager.getDictNameByID(fabric
					.getSeriesID()));
			fabric.setIsStopName(DictManager.getDictNameByID(fabric.getIsStop()));
			
			fabric.setVcolorName(DictManager.getDictNameByID(fabric.getVcolorID()));
			fabric.setVflowerName(DictManager.getDictNameByID(fabric.getVflowerID()));
			fabric.setVcompositionName(DictManager.getDictNameByID(fabric.getVcompositionID()));
		} catch (Exception e) {
			LogPrinter.debug(e.getMessage());
		}
	}

	// 根据服装分类取得"面料"分类
	private Dict getFabricCategoryByClothing(int nClothingID) {
		List<Dict> fabricCategory = getFabricCategory(0);
		for (Dict dict : fabricCategory) {
			if (Utility.contains(dict.getExtension(),
					Utility.toSafeString(nClothingID))) {
				dict.setName(ResourceHelper.getValue("Orden_FabricSelect"));
				return dict;
			}
		}
		return null;
	}

	// 取面料子分类
	public List<Dict> getFabricCategory(int nParentID) {
		List<Dict> list = new ArrayList<Dict>();
		Dict dictParent = DictManager.getDictByID(nParentID);
		if (dictParent != null
				&& dictParent.getParentID().equals(0)
				&& dictParent.getCategoryID().equals(
						CDictCategory.ClothingCategory.getID())) {
			list.add(getFabricCategoryByClothing(nParentID));
		} else {
			list.addAll(DictManager.getDicts(
					CDictCategory.FabricCategory.getID(), nParentID));
		}

		return list;
	}

	// 系列
	public List<Dict> getSeries(int nCategoryID) {
		return getDictsByFlag(nCategoryID, CDict.FabricFlagSeries.getID());
	}

	// 色系
	public List<Dict> getColor(int nCategoryID) {
		return getDictsByFlag(nCategoryID, CDict.FabricFlagColor.getID());
	}

	// 花型
	public List<Dict> getFlower(int nCategoryID) {
		return getDictsByFlag(nCategoryID, CDict.FabricFlagFlower.getID());
	}

	// 成分
	public List<Dict> getComposition(int nCategoryID) {
		return getDictsByFlag(nCategoryID, CDict.FabricFlagComposition.getID());
	}

	// 属性
	public List<Dict> getProperty(int propertyID) {
		List<Dict> dicts = new ArrayList<Dict>();
		String hql = "From Dict t where t.ParentID=:propertyID";
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setInteger("propertyID", propertyID);
		dicts = query.list();
		return dicts;
	}

	// 根据类型标志去字典
	private List<Dict> getDictsByFlag(int nCategoryID, int nFlagID) {
		List<Dict> categorys = getFabricCategory(nCategoryID);
		for (Dict category : categorys) {
			if (Utility.toSafeInt(category.getExtension()) == nFlagID) {
				return getFabricCategory(category.getID());
			}
		}
		return null;
	}

	// 添加&修改面料
	public void saveFabric(Fabric fabric) {
		dao.saveOrUpdate(fabric);
	}

	// 根据ID查询
	public Fabric getFabricByID(int nFabricID) {
		Fabric fabric = (Fabric) dao.getEntityByID(Fabric.class, nFabricID);
		this.extendFabric(fabric);
		return fabric;
	}

	@SuppressWarnings("unchecked")
	public List<Fabric> getFabricsByCategory(int nPageIndex, int nPageSize,
			int nCategoryID) {
		List<Fabric> list = new ArrayList<Fabric>();
		try {
			String hql = "FROM Fabric f WHERE (f.CategoryID = :CategoryID OR f.SeriesID = :CategoryID OR f.ColorID = :CategoryID OR f.FlowerID = :CategoryID OR f.CompositionID=:CategoryID) AND IsStop=:No  ORDER BY f.SequenceNo";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger("CategoryID", nCategoryID);
			query.setInteger("No", CDict.NO.getID());
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			list = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return list;
	}

	/**
	 * 根据服装id和经销商价格维护 查询面料
	 * 
	 * @param nPageIndex
	 * @param nPageSize
	 * @param nCategoryID
	 * @param areaid
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Fabric> getFabricsByCategory(int nPageIndex, int nPageSize,
			int nCategoryID, int areaid) {
		List<Fabric> list = new ArrayList<Fabric>();
		try {
			// String hql =
			// "FROM (select * from fabric t where t.code in (select fb.fabriccode from fabricprice fb where fb.areaid = "
			// + areaid
			// +
			// ")) f WHERE (f.CategoryID = :CategoryID OR f.SeriesID = :CategoryID OR f.ColorID = :CategoryID OR f.FlowerID = :CategoryID OR f.CompositionID=:CategoryID) AND IsStop=:No  ORDER BY f.SequenceNo";
			// Query query = DataAccessObject.openSession().createQuery(hql);
			// query.setInteger("CategoryID", nCategoryID);
			// query.setInteger("No", CDict.NO.getID());

			String sql = "SELECT * FROM (select * from fabric t where t.code in (select fb.fabriccode from fabricprice fb where fb.areaid = "
					+ areaid
					+ ")) f WHERE (f.CategoryID = '"
					+ nCategoryID
					+ "' or f.SeriesID = '"
					+ nCategoryID
					+ "'  or f.ColorID = '"
					+ nCategoryID
					+ "' or f.FlowerID = '"
					+ nCategoryID
					+ "' or f.CompositionID = '" + nCategoryID + "' )";

			String sql2 = "SELECT * FROM Fabric f where exists (select * from fabricprice fp where fp.areaid = '"
					+ areaid
					+ "' and f.code = fp.fabriccode)  and f.IsStop = 10051 and (f.CategoryID = '"
					+ nCategoryID
					+ "' or f.SeriesID = '"
					+ nCategoryID
					+ "'  or f.ColorID = '"
					+ nCategoryID
					+ "' or f.FlowerID = '"
					+ nCategoryID
					+ "' or f.CompositionID = '" + nCategoryID + "' )";
			SQLQuery query = DataAccessObject.openSession()
					.createSQLQuery(sql2);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			query.addEntity(Fabric.class);
			list = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return list;
	}

	public long getFabricsByCategoryCount(int nCategoryID) {
		long count = 0;
		try {
			String hql = "SELECT COUNT(*) FROM Fabric f WHERE f.CategoryID = :CategoryID OR f.SeriesID = :Category OR f.ColorID = :CategoryID OR f.FlowerID = :CategoryID OR f.CompositionID=:CategoryID";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setInteger("CategoryID", nCategoryID);
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return count;
	}

	@SuppressWarnings("unchecked")
	public List<Fabric> getFabrics(int nPageIndex, int nPageSize,
			String strFabricPre, String strKeyword, int nCategoryID,
			int nSupplyCategoryID, Integer areaid) {
		List<Fabric> list = null;
		try {
			SQLQuery query = getFabricsSqlQuery("*", strFabricPre, strKeyword,
					nCategoryID, nSupplyCategoryID, areaid);
			query.addEntity(Fabric.class);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			list = (List<Fabric>) query.list();
			list = this.extendFabric(list);
			
			Member member = CurrentInfo.getCurrentMember();
			int nPriceType = member.getPriceType();
			for (Fabric fabric : list) {//直营店-面料价格-人民币
//				fabric.setPrice(this.getFabricPrice(fabric.getCode(),areaid==null?0:areaid));
				double price = this.getFabricPrice(fabric.getCode(),areaid==null?0:areaid);
				String fabricPrice="";
				if(nPriceType == 20141 && ("10015,10016,10017,10018".contains(member.getGroupID().toString()))){
					if(nCategoryID==8030){
						fabricPrice="<label style='color:#C69B6E;font-weight: bold;'>"+price+"</label>";
					}else{
						fabricPrice="原:<label style='color:#C69B6E;font-weight: bold;'>"+price+"</label>;"+
								"半毛衬:<label style='color:#C69B6E;font-weight: bold;'>"+price*1.3+"</label>;"+
								"全毛衬:<label style='color:#C69B6E;font-weight: bold;'>"+price*1.5+"</label>;"+
								"半(全)毛衬半手工:<label style='color:#C69B6E;font-weight: bold;'>"+price*3.5+"</label>;"+
								"半(全)毛衬全手工:<label style='color:#C69B6E;font-weight: bold;'>"+price*4.0+"</label>";
					}
				}
				
				fabric.setFabricPrice(fabricPrice);
			}
			//加载库存信息 这块特别慢
			for (Fabric fabric : list) {
				fabric.setInventory(this.getFabricInventory(fabric.getCode()));
			}

		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return list;
	}
	public double getFabricPrice(String fabricCode,Integer areaID){
		List<FabricPrice> list = null;
		double fabricPrice=0.0;
		
		String sql = "From FabricPrice f where f.FabricCode=:code and f.AreaId=:areaID)";
		try {
			Query query = DataAccessObject.openSession().createQuery(sql);
			query.setString("code", fabricCode);
			query.setInteger("areaID", areaID);
			list = (List<FabricPrice>) query.list();
			if(list.size()>0){
				fabricPrice=list.get(0).getRmbPrice();
			}
		} catch (HibernateException e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		
		return fabricPrice;
		
	}
	
	/**
	 * 查找服装分类\ 经销商分类的 第一个面料 做为推荐面料
	 * 
	 * @param nCategoryID
	 * @param areaid
	 * @return
	 */
	public Fabric findFirstFabricAsDefault(int nCategoryID,Integer areaid){
		Fabric temp = null;
		
		try {
			String sql = "SELECT * FROM (select * from fabric t where t.code in (select fb.fabriccode from fabricprice fb where fb.areaid = "
					+ areaid + ")) f WHERE f.CategoryID = "+nCategoryID;
			
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(sql).addEntity(Fabric.class);
			temp = (Fabric) query.list().get(0);
		} catch (HibernateException e) {
			temp = null;
			LogPrinter.info("查找经销商面料失败");
		}
		return temp;
	}

	public long getFabricsCount(String strFabricPre, String strKeyword,
			int nCategoryID, int nSupplyCategoryID, Integer areaid) {
		long count = 0;
		try {
			SQLQuery query = this.getFabricsSqlQuery("COUNT(*)", strFabricPre,
					strKeyword, nCategoryID, nSupplyCategoryID, areaid);
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}

	private Query getFabricsQuery(String strChange, String strFabricPre,
			String strKeyword, int nCategoryID, int nSupplyCategoryID,
			Integer areaid) {
		int nKeyword = 0;
		strKeyword = strKeyword.replace("tmpstr", "/%");
		if (!"".equals(strKeyword)) {
			List<Dict> dictAll = DictManager.getDicts(8);
			for (Dict dict : dictAll) {
				if (dict.getName().contains(strKeyword)) {
					Dict dicts = DictManager.getDictByID(dict.getParentID());
					if (dicts.getParentID() == nCategoryID) {
						nKeyword = dict.getID();
					}
				}
			}
		}
		String hql = "SELECT "
				+ strChange
				+ " FROM Fabric f WHERE (f.Code LIKE :Code OR f.ShaZhi LIKE :ShaZhi  AND f.Code LIKE :Pre ";
		if (nKeyword > 0) {
			hql += " OR f.ColorID LIKE :KeyID OR f.FlowerID LIKE :KeyID OR  f.CompositionID LIKE :KeyID)  ";
		} else {
			hql += ")";
		}
		if (nCategoryID != -1) {
			hql += " AND f.CategoryID=:CategoryID ";
		}
		hql += " AND f.FabricSupplyCategoryID = :SupplyCategoryID ORDER BY f.SequenceNo";

		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setString("Code", "%" + strKeyword + "%");
		query.setString("ShaZhi", "%" + strKeyword + "%");
		query.setString("Pre", strFabricPre + "%");
		if (nCategoryID != -1) {
			query.setInteger("CategoryID", nCategoryID);
		}
		if (nKeyword > 0) {
			query.setInteger("KeyID", nKeyword);
		}
		query.setInteger("SupplyCategoryID", nSupplyCategoryID);
		return query;
	}

	private SQLQuery getFabricsSqlQuery(String strChange, String strFabricPre,
			String strKeyword, int nCategoryID, int nSupplyCategoryID,
			Integer areaid) {
		SQLQuery sqlquery = null;
		int nKeyword = 0;
		strKeyword = strKeyword.replace("tmpstr", "/%");
		if (!"".equals(strKeyword)) {
			List<Dict> dictAll = DictManager.getDicts(8);
			for (Dict dict : dictAll) {
				if (dict.getName().contains(strKeyword)) {
					Dict dicts = DictManager.getDictByID(dict.getParentID());
					if (dicts.getParentID() == nCategoryID) {
						nKeyword = dict.getID();
					}
				}
			}
		}
		String areaStr = ""; 
		if (null != areaid && !"".equals(areaid)) {
			areaStr = " exists (select * from fabricprice fp where fp.areaid = '"
					+ areaid + "' and f.code = fp.fabriccode) and";
		}
		String hql = "SELECT "
				+ strChange
				+ " FROM fabric f WHERE " + areaStr +" f.FabricSupplyCategoryID = "
				+ nSupplyCategoryID + "  AND (f.Code LIKE '%" + strKeyword
				+ "%' OR f.ShaZhi LIKE '%" + strKeyword + "%'";
		if (nKeyword > 0) {
			hql += " OR f.ColorID LIKE '%" + nKeyword
					+ "%' OR f.FlowerID LIKE '%" + nKeyword
					+ "%' OR  f.CompositionID LIKE '%" + nKeyword + "%' )  ";
		} else {
			hql += ")";
		}
		if (nCategoryID != -1) {
			hql += " AND f.CategoryID= " + nCategoryID;
		}
		hql += " ORDER BY f.SequenceNo";
		// System.out.println(hql);
		sqlquery = DataAccessObject.openSession().createSQLQuery(hql);
		// sqlquery.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
		// sqlquery.setResultTransformer(Transformers.aliasToBean(Fabric.class));
		return sqlquery;
	}

	// 删除
	public void removeFabricByID(Object nFabricID) {
		dao.remove(Fabric.class, Utility.toSafeInt(nFabricID));
	}

	public String removeFabrics(String removeIDs) {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}

		Transaction transaction = null;
		Session session = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();

			String[] fabricIDs = Utility.getStrArray(removeIDs);
			for (String fabricID : fabricIDs) {
				if (fabricID != null && !"".equals(fabricID)) {
					this.removeFabricByID(session, Utility.toSafeInt(fabricID));
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

	private void removeFabricByID(Session session, int nFabricID) {
		dao.remove(session, Fabric.class, nFabricID);
	}

	// 根据编码查询
	public Fabric getFabricByCode(String strFabricCode) {
		Fabric fabric = (Fabric) dao.getEntityByDual(Fabric.class, "Code",
				strFabricCode);
		this.extendFabric(fabric);
		return fabric;
	}

	/**
	 * 解析JSON串
	 * 
	 * @param obj
	 *            JSON串
	 * @return List<List<String>>
	 */
	public List<List<String>> getFabricCellList(Object obj) {
		List<List<String>> rows = new ArrayList<List<String>>();
		String jsonStr = Utility.toSafeString(obj);
		String data = getjsonVal(jsonStr, "data");
		// 去掉中括号
		data = data.replaceAll("[\\[\\]]", "");
		data = data.replaceAll("},", "}&");
		String[] dataArray = data.split("&");
		if (dataArray != null && dataArray.length > 0) {
			int i = 1;
			for (String str : dataArray) {
				List<String> tempList = new ArrayList<String>();
				// 序号
				tempList.add(i + "");
				// 面料类别
				String ename = getjsonVal(str, "ename");
				tempList.add(ename);
				// 订单号
				String ysddh = getjsonVal(str, "ysddh");
				tempList.add(ysddh);
				// 面料号
				String ecode = getjsonVal(str, "ecode");
				tempList.add(ecode);
				// 面料属性
				String mlwg = getjsonVal(str, "mlwg");
				tempList.add(mlwg);
				// 码单长度
				String mdcd = getjsonVal(str, "mdcd");
				tempList.add(mdcd);
				// 面料长度
				String mlcd = getjsonVal(str, "mlcd");
				tempList.add(mlcd);
				// 面料幅宽
				String mlfk = getjsonVal(str, "mlfk");
				tempList.add(mlfk);
				// 合格否 否0 是1 特例放行2
				String hgf = getjsonVal(str, "hgf");
				tempList.add(hgf);
				// 到料时间
				String dhrq = getjsonVal(str, "dhrq");
				tempList.add(dhrq);
				rows.add(tempList);
				i++;
			}
		}
		return rows;
	}

	/**
	 * 获取json串中指定key的值
	 * 
	 * @param jsonStr
	 *            json串
	 * @param str
	 *            key
	 * @return json的值
	 */
	private String getjsonVal(String jsonStr, String str) {
		String returnStr = "";
		try {
//			System.out.println(jsonStr);
			JSONObject objson = JSONObject.fromObject(jsonStr);
			if (jsonStr.indexOf(str) != -1) {
				returnStr = objson.getString(str);
			}
		} catch (Exception e) {
			LogPrinter
					.error("FabricManager_getjsonVal_error:" + e.getMessage());
			return "";
		}
		return returnStr;
	}

	/**
	 * 根据面料号更新面料价格
	 * 
	 * @param code
	 *            : 面料号
	 * @param rmbPrice
	 *            : 人民币价格
	 * @param dollarPrice
	 *            : 美元价格
	 * @return
	 */
	public String saveFabricPrice(String code, double rmbPrice,
			double dollarPrice) {
		String sql = "UPDATE Fabric SET suitRmbPrice=:price, suitDollarPrice=:dollarPrice WHERE code=:code";

		Session session = null;
		Transaction transaction = null;

		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(sql);
			query.setDouble("price", rmbPrice);
			query.setDouble("dollarPrice", dollarPrice);
			query.setString("code", code);
			query.executeUpdate();
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			if (session != null) {
				session.close();
			}
		}
		return Utility.RESULT_VALUE_OK;
	}

	// 获取已维护面料价格的面料信息
	public List<Fabric> getFabricByUserBusinessUnit(String strClothingid,
			int nUserBusinessUnit) {
		List<Fabric> list = new ArrayList<Fabric>();
		try {
			String hql = "select f FROM Fabric f,FabricPrice p WHERE  f.IsStop = 10051 and f.CategoryID = :CategoryID and f.Code = p.FabricCode and p.AreaId =:AreaId  ORDER BY f.SequenceNo,f.Code";
			Query query = DataAccessObject.openSession().createQuery(hql);
			if (!"".equals(strClothingid) && strClothingid != null) {
				int nCategortid = 8001;
				if ("3000".equals(strClothingid)
						|| "5000".equals(strClothingid)) {
					nCategortid = 8030;
				} else if ("6000".equals(strClothingid)) {
					nCategortid = 8050;
				}
				query.setInteger("CategoryID", nCategortid);
				query.setInteger("AreaId", nUserBusinessUnit);
			}
			list = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return list;
	}

	public static void main(String[] args) {
		Object s = "";
		System.err.println(Utility.toSafeString(s).length());
	}
}