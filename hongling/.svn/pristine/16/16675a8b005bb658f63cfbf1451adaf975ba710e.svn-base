package work.business;

import java.util.Map;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import work.bean.BasicBusiness;
import centling.business.FabricDiscountManager;
import centling.business.FabricPriceManager;
import centling.entity.FabricDiscount;
import centling.entity.FabricPrice;
import chinsoft.business.CDict;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Fabricconsume;
import chinsoft.entity.Member;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;

public class OrdersMG {

	/** 根据订单ID 查询状态 **/
	public String getStatusByID(String strOrdenID) {
		String strHQL = "SELECT StatusID FROM Orden WHERE OrdenID=:ordenID";
		Query query = DataAccessObject.openSession().createQuery(strHQL);
		query.setString("ordenID", strOrdenID);
		String status;
		try {
			status = Utility.toSafeString(query.uniqueResult());
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			return "ERROR";
		}
		return status;
	}

	/** 获得配件工艺的价格 **/
	public String doFittingPrice(String strCodes, Integer nIsMaual, OrdenDetail detail) {
		// 得到用户信息
		Member member = CurrentInfo.getCurrentMember();
		// 配件暂时固定20143，要不然取不到配件价格
		Object[] objs = this.getDictPrice(strCodes, 20143, member.getGroupID(), nIsMaual);
		if (objs[0] == null && detail.getSingleClothingID().equals(5000)) {
			// 如果是配件木有收费工艺，说明计价方式有问题
			return ResourceHelper.getValue("Price_Error_1");// "收费工艺价格计算错误，因为系统计算出的价格为0";
		} else if (objs[0] == null) {
			// 如果不是配件木有收费工艺，就不计算收费工艺价格
			detail.setProcessPrice(0.00);
		} else {
			// 正常计算收费工艺价格
			Double dbPrice = 0.00;
			if (member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
				dbPrice = Utility.toSafeDouble(objs[1]);
			} else {
				dbPrice = Utility.toSafeDouble(objs[2]);
			}
			detail.setProcessPrice(dbPrice);
		}
		return Utility.RESULT_VALUE_OK;
	}

	/** 查询收费工工艺明细 **/
	public Object[] getDictPrice(String strCodes, Integer nPricetype, Integer strGroupID, Integer nIsMaual) {
		Object[] objs = new Object[] {};
		StringBuffer strSQL = new StringBuffer("SELECT WM_CONCAT(code) AS CODES, SUM(rmbPrice) AS RMB,SUM(Price) AS DOLLAR FROM Dictprice o WHERE :strCodes LIKE '%'||code||',%' and pricetype = :nPricetype");
		try {
			if (strGroupID != null && strGroupID > 0) {
				strSQL.append(" and groupids like '%").append(strGroupID).append(",%'");
			}
			if (nIsMaual != null && nIsMaual > 0) {
				strSQL.append(" and ismanual !=").append(nIsMaual);
			}
			Query query = DataAccessObject.openSession().createSQLQuery(strSQL.toString());
			query.setString("strCodes", strCodes);
			query.setInteger("nPricetype", nPricetype);
			objs = (Object[]) query.uniqueResult();
			return objs;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}
		return objs;
	}

	/** 获取CMT价格 **/
	public String doCMTPrice(String strLiningCode, OrdenDetail detail, int nSize) {
		// 得到用户信息
		Member member = CurrentInfo.getCurrentMember();
		@SuppressWarnings("unchecked")
		Map<String, String> ctms = BasicBusiness.transStringToMap(member.getCmtPrice());
		Double dbCmtPrice = 0.00;
		if (nSize > 1) {
			if (CDict.ClothingShangYi.getID().equals(detail.getSingleClothingID())) {
				String xkCmt = ctms.get("MXK_" + strLiningCode);
				if (null == xkCmt) {
					xkCmt = ctms.get("MXK_000B");
				}
				if (null == xkCmt) {
					return ResourceHelper.getValue("Price_Error_2");// "西裤的CMT价格没有维护";
				}
				String tCmt = ctms.get(strLiningCode);
				if (null == tCmt) {
					return ResourceHelper.getValue("Price_Error_3");// "套装的CMT价格没有维护";
				}
				java.math.BigDecimal c = new java.math.BigDecimal(tCmt);
				java.math.BigDecimal d = new java.math.BigDecimal(xkCmt);
				dbCmtPrice = c.subtract(d).doubleValue();
			} else if (CDict.ClothingPants.getID().equals(detail.getSingleClothingID())) {
				// 如果是裤子，没有维护手工费用，默认取半毛衬收费
				String xkCmt = ctms.get("MXK_" + strLiningCode);
				if (null == xkCmt) {
					xkCmt = ctms.get("MXK_000B");
				}
				if (null == xkCmt) {
					return ResourceHelper.getValue("Price_Error_4");// "西裤的CMT价格没有维护";
				}
				dbCmtPrice = Utility.toSafeDouble(xkCmt);
			} else {
				// 3件套中马甲的计算方式
				String mjCmt = ctms.get(strLiningCode);
				if (null == mjCmt) {
					return ResourceHelper.getValue("Price_Error_5");// "马甲的CMT价格没有维护";
				}
				dbCmtPrice = Utility.toSafeDouble(mjCmt);
			}
		} else {
			// 单件的计算方式
			String cmt = ctms.get(strLiningCode);
			if (null == cmt) {
				return ResourceHelper.getValue("Price_Error_6");// "当前所选择的产品没有维护CMT价格";
			}
			dbCmtPrice = Utility.toSafeDouble(cmt);
		}

		detail.setCmtPrice(Utility.toSafeDouble(dbCmtPrice));
		return Utility.RESULT_VALUE_OK;
	}

	/** 获得面料价格 **/
	public String doFabricPrice(Orden orden, OrdenDetail detail) {
		if (orden.getClothingID().equals(5000)) {
			// 判断是否是配，如果是配件的话就不用处理直接返回0，因为配件不计算面料费用
			detail.setFabricPrice(0.00);
			return Utility.RESULT_VALUE_OK;
		}
		// 得到用户信息
		Member member = CurrentInfo.getCurrentMember();
		Double dbFabricPrice = 0.00;
		Double discount = 100.0;// 默认为不打折，百分之百
		FabricPriceManager fabricPriceManager = new FabricPriceManager();
		FabricDiscount fabricDiscount = new FabricDiscountManager().getFabricDiscountByMemberAndFabricAndDate(orden.getFabricCode(), member.getID());
		if (null != fabricDiscount) {
			// 查询到有打折活动
			discount = fabricDiscount.getDiscount();
		}
		// 查询该用户经营单位的面料价格
		FabricPrice fabricPrice = fabricPriceManager.getFabricPriceByAreaAndFabric(member.getBusinessUnit(), orden.getFabricCode());
		if (null == fabricPrice) {
			// 如果未查到面料价格说明未维护价格或者是客户自带料
			String strFabricHead = orden.getFabricCode().substring(0, 2);
			if (CDict.FABRIC_HEAD.indexOf(strFabricHead + ",") >= 0) {
				// 如果不是客供成批料
				// if (CDict.CUSTOMER_FABRIC_HEAD.indexOf(strFabricHead+",")<0)
				// {
				// 如果是红领的面料号前缀，说明客服人员没有维护价格
				return ResourceHelper.getValue("Bl_Error_190");// 面料价格未维护
				// }
			}
			detail.setFabricPrice(0.00);
			return Utility.RESULT_VALUE_OK;
		}
		// 美元用户
		if (CDict.MoneySignDollar.getID().equals(member.getMoneySignID())) {
			dbFabricPrice = Utility.toSafeDouble(fabricPrice.getDollarPrice());
			// 人民币用户
		} else {
			dbFabricPrice = Utility.toSafeDouble(fabricPrice.getRmbPrice());
		}
		Double dbSize = 0.00;
		if (orden.getClothingID().equals(1) || orden.getClothingID().equals(2)) {
			// 先取出西裤的单耗
			Fabricconsume xkConsume = fabricPriceManager.getFabricConsume(member.getUsername(), "MXK"); // 客户对应的西裤单耗
			if (null == xkConsume) {
				// 西裤的单耗没有查询到
				return ResourceHelper.getValue("Price_Error_7");// "西裤的面料单耗没有维护";
			}

			// 如果是两件套和三件套
			if (CDict.ClothingShangYi.getID().equals(detail.getSingleClothingID())) {
				// 西装上衣
				Fabricconsume tConsume = fabricPriceManager.getFabricConsume(member.getUsername(), "T"); // 客户对应的一套单耗
				if (null == tConsume) {
					// 套装的单耗没有查询到
					return ResourceHelper.getValue("Price_Error_8");// "套装的面料单耗没有维护";
				}
				java.math.BigDecimal c = new java.math.BigDecimal(String.valueOf(tConsume.getFabricsize()));
				java.math.BigDecimal d = new java.math.BigDecimal(String.valueOf(xkConsume.getFabricsize()));
				dbSize = c.subtract(d).doubleValue();
			} else if (CDict.ClothingPants.getID().equals(detail.getSingleClothingID())) {
				dbSize = xkConsume.getFabricsize();
			} else if (CDict.ClothingMaJia.getID().equals(detail.getSingleClothingID())) {
				Fabricconsume mjConsume = fabricPriceManager.getFabricConsume(member.getUsername(), "MMJ"); // 客户马甲
				if (null == mjConsume) {
					// 套装的单耗没有查询到
					return ResourceHelper.getValue("Price_Error_9");// "马甲的面料单耗没有维护";
				}
				dbSize = mjConsume.getFabricsize();
			}
		} else {
			// 其余的都是单件，但是不包括配件
			Dict dict = DictManager.getDictByID(detail.getSingleClothingID());
			Fabricconsume consume = fabricPriceManager.getFabricConsume(member.getUsername(), dict.getEcode()); // 客户单条的单耗
			if (null == consume) {
				// 单件的明细没有维护单耗
				return ResourceHelper.getValue("Price_Error_10");// "你当前选择的服装分类单耗没有维护";
			}
			dbSize = consume.getFabricsize();
		}

		dbFabricPrice *= dbSize;// 得到当前的面料价格
		dbFabricPrice *= discount; // 是否有折扣
		// 得到折扣后面料价格
		dbFabricPrice /= 100.0;
		detail.setFabricPrice(dbFabricPrice);
		return Utility.RESULT_VALUE_OK;
	}

	/** 根据衬类型获得面料价格 **/
	public String doFabricPrice(Orden orden, OrdenDetail detail, String strLiningCode) {
		if (orden.getClothingID().equals(5000)) {
			// 判断是否是配，如果是配件的话就不用处理直接返回0，因为配件不计算面料费用
			detail.setFabricPrice(0.00);
			return Utility.RESULT_VALUE_OK;
		}
		// 得到用户信息
		Member member = CurrentInfo.getCurrentMember();
		// 用户默认的衬类型
		Double dbFabricPrice = 0.00;
		Double discount = 100.0;// 默认为不打折，百分之百
		FabricDiscount fabricDiscount = new FabricDiscountManager().getFabricDiscountByMemberAndFabricAndDate(orden.getFabricCode(), member.getID());
		if (null != fabricDiscount) {
			// 查询到有打折活动
			discount = fabricDiscount.getDiscount();
		}
		// 查询该用户经营单位的面料价格
		FabricPriceManager fabricPriceManager = new FabricPriceManager();
		FabricPrice fabricPrice = fabricPriceManager.getFabricPriceByAreaAndFabric(member.getBusinessUnit(), orden.getFabricCode());
		if (null == fabricPrice) {
			// 如果未查到面料价格说明未维护价格或者是客户自带料
			String strFabricHead = orden.getFabricCode().substring(0, 2);
			if (CDict.FABRIC_HEAD.indexOf(strFabricHead + ",") >= 0) {
				// 如果是红领的面料号前缀，说明客服人员没有维护价格
				return ResourceHelper.getValue("Bl_Error_190");// 面料价格未维护
			} else {
				detail.setFabricPrice(0.00);
				this.doCMTPrice(strLiningCode, detail, orden.getOrdenDetails().size());
				return Utility.RESULT_VALUE_OK;
			}
		}

		// 美元用户
		if (CDict.MoneySignDollar.getID().equals(member.getMoneySignID())) {
			dbFabricPrice = Utility.toSafeDouble(fabricPrice.getDollarPrice());
			// 人民币用户
		} else {
			dbFabricPrice = Utility.toSafeDouble(fabricPrice.getRmbPrice());
		}

		if (member.getPriceType().equals(20142)) {
			Double dbSize = 0.00;
			// 其余的都是单件，但是不包括配件
			Dict dict = DictManager.getDictByID(detail.getSingleClothingID());
			Fabricconsume consume = fabricPriceManager.getFabricConsume(member.getUsername(), dict.getEcode()); // 客户单条的单耗
			if (null == consume) {
				// 单件的明细没有维护单耗
				return ResourceHelper.getValue("Price_Error_11");// "你当前选择的服装分类零售价折扣没有维护";
			}
			dbSize = consume.getFabricsize();
			dbFabricPrice *= dbSize;// 得到折扣后的面料价格
		}

		if (CDict.ClothingShangYi.getID().equals(detail.getSingleClothingID())) {
			// 上衣
			double i = (double) 2 / (Math.round(3 * 100) / 100.0);
			dbFabricPrice = dbFabricPrice * i;
		} else if (CDict.ClothingPants.getID().equals(detail.getSingleClothingID())) {
			// 西裤
			double i = (double) 1 / (Math.round(3 * 100) / 100.0);
			dbFabricPrice = dbFabricPrice * i;
		} else if (CDict.ClothingMaJia.getID().equals(detail.getSingleClothingID())) {
			// 马甲
			double i = (double) 1 / (Math.round(6 * 100) / 100.0);
			dbFabricPrice = dbFabricPrice * i;
		} else if (CDict.ClothingDaYi.getID().equals(detail.getSingleClothingID())) {
			double i = (double) 9 / (Math.round(10 * 100) / 100.0);
			dbFabricPrice = dbFabricPrice * i;
		}
		// 毛衬类型
		if (!CDict.ClothingChenYi.getID().equals(detail.getSingleClothingID())) {
			if ("000B".equals(strLiningCode)) {
				// 粘合衬工艺：零售价×1.3系数
				dbFabricPrice *= 1.3;
			} else if ("000A".equals(strLiningCode)) {
				// 全毛衬工艺：零售价×1.5系数
				dbFabricPrice *= 1.5;
			} else if ("0BAA".equals(strLiningCode) || "00AA".equals(strLiningCode)) {
				// 半（全）毛衬半手工工艺：零售价×3.5系数
				dbFabricPrice *= 3.5;
			} else if ("0AAA".equals(strLiningCode) || "0AAB".equals(strLiningCode)) {
				// 半（全）毛衬全手工工艺：零售价×4.0系数
				dbFabricPrice *= 4.0;
			}
		} else {
			String tempStr = "," + orden.getComponents() + ",";
			if (tempStr.indexOf(",7190,") >= 0 || tempStr.indexOf(",7191,") >= 0) {
				// 衬衣半手工工艺：零售价×2.0系数
				dbFabricPrice *= 2.0;
			}
		}
		dbFabricPrice *= discount; // 是否有折扣
		// 得到折扣后面料价格
		dbFabricPrice /= 100.0;
		dbFabricPrice = Math.floor(dbFabricPrice);
		detail.setFabricPrice(dbFabricPrice);
		return Utility.RESULT_VALUE_OK;
	}

	// 获得工艺价格
	public Double doProcessPrice(String strCodes, String strUsername) {
		StringBuffer strSQL = new StringBuffer("SELECT SUM(price) FROM Userdictprice up where username=:strUsername and :strCodes like '%'||code||'%'");
		try {
			Query query = DataAccessObject.openSession().createSQLQuery(strSQL.toString());
			query.setString("strCodes", strCodes);
			query.setString("strUsername", strUsername);
			Object obj = query.uniqueResult();
			return Utility.toSafeDouble(obj);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DataAccessObject.closeSession();
		}
		return 0.00;
	}
}
