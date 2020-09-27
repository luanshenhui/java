package chinsoft.business;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.rmi.RemoteException;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.QName;
import javax.xml.rpc.ServiceException;

import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.rpc.client.RPCServiceClient;
import org.apache.commons.lang.StringUtils;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import org.hibernate.transform.Transformers;

import work.business.OrdersMG;

import centling.business.BlDealManager;
import centling.business.BlMemberManager;
import centling.business.CDealItem;
import centling.business.Constant;
import centling.business.FabricDiscountManager;
import centling.business.FabricPriceManager;
import centling.entity.Deal;
import centling.entity.FabricDiscount;
import centling.entity.FabricPrice;
import chinsoft.core.ConfigHelper;
import chinsoft.core.DataAccessObject;
import chinsoft.core.DateHelper;
import chinsoft.core.EntityHelper;
import chinsoft.core.HttpContext;
import chinsoft.core.LogPrinter;
import chinsoft.core.ResourceHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Cash;
import chinsoft.entity.CurableStyle;
import chinsoft.entity.Customer;
import chinsoft.entity.Dict;
import chinsoft.entity.Dictprice;
import chinsoft.entity.Embroidery;
import chinsoft.entity.ErrorMessage;
import chinsoft.entity.Errors;
import chinsoft.entity.Fabric;
import chinsoft.entity.Fabricconsume;
import chinsoft.entity.Member;
import chinsoft.entity.Message;
import chinsoft.entity.Orden;
import chinsoft.entity.OrdenDetail;
import chinsoft.entity.SizeStandard;
import chinsoft.entity.Userdictprice;

public class OrdenManager {

	DataAccessObject	dao						= new DataAccessObject();
	private String		Orden_Head				= Utility.toSafeString(ConfigHelper.getContextParam().get("Orden_Head"));
	private String		WebService_Bxpp_Address	= Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_Bxpp_Address"));
	private String		WebService_NameSpace	= Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_NameSpace"));

	public static Object invokeService(String strAddress, String strNameSpace, String strMethodName, Object[] params, Class<?>[] classTypes) throws ServiceException, RemoteException {
		EndpointReference targetEPR = new EndpointReference(strAddress);
		RPCServiceClient serviceClient = new RPCServiceClient();
		Options options = serviceClient.getOptions();
		options.setTo(targetEPR);
		QName opAddEntry = new QName(strNameSpace, strMethodName);
		return serviceClient.invokeBlocking(opAddEntry, params, classTypes)[0];
	}

	public void setPrice(Orden orden) {
		String result = Utility.RESULT_VALUE_OK;
		// 默认半毛衬
		// String interliningType = CDict.InterliningType;

		// 得到订单所有工艺
		// String[] components = orden.getComponents().split(",");

		// 得到面料信息
		Fabric fabric = new FabricManager().getFabricByCode(orden.getFabricCode());

		// 得到用户信息
		Member member = CurrentInfo.getCurrentMember();
		String interliningType = member.getLiningType();// 默认毛衬类型
		int clothingID = orden.getClothingID();//女装毛衬类型默认00C3
		if(clothingID == 7 || clothingID == 95000 || clothingID == 98000){
			interliningType ="00C3";
		}

		// 得到用户的经营单位
		// 红领/凯妙/瑞璞
		Integer businessUnit = member.getBusinessUnit();
		// 获得pricetype，用于传入工艺费用计算的方法
		Integer pricetype = member.getPriceType();

		// 遍历订单明细，设置订单明细价格
		for (OrdenDetail detail : orden.getOrdenDetails()) {

			// 得到订单明细种类
			// 上衣/西裤/衬衣/马甲/配件/大衣
			Integer singleClothingId = detail.getSingleClothingID();

			// 凯妙用户
			if (CDict.BRAND_KAIMIAO.getID().equals(businessUnit)) {
				if (detail.getSingleClothingID().equals(5000)) {
					OrdersMG mg = new OrdersMG();
					List<Dict> ordersProcessList = new ClothingManager().getOrderProcess(orden, detail.getSingleClothingID());
					Dict dictClothing = DictManager.getDictByID(detail.getSingleClothingID());// 服装分类
					String strCodes = new XmlManager().getDictEcodes(dictClothing, ordersProcessList, orden, false);
					result = mg.doFittingPrice(strCodes, null, detail);
					if (!result.equals("OK")) {
						// 有异常
						throw new RuntimeException(result);
					}
				} else {
					// 设置加工费
					detail.setCmtPrice(0.0);
					// 设置工艺价格
					detail.setProcessPrice(0.0);
					// 设置面料价格
					// 根据面料、用户、服装种类、货币类型计算面料价格
					double price = 0.00;
					if (fabric != null) {
						price = getFabricPrice(fabric, member, singleClothingId);
					}
					// 判断是否是国内加盟商
					if (CDict.DOMESTIC_FRANCHISESS.getID().equals(member.getPriceType())) {
						price = price * member.getRetailDiscountRate() / 100;
					}
					// 2013年5月14日 14:42:31 保留到 个位
					price = Utility.toSafeDouble(Math.round(price));
					detail.setFabricPrice(price);
				}
				// 红领用户或瑞璞用户
			} else if (CDict.BRAND_HONGLING.getID().equals(businessUnit) || CDict.BRAND_RUIPU.getID().equals(businessUnit)) {

				if (detail.getSingleClothingID().equals(5000)) {
					OrdersMG mg = new OrdersMG();
					List<Dict> ordersProcessList = new ClothingManager().getOrderProcess(orden, detail.getSingleClothingID());
					Dict dictClothing = DictManager.getDictByID(detail.getSingleClothingID());// 服装分类
					String strCodes = new XmlManager().getDictEcodes(dictClothing, ordersProcessList, orden, false);
					result = mg.doFittingPrice(strCodes, null, detail);
					if (!result.equals("OK")) {
						// 有异常
						throw new RuntimeException(result);
					}
				} else {
					String[] componentPrices = null;
					String strCmtPrice = CurrentInfo.getCurrentMember().getCmtPrice();
					if (StringUtils.isNotEmpty(strCmtPrice)) {
						componentPrices = Utility.getStrArray(strCmtPrice);
					}
					List<Dict> singleComponents = new ClothingManager().getSingleComponents(orden.getComponents(), detail.getSingleClothingID());
					if (singleComponents != null && singleComponents.size() > 0) {
						// 选择的衬判断
						if (componentPrices != null) {
							for (String componentPrice : componentPrices) {
								String[] parts = componentPrice.split(":");
								if (parts.length == 2) {
									for (Dict component : singleComponents) {
										if (Utility.toSafeString(component.getID()).equals(parts[0])) {
											detail.setCmtPrice(Utility.toSafeDouble(parts[1]));
										}
									}
								}
							}
						}
						// 工艺价格
						for (Dict component : singleComponents) {
							if (component.getPrice() != null && Utility.toSafeDouble(component.getPrice()) > 0) {
								Double price = Utility.toSafeDouble(component.getPrice());
								if (CDict.MoneySignDollar.getID().equals(CurrentInfo.getCurrentMember().getMoneySignID())) {
									price = Utility.toSafeDouble(component.getDollarPrice());
								}
								detail.setProcessPrice(Utility.toSafeDouble(detail.getProcessPrice()) + price);
							}
						}
					}

					if (detail.getCmtPrice() == null && componentPrices != null) {
						// 默认来判断
						Integer nKey = getDefaultCmtPriceKey(detail.getSingleClothingID());
						for (String componentPrice : componentPrices) {
							String[] parts = componentPrice.split(":");
							if (parts.length == 2) {
								if (Utility.toSafeString(nKey).equals(parts[0])) {
									detail.setCmtPrice(Utility.toSafeDouble(parts[1]));
								}
							}
						}
					}
					// 面料价格
					Dict clothing = DictManager.getDictByID(detail.getSingleClothingID());
					if (clothing != null && Utility.toSafeDouble(clothing.getOccupyFabric()) > 0) {
						fabric = new FabricManager().getFabricByCode(orden.getFabricCode());
						if (fabric != null) {
							Double price = Utility.toSafeDouble(fabric.getPrice());
							if (CDict.MoneySignDollar.getID().equals(CurrentInfo.getCurrentMember().getMoneySignID())) {
								price = Utility.toSafeDouble(fabric.getDollarPrice());
							}
							detail.setFabricPrice(Utility.toSafeDouble(clothing.getOccupyFabric()) * price);
						}
					}

					// 价格null改成0
					if (detail.getCmtPrice() == null) {
						detail.setCmtPrice(0.0);
					}
					if (detail.getFabricPrice() == null) {
						detail.setFabricPrice(0.0);
					}
					if (detail.getProcessPrice() == null) {
						detail.setProcessPrice(0.0);
					}
				}
			} else if (CDict.BRAND_RUIPU_JIAMENG.getID().equals(businessUnit)) {
				// 瑞璞加盟商 国内加盟商
				// 面料价格
				if (detail.getSingleClothingID().equals(5000)) {
					OrdersMG mg = new OrdersMG();
					List<Dict> ordersProcessList = new ClothingManager().getOrderProcess(orden, detail.getSingleClothingID());
					Dict dictClothing = DictManager.getDictByID(detail.getSingleClothingID());// 服装分类
					String strCodes = new XmlManager().getDictEcodes(dictClothing, ordersProcessList, orden, false);
					result = mg.doFittingPrice(strCodes, null, detail);
					if (!result.equals("OK")) {
						// 有异常
						throw new RuntimeException(result);
					}
				} else {
					if (fabric != null) {
						double dFabricPrice = this.getOrderDetailFabricPrice(fabric, member, orden.getOrdenDetails().size(), singleClothingId);
						if (orden.getOrdenDetails().size() > 1) {
							if (CDict.ClothingShangYi.getID().equals(singleClothingId)) {
								// 上衣
								double i = (double) 2 / (Math.round(3 * 100) / 100.0);
								dFabricPrice = dFabricPrice * i;
							} else if (CDict.ClothingPants.getID().equals(singleClothingId)) {
								// 西裤
								double i = (double) 1 / (Math.round(3 * 100) / 100.0);
								dFabricPrice = dFabricPrice * i;
							} else if (CDict.ClothingMaJia.getID().equals(singleClothingId)) {
								// 马甲
								double i = (double) 1 / (Math.round(6 * 100) / 100.0);
								dFabricPrice = dFabricPrice * i;
							}
						} else {
							if (CDict.ClothingShangYi.getID().equals(singleClothingId)) {
								// 上衣
								double i = (double) 2 / (Math.round(3 * 100) / 100.0);
								dFabricPrice = dFabricPrice * i;
							} else if (CDict.ClothingPants.getID().equals(singleClothingId)) {
								// 西裤
								interliningType = "00C1";
								double i = (double) 1 / (Math.round(3 * 100) / 100.0);
								dFabricPrice = dFabricPrice * i;
							} else if (CDict.ClothingMaJia.getID().equals(singleClothingId)) {
								// 马甲
								double i = (double) 1 / (Math.round(6 * 100) / 100.0);
								dFabricPrice = dFabricPrice * i;
							} else if (CDict.ClothingDaYi.getID().equals(singleClothingId)) {
								double i = (double) 9 / (Math.round(10 * 100) / 100.0);
								dFabricPrice = dFabricPrice * i;
							}
						}
						// 毛衬类型
						String strEcode = new XmlManager().getInterliningType(detail.getSingleClothingID(), orden.getComponents());
						if (!"".equals(strEcode) && !",".equals(strEcode)) {
							strEcode = strEcode.substring(1, strEcode.length() - 1);
							strEcode = strEcode.split(",")[0];
							interliningType = strEcode;
						}
						if (!CDict.ClothingChenYi.getID().equals(detail.getSingleClothingID())) {
							strEcode = interliningType;
							if ("000B".equals(strEcode)) {
								// 半毛衬 样衣\MTM折扣x1.2
								dFabricPrice *= 1.2;

							} else if ("000A".equals(strEcode)) {
								// 全毛衬 样衣\MTM折扣x1.3
								dFabricPrice *= 1.3;
							} else if ("0BAA".equals(strEcode)) {
								// 半毛衬半手工 样衣\MTM折扣x1.4
								dFabricPrice *= 1.4;
							} else if ("0AAA".equals(strEcode)) {
								// 全手工全毛衬 样衣\MTM折扣x2
								dFabricPrice *= 2;
							}

						}
						dFabricPrice /= 1.0;
						dFabricPrice = Math.floor(dFabricPrice);
						dFabricPrice *= 1.0;
						detail.setFabricPrice(dFabricPrice);
					}
					detail.setProcessPrice(0.0);// 工艺收费价格
					detail.setCmtPrice(0.0);// CMT 价格
				}

			} else if (businessUnit.equals(20150)) {
				// 零售
				OrdersMG mg = new OrdersMG();
				List<Dict> ordersProcessList = new ClothingManager().getOrderProcess(orden, detail.getSingleClothingID());
				Dict dictClothing = DictManager.getDictByID(detail.getSingleClothingID());// 服装分类
				String strCodes = new XmlManager().getDictEcodes(dictClothing, ordersProcessList, orden, false);
				if (detail.getSingleClothingID().equals(5000)) {
					result = mg.doFittingPrice(strCodes, null, detail);
					if (!result.equals("OK")) {
						// 有异常
						throw new RuntimeException(result);
					}
				} else {
					// 毛衬类型
					detail.setProcessPrice(mg.doProcessPrice(strCodes, member.getUsername()));
					String strEcode = new XmlManager().getInterliningType(detail.getSingleClothingID(), orden.getComponents());
					String tempCode = DictManager.getDictByID(detail.getSingleClothingID()).getEcode();
					if (!"".equals(strEcode) && !",".equals(strEcode)) {
						strEcode = strEcode.substring(1, strEcode.length() - 1);
						strEcode = strEcode.split(",")[0];
						interliningType = strEcode;
					}
					strEcode = interliningType;
					if (orden.getOrdenDetails().size() == 1) {
						if (CDict.ClothingChenYi.getID().equals(detail.getSingleClothingID())) {
							strEcode = "MCY";// 标准价格
						} else {
							strEcode = (tempCode + "_" + strEcode);
						}
					} else if (CDict.ClothingMaJia.getID().equals(detail.getSingleClothingID())) {
						strEcode = tempCode + "_" + strEcode;// 马甲处理
					}
					result = mg.doFabricPrice(orden, detail, strEcode);
					if (!result.equals("OK")) {
						// 有异常
						throw new RuntimeException(result);
					}
					if (!result.equals("OK")) {
						// 加盟商加工费有异常
						throw new RuntimeException(result);
					}
				}

			} else if (businessUnit.equals(20151)) {
				// 面料+加工费
				OrdersMG mg = new OrdersMG();
				List<Dict> ordersProcessList = new ClothingManager().getOrderProcess(orden, detail.getSingleClothingID());
				Dict dictClothing = DictManager.getDictByID(detail.getSingleClothingID());// 服装分类
				String strCodes = new XmlManager().getDictEcodes(dictClothing, ordersProcessList, orden, false);
				if (detail.getSingleClothingID().equals(5000)) {
					result = mg.doFittingPrice(strCodes, null, detail);
					if (!result.equals("OK")) {
						// 有异常
						throw new RuntimeException(result);
					}
				} else {
					// 毛衬类型
					detail.setProcessPrice(mg.doProcessPrice(strCodes, member.getUsername()));
					String strEcode = new XmlManager().getInterliningType(detail.getSingleClothingID(), orden.getComponents());
					String tempCode = DictManager.getDictByID(detail.getSingleClothingID()).getEcode();
					if (!"".equals(strEcode) && !",".equals(strEcode)) {
						strEcode = strEcode.substring(1, strEcode.length() - 1);
						strEcode = strEcode.split(",")[0];
						interliningType = strEcode;
					}
					strEcode = interliningType;
					if (orden.getOrdenDetails().size() == 1) {
						if (CDict.ClothingChenYi.getID().equals(detail.getSingleClothingID())) {
							strEcode = "MCY";// 标准价格
							String tempStr=","+orden.getComponents()+",";
							if (tempStr.indexOf(",7190,")>=0) {
								//衬衣半手工工艺 7190
								strEcode+="_7190";
							}else if(tempStr.indexOf(",7191,")>=0){
								strEcode+="_7191";
							}
						} else {
							strEcode = (tempCode + "_" + strEcode);
						}
					} else if (CDict.ClothingMaJia.getID().equals(detail.getSingleClothingID())) {
						strEcode = tempCode + "_" + strEcode;// 马甲处理
					}
					result = mg.doFabricPrice(orden, detail);
					if (!result.equals("OK")) {
						// 有异常
						throw new RuntimeException(result);
					}
					result = mg.doCMTPrice(strEcode, detail, orden.getOrdenDetails().size());
					if (!result.equals("OK")) {
						// 加盟商加工费有异常
						throw new RuntimeException(result);
					}
				}

			} else {
				if (detail.getSingleClothingID().equals(5000)) {
					OrdersMG mg = new OrdersMG();
					List<Dict> ordersProcessList = new ClothingManager().getOrderProcess(orden, detail.getSingleClothingID());
					Dict dictClothing = DictManager.getDictByID(detail.getSingleClothingID());// 服装分类
					String strCodes = new XmlManager().getDictEcodes(dictClothing, ordersProcessList, orden, false);
					result = mg.doFittingPrice(strCodes, null, detail);
					if (!result.equals("OK")) {
						// 有异常
						throw new RuntimeException(result);
					}
				} else {

					// 面料价格
					if (fabric != null) {
						detail.setFabricPrice(this.getOrderDetailFabricPrice(fabric, member, orden.getOrdenDetails().size(), singleClothingId));
					}
					double processPrice = 0.0;// 工艺价格
					List<Dict> ordersProcessList = new ClothingManager().getOrderProcess(orden, detail.getSingleClothingID());
					Dict dictClothing = DictManager.getDictByID(detail.getSingleClothingID());// 服装分类
					String strCodes = new XmlManager().getDictEcodes(dictClothing, ordersProcessList, orden, false);
					// CMT价格
					String[] componentPrices = null;
					String strCmtPrice = CurrentInfo.getCurrentMember().getCmtPrice();
					if (StringUtils.isNotEmpty(strCmtPrice)) {
						componentPrices = Utility.getStrArray(strCmtPrice);
					}

					// 毛衬类型
					String strEcode = new XmlManager().getInterliningType(detail.getSingleClothingID(), orden.getComponents());
					String tempCode = DictManager.getDictByID(detail.getSingleClothingID()).getEcode();
					if (!"".equals(strEcode) && !",".equals(strEcode)) {
						strEcode = strEcode.substring(1, strEcode.length() - 1);
						strEcode = strEcode.split(",")[0];
						interliningType = strEcode;
					}
					strEcode = interliningType;
					if (orden.getOrdenDetails().size() == 1) {
						if (CDict.ClothingChenYi.getID().equals(detail.getSingleClothingID())) {
							strEcode = "MCY";// 标准价格
						} else {
							strEcode = (tempCode + "_" + strEcode);
						}
					} else if (CDict.ClothingMaJia.getID().equals(detail.getSingleClothingID())) {
						strEcode = tempCode + "_" + strEcode;// 马甲处理
					}

					// 选择的衬判断
					if (componentPrices != null) {
						for (String componentPrice : componentPrices) {
							String[] parts = componentPrice.split(":");
							if (parts.length == 2) {
								if (parts[0].equals(strEcode)) {
									double cmtPrice = Utility.toSafeDouble(parts[1]);
									// 保留两位小数
									DecimalFormat df = new DecimalFormat("#.00");
									if (CDict.ClothingShangYi.getID().equals(detail.getSingleClothingID()) && orden.getOrdenDetails().size() > 1) {
										cmtPrice *= 0.85;
									} else if (CDict.ClothingPants.getID().equals(detail.getSingleClothingID()) && orden.getOrdenDetails().size() > 1) {
										cmtPrice *= 0.15;
									}
									cmtPrice = Utility.toSafeDouble(df.format(cmtPrice));
									detail.setCmtPrice(cmtPrice);
									break;
								}
							}
						}
					}
					Date benginDate = new Date("2013/5/19");
					if (benginDate.before(member.getRegistDate())) {
						String[] codes = Utility.getStrArray(strCodes);
						for (String code : codes) {
							Integer nIsMaual = null;
							if ("0AAA,00AA,0AAB,0BAA".indexOf(interliningType) >= 0) {
								nIsMaual = CDict.YES.getID();
							}
							List<Dictprice> list = this.getDictPrice(code, pricetype, member.getGroupID(), nIsMaual);
							if (list != null && list.size() > 0) {
								if (member.getMoneySignID().equals(CDict.MoneySignRmb.getID())) {
									processPrice += list.get(0).getRmbPrice();
								} else {
									processPrice += list.get(0).getPrice();
								}
							}
						}
					}
					detail.setProcessPrice(processPrice);// 工艺收费价格
				}
			}

			// 价格null改成0
			if (detail.getCmtPrice() == null) {
				detail.setCmtPrice(0.0);
			}
			if (detail.getFabricPrice() == null) {
				detail.setFabricPrice(0.0);
			}
			if (detail.getProcessPrice() == null) {
				detail.setProcessPrice(0.0);
			}
		}
	}

	/**
	 * 计算个性化工艺价格
	 * 
	 * @param components
	 *            所选工艺
	 * @param moneySingId
	 *            货币类型
	 * @return
	 */
	private double getProcessPrice(Orden orden, Integer singleClothingId, Integer moneySingId, Integer pricetype) {
		double processPrice = 0.0;

		// 获取所有的工艺
		List<Dict> processList = new ClothingManager().getOrderProcess(orden, singleClothingId);
		// 获取所有dictprice以供对比
		List<Dictprice> dpList = new ArrayList<Dictprice>();
		// 计算所有的工艺价格
		for (Dict dict : processList) {
			dpList = getDictPrice(dict.getEcode(), pricetype, null, null);
			Dictprice dp = new Dictprice();
			;
			if (dpList.size() > 0) {
				dp = dpList.get(0);
				processPrice += Utility.toSafeDouble(dp.getPrice());
			}
			// if (CDict.MoneySignDollar.getID().equals(moneySingId)) {
			// processPrice += Utility.toSafeDouble(dict.getDollarPrice());
			// } else {
			// processPrice += Utility.toSafeDouble(dict.getPrice());
			// }
		}
		//
		// // 获取所有的刺绣
		List<Embroidery> embroideryList = new ClothingManager().getEmbroideryLoaction(orden, singleClothingId);
		processPrice += embroideryList.size() * Constant.EMB_PRICE;

		// // 计算所有的刺绣价格
		// for (Embroidery embroidery : embroideryList) {
		// Dict size = embroidery.getSize();
		// if (size != null && !"".equals(size)) {
		// if (CDict.MoneySignDollar.getID().equals(moneySingId)) {
		// processPrice += Utility.toSafeDouble(size.getDollarPrice());
		// } else {
		// processPrice += Utility.toSafeDouble(size.getPrice());
		// }
		// }
		// }
		return processPrice;
	}

	@SuppressWarnings("unchecked")
	public List<Dictprice> getDictPrice(String strCode, Integer nPricetype, Integer strGroupID, Integer nIsMaual) {
		List<Dictprice> dictprice = new ArrayList<Dictprice>();
		try {
			StringBuffer hql = new StringBuffer("SELECT o FROM Dictprice o where code = :code and pricetype = :nPricetype ");
			if (strGroupID != null && strGroupID > 0) {
				hql.append(" and groupids like '").append(strGroupID).append(",%'");
			}
			if (nIsMaual != null && nIsMaual > 0) {
				hql.append(" and ismanual !=").append(nIsMaual);
			}
			Query query = DataAccessObject.openSession().createQuery(hql.toString());
			query.setString("code", strCode);
			query.setInteger("nPricetype", nPricetype);
			query.setMaxResults(10);
			dictprice = (List<Dictprice>) query.list();

		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return dictprice;
	}

	/**
	 * 根据面料编号、用户编号、服装类型计算面料价格
	 * 
	 * @param moneySingId
	 * @param singleClothingId
	 * @param member
	 * @param fabric
	 * @return
	 */
	private double getFabricPrice(Fabric fabric, Member member, Integer singleClothingId) {
		// 判断该面料对该用户当前时间段是否有折扣
		// 默认为无折扣
		Double discount = 100.0;
		FabricDiscount fabricDiscount = new FabricDiscountManager().getFabricDiscountByMemberAndFabricAndDate(fabric.getCode(), member.getID());
		if (fabricDiscount != null && !"".equals(fabricDiscount)) {
			discount = fabricDiscount.getDiscount();
		}

		// 查询用户经营单位查询用户面料价格
		double price = 0.0;
		if (CDict.FabricSupplyCategoryRedCollar.getID().equals(fabric.getFabricSupplyCategoryID())) {
			FabricPrice fabricPrice = new FabricPriceManager().getFabricPriceByAreaAndFabric(member.getBusinessUnit(), fabric.getCode());

			// 美元用户
			if (CDict.MoneySignDollar.getID().equals(member.getMoneySignID())) {
				price = Utility.toSafeDouble(fabricPrice.getDollarPrice());
				// 人民币用户
			} else {
				price = Utility.toSafeDouble(fabricPrice.getRmbPrice());
			}
		}

		// 西装上衣
		if (CDict.ClothingShangYi.getID().equals(singleClothingId)) {
			double xikuPrice = price * Constant.PANTS_CLOTHINGSUITS;
			price -= xikuPrice;
		}

		// 西裤
		if (CDict.ClothingPants.getID().equals(singleClothingId)) {
			price *= Constant.PANTS_CLOTHINGSUITS;
		}

		// 马甲
		if (CDict.ClothingMaJia.equals(singleClothingId)) {
			price *= Constant.VEST_CLOTHINGSUITS;
		}

		// 配件
		if (CDict.ClothingPeiJian.equals(singleClothingId)) {
			price *= Constant.FITTING_CLOTHINGSUITS;
		}

		// 计算面料价*折扣
		price *= discount;

		// 得到折扣后面料价格
		price /= 100.0;
		return price;
	}

	/**
	 * 根据工艺及经营单位获取工艺系数
	 * 
	 * @param businessUnit
	 *            经营单位
	 * @param components
	 *            所选工艺
	 * @return 工艺系数
	 */
	private double getFactor(Integer businessUnit, String[] components, Integer singleClothingId, Integer clothingId) {
		// 默认工艺系数为1
		double factor = 1.0;

		// 将工艺转换为数组
		List<String> componentList = Arrays.asList(components);

		// 红领制衣
		if (CDict.BRAND_HONGLING.getID().equals(businessUnit)) {
			// 上衣
			if (CDict.ClothingShangYi.getID().equals(singleClothingId) ||
			// 套装西裤
					(CDict.ClothingPants.getID().equals(singleClothingId) && (CDict.ClothingSuit2PCS.getID().equals(clothingId) || CDict.ClothingSuit3PCS.getID().equals(clothingId)))) {
				// 全毛衬
				if (componentList.contains(Constant.JACKET_QMC)) {
					// 全手工
					if (componentList.contains(Constant.JACKET_QSG)) {
						factor = Constant.RC_QSGQMC;
						// 半手工
					} else if (componentList.contains(Constant.JACKET_BSG)) {
						factor = Constant.RC_BSGQMC;
						// 全毛衬机制
					} else {
						factor = Constant.RC_QMC;
					}
					// 半毛衬
				} else {
					// 全手工
					if (componentList.contains(Constant.JACKET_QSG)) {
						factor = Constant.RC_QSGBMC;
						// 半手工
					} else if (componentList.contains(Constant.JACKET_BSG)) {
						factor = Constant.RC_BSGBMC;
						// 半毛衬机制
					} else {
						factor = Constant.RC_BMC;
					}
				}
				// 单件西裤
			} else if (CDict.ClothingPants.getID().equals(singleClothingId)) {
				// 全手工
				if (componentList.contains(Constant.PANTS_QSG)) {
					factor = Constant.RC_QSGBMC;
					// 半手工
				} else if (componentList.contains(Constant.PANTS_BSG)) {
					factor = Constant.RC_BSGBMC;
					// 半毛衬机制
				} else {
					factor = Constant.RC_BMC;
				}
				// 大衣
			} else if (CDict.ClothingDaYi.getID().equals(singleClothingId)) {
				// 全毛衬
				if (componentList.contains(Constant.COAT_QMC)) {
					factor = Constant.RC_QMC;
					// 半毛衬
				} else {
					factor = Constant.RC_BMC;
				}
			}
		}

		// 瑞璞制衣
		if (CDict.BRAND_RUIPU.getID().equals(businessUnit)) {
			// 上衣
			if (CDict.ClothingShangYi.getID().equals(singleClothingId) ||
			// 套装西裤
					(CDict.ClothingPants.getID().equals(singleClothingId) && (CDict.ClothingSuit2PCS.getID().equals(clothingId) || CDict.ClothingSuit3PCS.getID().equals(clothingId)))) {

				// 全毛衬
				if (componentList.contains(Constant.JACKET_QMC)) {
					// 全手工
					if (componentList.contains(Constant.JACKET_QSG)) {
						factor = Constant.RP_QSGQMC;
						// 半手工
					} else if (componentList.contains(Constant.JACKET_BSG)) {
						factor = Constant.RP_BSGQMC;
						// 全毛衬
					} else {
						factor = Constant.RP_QMC;
					}
					// 半毛衬
				} else if (componentList.contains(Constant.JACKET_BMC)) {
					// 全手工
					if (componentList.contains(Constant.JACKET_QSG)) {
						factor = Constant.RP_QSGBMC;
						// 半手工
					} else if (componentList.contains(Constant.JACKET_BSG)) {
						factor = Constant.RP_BSGBMC;
						// 半毛衬
					} else {
						factor = Constant.RP_BMC;
					}
				}
			}
		}
		return factor;
	}

	@SuppressWarnings("unchecked")
	public List<Orden> getOrdenByKeyword(String strKeyword) {
		List<Orden> ordens = new ArrayList<Orden>();
		try {
			String hql = "SELECT o FROM Orden o where ordenID like ? and statusID in(10032,10033,10034) order by jhrq ";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setMaxResults(CDict.PAGE_SIZE);
			query.setString(0, strKeyword + "%");
			ordens = (List<Orden>) query.list();
			for (Orden orden : ordens) {
				extendOrden(orden);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordens;
	}

	private Integer getDefaultCmtPriceKey(Integer nSingleClothingID) {
		Integer nKey = nSingleClothingID;
		Dict singleClothing = DictManager.getDictByID(nSingleClothingID);
		if (singleClothing != null) {
			List<Dict> interliningTypeCategorys = new ClothingManager().getInterliningTypeCategory();
			for (Dict interliningTypeCategory : interliningTypeCategorys) {
				if (interliningTypeCategory.getCode().startsWith(singleClothing.getCode())) {
					List<Dict> dicts = DictManager.getDicts(CDictCategory.ClothingCategory.getID(), interliningTypeCategory.getID());
					for (Dict dict : dicts) {
						// 增加机器的 不算 因为没有维护机器价格
						if (CDict.YES.getID().equals(dict.getIsDefault()) && dict.getEcode() != null) {
							nKey = dict.getID();
						}
					}
				}
			}
		}
		return nKey;
	}

	public Orden getOrdenByID(String strOrdenID) {
		Orden orden = (Orden) dao.getEntityByID(Orden.class, strOrdenID);
		extendOrden(orden);
		return orden;
	}

	public Orden getOrdenByOrdenID(String strOrdenID) {
		String hql = " FROM Orden  WHERE sysCode = ?";
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setString(0, strOrdenID);
		@SuppressWarnings("unchecked")
		List<Orden> list = query.list();
		return list.get(0);
	}

	public Orden getordenByOrderId(String strOrdenID) {
		String hql = " FROM Orden  WHERE ordenID = ?";
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setString(0, strOrdenID);
		@SuppressWarnings("unchecked")
		List<Orden> list = query.list();
		if (list.size() == 0) {
			return null;
		}
		return list.get(0);
	}

	@SuppressWarnings("unchecked")
	private List<OrdenDetail> getOrdenDetails(Orden orden) {
		List<OrdenDetail> ordenDetails = new ArrayList<OrdenDetail>();
		try {
			String hql = "FROM OrdenDetail d WHERE d.OrdenID = ? order by singleClothingID";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, orden.getOrdenID());
			ordenDetails = query.list();
			for (OrdenDetail ordenDetail : ordenDetails) {
				extendOrdenDetail(orden, ordenDetail);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordenDetails;
	}

	public List<OrdenDetail> getOrdenDetailByOrdenID(String ordenID) {
		List<OrdenDetail> ordenDetails = new ArrayList<OrdenDetail>();
		String hql = "FROM OrdenDetail d WHERE d.OrdenID = ? ";
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setString(0, ordenID);
		ordenDetails = query.list();
		return ordenDetails;
	}

	@SuppressWarnings("unchecked")
	public List<OrdenDetail> getDetailsByOrdenID(String strOrdenID, List<OrdenDetail> ordenDetail) {
		List<OrdenDetail> ordenDetails = new ArrayList<OrdenDetail>();
		try {
			String hql = "FROM OrdenDetail d WHERE d.OrdenID = ? order by singleClothingID";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, strOrdenID);
			ordenDetails = query.list();
			for (int i = 0; i < ordenDetails.size(); i++) {
				ordenDetail.get(i).setSpecChest(ordenDetails.get(i).getSpecChest());
				ordenDetail.get(i).setSpecHeight(ordenDetails.get(i).getSpecHeight());
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordenDetail;
	}

	public String updateCaseByID(String strOrdenID) {
		String sql = "update Orden  set caseno = null WHERE  ordenID = '" + strOrdenID + "'";
		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(sql);
			query.executeUpdate();
			transaction.commit();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return null;

	}

	/*
	 * private void extendOrdenDetail(Orden orden, OrdenDetail ordenDetail) {
	 * int nSingleClothingID = ordenDetail.getSingleClothingID();
	 * ordenDetail.setSingleClothingName(DictManager
	 * .getDictNameByID(nSingleClothingID)); List<Dict> singleDesignedComponents
	 * = new ClothingManager() .getOrderProcess(orden, nSingleClothingID);
	 * Embroidery emberoidery = new ClothingManager().getEmbroideryLoaction(
	 * orden, nSingleClothingID); ordenDetail
	 * .setSingleComponents(getSingleDesignedComponentsName
	 * (singleDesignedComponents,orden.getComponentTexts())); ordenDetail
	 * .setSingleEmbroiderys(getSingleDesignedEmbroiderysName(emberoidery));
	 * //衣服大小号 List<OrdenDetail> ordenDetails = orden.getOrdenDetails();
	 * if(ordenDetails != null){ for(OrdenDetail od : ordenDetails){
	 * if(od.getSingleClothingID().equals(ordenDetail.getSingleClothingID())){
	 * ordenDetail.setSpecHeight(od.getSpecHeight()); } } } }
	 */
	private void extendOrdenDetail(Orden orden, OrdenDetail ordenDetail) {
		int nSingleClothingID = ordenDetail.getSingleClothingID();
		ordenDetail.setSingleClothingName(DictManager.getDictNameByID(nSingleClothingID));
		List<Dict> singleDesignedComponents = new ClothingManager().getOrderProcess(orden, nSingleClothingID);
		List<Embroidery> emberoidery = null;
		if (orden.getComponents() != null && orden.getComponents().indexOf("_") <= 0) {
			emberoidery = new ClothingManager().getEmbroideryLoaction(orden, nSingleClothingID);
		} else {
			emberoidery = new ClothingManager().getEmbroidery(orden, nSingleClothingID);
		}
		ordenDetail.setSingleComponents(getSingleDesignedComponentsName(singleDesignedComponents, orden.getComponentTexts()));
		ordenDetail.setEmberoidery(emberoidery);
		ordenDetail.setSingleEmbroiderys(getSingleDesignedEmbroiderysName(emberoidery));
		// 衣服大小号
		List<OrdenDetail> ordenDetails = orden.getOrdenDetails();
		if (ordenDetails != null) {
			for (OrdenDetail od : ordenDetails) {
				if (od.getSingleClothingID().equals(ordenDetail.getSingleClothingID())) {
					ordenDetail.setSpecHeight(od.getSpecHeight());
				}
			}
		}
	}

	/*
	 * private String getSingleDesignedEmbroiderysName(Embroidery emberoidery) {
	 * String strSingleDesignedEmbroiderysName = ""; if (emberoidery != null) {
	 * if (emberoidery.getColor() != null) { strSingleDesignedEmbroiderysName +=
	 * "<span><label>" + DictManager.getDictNameByID(emberoidery.getColor()
	 * .getParentID()) + "</label> : " + emberoidery.getColor().getName() +
	 * "</span>"; } if (emberoidery.getFont() != null) {
	 * strSingleDesignedEmbroiderysName += "<span><label>" +
	 * DictManager.getDictNameByID(emberoidery.getFont() .getParentID()) +
	 * "</label> : " + emberoidery.getFont().getName() + "</span>"; } if
	 * (emberoidery.getLocation() != null) { strSingleDesignedEmbroiderysName +=
	 * "<span><label>" + DictManager.getDictNameByID(emberoidery.getLocation()
	 * .getParentID()) + "</label> : " + emberoidery.getLocation().getName() +
	 * "</span>"; } if (emberoidery.getContent() != null) {
	 * strSingleDesignedEmbroiderysName += "<span><label>" +
	 * DictManager.getDictNameByID(421) + "</label> : " +
	 * emberoidery.getContent() + "</span>"; } if (emberoidery.getSize() !=
	 * null) { strSingleDesignedEmbroiderysName += "<span><label>" +
	 * DictManager.getDictNameByID(emberoidery.getSize() .getParentID()) +
	 * "</label> : " + emberoidery.getSize().getName() + "</span>"; } } return
	 * strSingleDesignedEmbroiderysName; }
	 */
	private String getSingleDesignedEmbroiderysName(List<Embroidery> emberoiderys) {
		String strSingleDesignedEmbroiderysName = "";
		for (Embroidery emberoidery : emberoiderys) {
			if (emberoidery != null) {
				if (emberoidery.getColor() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>" + DictManager.getDictNameByID(emberoidery.getColor().getParentID()) + "</label> : " + emberoidery.getColor().getName() + "</span>";
				}
				if (emberoidery.getFont() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>" + DictManager.getDictNameByID(emberoidery.getFont().getParentID()) + "</label> : " + emberoidery.getFont().getName() + "</span>";
				}
				if (emberoidery.getLocation() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>" + DictManager.getDictNameByID(emberoidery.getLocation().getParentID()) + "</label> : " + emberoidery.getLocation().getName() + "</span>";
				}
				if (emberoidery.getContent() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>" + DictManager.getDictNameByID(421) + "</label> : " + emberoidery.getContent() + "</span>";
				}
				if (emberoidery.getSize() != null) {
					strSingleDesignedEmbroiderysName += "<span><label>" + DictManager.getDictNameByID(emberoidery.getSize().getParentID()) + "</label> : " + emberoidery.getSize().getName() + "</span>";
				}
			}
		}
		return strSingleDesignedEmbroiderysName;
	}

	private String getSingleDesignedComponentsName(List<Dict> singleDesignedComponents, String strCompentText) {
		String strSingleDesignedComponentsName = "";
		String[] strCompentTextComponent = {};
		if (strCompentText != null) {
			strCompentTextComponent = strCompentText.split(",");
		}
		for (Dict component : singleDesignedComponents) {
			Dict parent = DictManager.getDictByID(component.getParentID());
			if (parent != null && !"10008".equals(Utility.toSafeString(component.getStatusID()))) {
				strSingleDesignedComponentsName += "<span><label>" + parent.getName() + "</label> : " + component.getEcode()+" "+component.getName() + "</span>";
			}
			for (int n = 0; n < strCompentTextComponent.length; n++) {// 款式号、价格
				if (!"".equals(Utility.toSafeString(strCompentTextComponent[n]))) {
					if (Utility.toSafeString(component.getID()).equals(Utility.toSafeString(strCompentTextComponent[n].split(":")[0]))) {
						strSingleDesignedComponentsName += "<span><label>" + component.getName() + "</label> : " + component.getEcode()+" "+ strCompentTextComponent[n].substring(strCompentTextComponent[n].indexOf(":") + 1) + "</span>";
					}
				}

			}
		}
		return strSingleDesignedComponentsName;
	}

	public List<Dict> getSingleDesignedComponents(String strAllDesignedComponents, int nSingleClothingID) {
		List<Dict> singleAllComponents = new ClothingManager().getAllNormalComponents(nSingleClothingID);
		List<Dict> singleDesignedComponents = new ArrayList<Dict>();
		/*
		 * for (Dict component : singleAllComponents) { if
		 * (Utility.contains(strAllDesignedComponents,
		 * Utility.toSafeString(component.getID()))) {
		 * singleDesignedComponents.add(component); } }
		 */
		if (!"".equals(strAllDesignedComponents) && null != strAllDesignedComponents) {
			String[] components = Utility.getStrArray(strAllDesignedComponents);
			for (String emb : components) {
				for (Dict component : singleAllComponents) {
					if (emb.equals(Utility.toSafeString(component.getID()))) {
						singleDesignedComponents.add(component);
					}
				}
			}
		}
		return CurrentInfo.getAuthorityFunction(singleDesignedComponents);
	}

	/**
	 * 根据用户编号查询已生产或已入库的未申请发货的订单
	 * 
	 * @param strMemberID
	 *            用户ID
	 * @return 查找到的订单列表
	 */
	@SuppressWarnings("unchecked")
	public List<Orden> getFinishedOrdens(String strMemberID) {
		List<Orden> ordens = new ArrayList<Orden>();
		try {
			String hql = "SELECT o FROM Orden o, Member m,Customer c WHERE o.PubMemberID = m.ID AND c.ID = o.CustomerID  AND m.ID = ? AND o.StatusID in (?,?) AND (o.DeliveryID = '' OR o.DeliveryID IS NULL)";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, strMemberID);
			// 状态为已入库的订单
			query.setInteger(1, CDict.OrdenStatusStorage.getID());
			// 状态为生产中的订单
			query.setInteger(2, CDict.OrdenStatusProduce.getID());
			ordens = (List<Orden>) query.list();
			for (Orden orden : ordens) {
				extendOrden(orden);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordens;
	}

	@SuppressWarnings("unchecked")
	public List<Orden> getOrdensByDeliveryID(String stDeliveryID) {
		List<Orden> ordens = new ArrayList<Orden>();
		try {
			String hql = "SELECT o FROM Orden o, Member m,Customer c WHERE o.PubMemberID = m.ID AND c.ID = o.CustomerID  AND o.DeliveryID = ?";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, stDeliveryID);
			ordens = (List<Orden>) query.list();
			for (Orden orden : ordens) {
				extendOrden(orden);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordens;
	}

	@SuppressWarnings("unchecked")
	public List<Member> getOrdensClient(String memberCode) {
		List<Member> ordens = new ArrayList<Member>();
		try {
			String hql = "SELECT DISTINCT m.ID,m.Username,m.GroupID,m.Code  FROM Orden o, Member m WHERE o.PubMemberID = m.ID AND m.Code LIKE :MemberCode" + "   ORDER BY m.GroupID ASC";
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("MemberCode", memberCode + "%");
			List<Object[]> list = new ArrayList<Object[]>();
			list = query.list();
			if (list.size() > 0) {
				for (Object[] obj : list) {
					Member member = new Member();
					if (obj[0] != null) {
						member.setID(obj[0].toString());
					}
					if (obj[1] != null) {
						member.setName(obj[1].toString());
					}
					ordens.add(member);
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordens;
	}

	public List<?> getOrdensByStatusID(int nStatusID, Date dealDate, Date dealToDate) {
		String strHQL = "SELECT SysCode FROM Orden o where statusID=? and ordenid not like '12%' and ordenid not like 'TS%'  and  ordenid not like 'MW%' and  ordenid not like 'XXXX%'  and  ordenid not like 'BBBB%' and  ordenid not like 'CCCC%'  and  ordenid not like 'AAAA%'  and  ordenid not like 'MTMA%'  and  ordenid not like 'MTMAA%'  and  ordenid not like 'MTMB%'";
		try {
			Query query = DataAccessObject.openSession().createQuery(strHQL);
			query.setInteger(0, nStatusID);
			List<?> ordens = query.list();
			return ordens;
		} catch (Exception e) {
			// TODO:
			e.printStackTrace();
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Orden> getOrdens(int nPageIndex, int nPageSize, String strKeyword, String strMemberCode, int nStatusID, int nClothingID, Date dealDate, Date dealToDate, Date fromDate, Date toDate, String strPubMemberID) {
		List<Orden> ordens = new ArrayList<Orden>();
		try {
			Query query = getOrdensQuery("o", strKeyword, strMemberCode, nStatusID, nClothingID, dealDate, dealToDate, fromDate, toDate, strPubMemberID);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			ordens = (List<Orden>) query.list();
			int i = 0;
			for (Orden orden : ordens) {
				orden.number = (++i);
				if (orden.getCustomerID() != null && !"".equals(orden.getCustomerID())) {
					Customer customer = new CustomerManager().getCustomerByID(orden.getCustomerID());
					orden.setCustomer(customer);
				}
				Member member = new MemberManager().getMemberByID(orden.getPubMemberID());
				if (member != null) {
					orden.setPubMemberName(member.getName());
					orden.setCompanyShortName(member.getCompanyShortName());
					orden.setUsername(member.getUsername());
				}
				// 服装分类+数量
				if (orden.getClothingID() != null && !"".equals(orden.getClothingID())) {
					if (orden.getMorePants() == 10050) {
						orden.setClothingName(DictManager.getDictNameByID(orden.getClothingID()));
					} else if (orden.getMorePants() == 10051) {
						orden.setClothingName("1 " + DictManager.getDictNameByID(orden.getClothingID()));
					} else {
						orden.setClothingName(orden.getMorePants() + " " + DictManager.getDictNameByID(orden.getClothingID()));
					}
				}
				// 设置是否已申请发货
				if (orden.getDeliveryID() != null && !"".equals(orden.getDeliveryID())) {
					orden.setDeliveryStatusName(DictManager.getDictNameByID(10330));
				} else {
					orden.setDeliveryStatusName(DictManager.getDictNameByID(10331));
				}
				List<OrdenDetail> details = this.getOrdenDetails(orden);
				for (OrdenDetail ordenDetail : details) {
					if (ordenDetail.getSingleClothingID().equals(CDict.ClothingPants.getID()) && orden.getMorePants() == 10050) {
						if (ordenDetail.getAmount() > 1) {
							orden.setClothingName(orden.getClothingName() + "+" + ordenDetail.getSingleClothingName());
						} else {
							orden.setClothingName(orden.getClothingName() + "+1");
						}
					}
				}
				if (orden.getStatusID() != null && !"".equals(orden.getStatusID())) {
					Dict currentStatus = DictManager.getDictByID(orden.getStatusID());
					if (currentStatus != null) {
						orden.setStatusName(currentStatus.getName());
						if (isBeforPlateMaking(currentStatus)) {

							if (orden.getPubDate() != null) {
								Date overdueDate = DateHelper.getDateSkipHours(orden.getPubDate(), 72);

								if (new Date().after(overdueDate)) {
									orden.setIsPubOverdue(CDict.YES.getID());
								}
							}
						}
						String strOperationStop = "";// 是否停滞
						if (orden.getIsStop() != null && !"".equals(orden.getIsStop())) {
							if (CDict.NO.getID().equals(orden.getIsStop())) {
								strOperationStop = "<a class='operation' onclick=$.csOrdenList.isStop('" + orden.getOrdenID() + "','" + orden.getIsStop() + "')>" + ResourceHelper.getValue("Button_Stop") + "</a>";
							} else if (CDict.YES.getID().equals(orden.getIsStop())) {
								strOperationStop = "<a class='operation' onclick=$.csOrdenList.isStop('" + orden.getOrdenID() + "','" + orden.getIsStop() + "')>" + ResourceHelper.getValue("Button_Cancel") + "</a>";
								orden.setStatusName(ResourceHelper.getValue("Button_IsStop"));
								String strStopCause = "";
								if (orden.getMemo() != null && !"".equals(orden.getMemo()) && !"提交BL 失败 ".equals(orden.getMemo())) {
									String[] strFabric = orden.getMemo().split(",");
									if (strFabric.length > 1) {
										strStopCause += ResourceHelper.getValue("Fabric_Message_" + strFabric[0]);
										strStopCause += " " + strFabric[1] + " ";
										strStopCause += ResourceHelper.getValue("FabricSize_Message_2") + strFabric[2];
										strStopCause += ResourceHelper.getValue("FabricSize_Message_1") + strFabric[3];
									} else {
										strStopCause += orden.getMemo();
									}
								} else {
									strStopCause = ResourceHelper.getValue("Dict_" + orden.getStopCause());
								}
								orden.setStopCauseName(strStopCause);
							}
						}

						String strOperationRemove = "<a class='operation' onclick=$.csOrdenList.remove('" + orden.getOrdenID() + "','" + orden.getStatusID() + "','" + CurrentInfo.getCurrentMember().getCompanyID() + "')>" + ResourceHelper.getValue("Button_Remove") + "</a>";
						String strOperation = "<a class='operation' onclick=$.csOrdenList.openEdit('" + orden.getOrdenID() + "')>" + ResourceHelper.getValue("Button_Edit") + "</a>";
						String strPreSubmit = "<a class='operation' onclick=$.csOrdenList.preSubmitOrden('" + orden.getOrdenID() + "')>" + ResourceHelper.getValue("Button_PreSubmit") + "</a>";
						String strPay = "<a class='operation' onclick=$.csOrdenList.ordenToPay('" + orden.getOrdenID() + "','" + orden.getSysCode() + "','" + CurrentInfo.getCurrentMember().getUserStatus() + "','" + CurrentInfo.getCurrentMember().getCompanyID() + "','" + CurrentInfo.getCurrentMember().getPayTypeID() + "')>" + ResourceHelper.getValue("Button_PayOrden") + "</a>";
						// if
						// (CDict.OrdenStatusSaving.getID().equals(orden.getStatusID()))
						// {// 订单状态=保存中
						if (CDict.OrdenStatusSaving.getID().equals(orden.getStatusID()) || CDict.OrdenStatusPaid.getID().equals(orden.getStatusID())) {// 订单状态=保存中或已支付
							if ("5000".equals(Utility.toSafeString(orden.getClothingID()))) {
								orden.setConstDefine(orden.getConstDefine() + strOperation + strOperationRemove);
							} else {
								orden.setConstDefine(orden.getConstDefine() + strOperation + strPreSubmit + strOperationRemove);
							}
						}
						if (CDict.OrdenStatusStayPayments.getID().equals(orden.getStatusID())) {// 订单状态=待支付
							orden.setConstDefine(orden.getConstDefine() + strPay + strOperationRemove);
						}
						if (CurrentInfo.isAdmin() && isBeforPlateMaking(currentStatus)) {
							orden.setConstDefine(orden.getConstDefine() + strOperationStop);
						} else if (CurrentInfo.isAdmin()) {
							orden.setConstDefine(strOperationStop);
						}
						if(!orden.getPubMemberID().equals(CurrentInfo.getCurrentMember().getID())){
							orden.setConstDefine("");
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordens;
	}

	public List getOrdenList(int nPageIndex, int nPageSize, String strKeyword, String strMemberCode, int nStatusID, int nClothingID, String dealDate, String dealToDate, String fromDate, String toDate, String strPubMemberID) {
		if (nClothingID == 10000) {
			nClothingID = 1;
		}
		if (nStatusID == 10000) {
			nStatusID = -1;
		}
		StringBuilder sb = new StringBuilder();
		sb.append("select rownum rn,o.ordenid ordenid,o.syscode syscode,m.paytypeid mpaytypeid,m.statusid mstatusid,o.userordeno userordeno,d.name dname,c.name cname,m.companyid companyid,o.fabriccode,o.pubdate pubdate,o.deliverydate deliverydate,o.jhrq jhrq,o.deliveryid deliveryid,(select dict.name from dict where dict.id=o.stopcause) causename, o.statusid statusid,o.isstop isstop,o.stopcause stopcause,o.morepants morepants,o.memo memo,m.ordenpre ordenpre,c.memos memos from orden o").append(" left join member m on o.pubmemberid=m.id left join customer c on c.id=o.customerid left join dict d on o.clothingid=d.id").append(" where (upper(c.tel) like '%" + strKeyword + "%' or c.address like '%" + strKeyword + "%' or c.name like '%" + strKeyword + "%' or upper(o.ordenid) like '%" + strKeyword + "%' or upper(o.fabriccode) like '%" + strKeyword + "%' or upper(o.userordeNo) like '%" + strKeyword + "%') ");
		sb.append("and m.code like '" + strMemberCode + "%'");
		if (!"-1".equals(strPubMemberID)) {
			sb.append(" and o.pubmemberid ='" + strPubMemberID + "'");
		}
		if (nClothingID != -1) {
			sb.append(" and o.clothingid =" + nClothingID);
		}
		if (nStatusID != -1 && !CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			sb.append(" and o.statusid = " + nStatusID + " and o.isstop =" + 10051);
		}
		if (CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			sb.append(" and o.isstop =" + 10050);
		}
		if (fromDate != null && !"".equals(fromDate)) {
			sb.append(" and to_char(o.pubdate,'yyyy-MM-dd')>='" + fromDate + "'");
		}
		if (toDate != null && !"".equals(toDate)) {
			sb.append(" and to_char(o.pubdate,'yyyy-MM-dd')<='" + toDate + "'");
		}
		if (dealDate != null && !"".equals(dealDate)) {
			sb.append(" and to_char(o.jhrq,'yyyy-MM-dd')>='" + dealDate + "'");
		}
		if (!"".equals(dealToDate) && dealToDate != null) {
			sb.append("  and to_char(o.jhrq,'yyyy-MM-dd')<='" + dealToDate + "'");
		}
		sb.append("order by o.ordenid desc");
		Query query = DataAccessObject.openSession().createSQLQuery(sb.toString()).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setFirstResult(nPageIndex * nPageSize);
		query.setMaxResults(nPageSize);
		List list = query.list();
		return list;
	}

	public int getOrdenListCount(String strKeyword, String strMemberCode, int nStatusID, int nClothingID, String dealDate, String dealToDate, String fromDate, String toDate, String strPubMemberID) {
		int count = 0;
		if (nClothingID == 10000) {
			nClothingID = 1;
		}
		if (nStatusID == 10000) {
			nStatusID = -1;
		}
		StringBuilder sb = new StringBuilder();
		sb.append("select count(1) from orden o").append(" left join member m on o.pubmemberid=m.id left join customer c on c.id=o.customerid left join dict d on o.clothingid=d.id").append(" where (upper(c.tel) like '%" + strKeyword + "%' or c.address like '%" + strKeyword + "%' or c.name like '%" + strKeyword + "%' or upper(o.ordenid) like '%" + strKeyword + "%' or upper(o.fabriccode) like '%" + strKeyword + "%' ) ");
		sb.append("and m.code like '" + strMemberCode + "%'");
		if (!"-1".equals(strPubMemberID)) {
			sb.append(" and o.pubmemberid ='" + strPubMemberID + "'");
		}
		if (nClothingID != -1) {
			sb.append(" and o.clothingid =" + nClothingID);
		}
		if (nStatusID != -1 && !CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			sb.append(" and o.statusid = " + nStatusID + " and o.isstop =" + 10051);
		}
		if (CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			sb.append(" and o.isstop =" + 10050);
		}
		if (fromDate != null && !"".equals(fromDate)) {
			sb.append(" and TO_CHAR(o.pubdate,'yyyy-MM-dd')>='" + fromDate + "'");
		}
		if (toDate != null && !"".equals(toDate)) {
			sb.append(" and TO_CHAR(o.pubdate,'yyyy-MM-dd')<='" + toDate + "'");
		}
		if (dealDate != null && !"".equals(dealDate)) {
			sb.append(" and TO_CHAR(o.jhrq,'yyyy-MM-dd')>='" + dealDate + "'");
		}
		if (dealToDate != null && !"".equals(dealToDate)) {
			sb.append(" and TO_CHAR(o.jhrq,'yyyy-MM-dd')<='" + dealToDate + "'");
		}
		/*if (dealDate != null && !"".equals(dealDate) && !"".equals(dealToDate) && dealToDate != null) {
			sb.append(" and to_char(o.jhrq,'yyyy-MM-dd')>='" + dealDate + "'and to_char(o.jhrq,'yyyy-MM-dd')<='" + dealToDate + "'");
		}*/
		Query query = DataAccessObject.openSession().createSQLQuery(sb.toString());
		count = Utility.toSafeInt(query.uniqueResult());
		return count;
	}

	private Query getOrdensQuery(String strChange, String strKeyword, String strMemberCode, int nStatusID, int nClothingID, Date dealDate, Date dealToDate, Date fromDate, Date toDate, String strPubMemberID) {
		String hql = "SELECT " + strChange + " FROM Orden o, Member m,Customer c WHERE o.PubMemberID = m.ID AND c.ID = o.CustomerID " + "AND (upper(c.Tel) LIKE upper(:Keyword) OR upper(c.Address) LIKE upper(:Keyword) OR upper(c.Name) LIKE upper(:Keyword) OR o.OrdenID LIKE :Keyword OR o.UserordeNo LIKE :Keyword OR o.FabricCode LIKE :Keyword ) " + "AND m.Code LIKE :MemberCode ";
		if (nClothingID != -1) {
			hql += " AND o.ClothingID = :ClothingID ";
		}
		/*if (nStatusID != -1 && !CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			hql += " AND o.StatusID = :StatusID  AND o.IsStop = :IsStop ";
		}*/
		if (nStatusID != -1) {
			hql += " AND o.StatusID = :StatusID ";
		}
		if (!"-1".equals(strPubMemberID)) {
			hql += " AND o.PubMemberID = :PubMemberID ";
		}
		/*if (CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			hql += " AND o.IsStop = :IsStop ";
		}*/
		if (fromDate != null && !"".equals(fromDate)) {
			hql += " AND TO_CHAR(o.PubDate,'yyyy-MM-dd')>= TO_CHAR(:FromDate,'yyyy-MM-dd')";
		}
		if (toDate != null && !"".equals(toDate)) {
			hql += " AND TO_CHAR(o.PubDate,'yyyy-MM-dd')<=TO_CHAR(:ToDate,'yyyy-MM-dd')";
		}
		if (dealDate != null && !"".equals(dealDate)) {
			hql += " AND TO_CHAR(o.Jhrq,'yyyy-MM-dd')>= TO_CHAR(:DealDate,'yyyy-MM-dd')";
		}
		if (dealToDate != null && !"".equals(dealToDate)) {
			hql += " AND TO_CHAR(o.Jhrq,'yyyy-MM-dd')<=TO_CHAR(:DealToDate,'yyyy-MM-dd')";
		}
		/*if (dealDate != null && dealToDate != null) {
			hql += " AND o.Jhrq >= to_date(:DealDate,'yyyy-mm-dd')  AND o.Jhrq <=to_date(:DealToDate,'yyyy-mm-dd')";
		}*/
		hql += " ORDER BY o.OrdenID DESC ";
		Query query = DataAccessObject.openSession().createQuery(hql);
		query.setString("Keyword", "%" + strKeyword + "%");
		query.setString("MemberCode", strMemberCode + "%");

		if (dealDate != null && !"".equals(dealDate)) {
			query.setDate("DealDate", dealDate);
		}
		if (dealToDate != null && !"".equals(dealToDate)) {
			query.setDate("DealToDate", dealToDate);
		}

		if (fromDate != null && !"".equals(fromDate)) {
			query.setDate("FromDate", fromDate);
		}
		if (toDate != null && !"".equals(toDate)) {
			query.setDate("ToDate", toDate);
		}
		if (nClothingID != -1) {
			query.setInteger("ClothingID", nClothingID);
		}

		if (nStatusID != -1/* && !CDict.OrdenStatusStop.getID().equals(nStatusID)*/) {
			query.setInteger("StatusID", nStatusID);
			/*query.setInteger("IsStop", CDict.NO.getID());*/
		}
		if (!"-1".equals(strPubMemberID)) {
			query.setString("PubMemberID", strPubMemberID);
		}
		/*if (CDict.OrdenStatusStop.getID().equals(nStatusID)) {
			query.setInteger("IsStop", CDict.YES.getID());
		}*/
		return query;
	}

	public Orden extendOrden(Orden orden) {
		if (orden == null) {
			orden = new Orden();
		}

		if (orden.getCustomerID() != null && !"".equals(orden.getCustomerID())) {
			Customer customer = new CustomerManager().getCustomerByID(orden.getCustomerID());
			orden.setCustomer(customer);
		}
		if (orden.getPubMemberID() != null && !"".equals(orden.getPubMemberID())) {
			Member member = new MemberManager().getMemberByID(orden.getPubMemberID());
			if (member != null) {
				orden.setPubMemberName(member.getName());
				orden.setCompanyShortName(member.getCompanyShortName());
				orden.setUsername(member.getUsername());
			}
		}
		if (orden.getSizeUnitID() != null && !"".equals(orden.getSizeUnitID())) {
			orden.setSizeUnitName(DictManager.getDictNameByID(orden.getSizeUnitID()));
		}
		if (orden.getStyleID() != null && !"".equals(orden.getStyleID())) {
			orden.setStyleName(DictManager.getDictNameByID(orden.getStyleID()));
		}
		// 服装分类+数量
		if (orden.getClothingID() != null && !"".equals(orden.getClothingID())) {
			if (orden.getMorePants() == 10050) {
				orden.setClothingName(DictManager.getDictNameByID(orden.getClothingID()));
			} else if (orden.getMorePants() == 10051) {
				orden.setClothingName("1 " + DictManager.getDictNameByID(orden.getClothingID()));
			} else {
				orden.setClothingName(orden.getMorePants() + " " + DictManager.getDictNameByID(orden.getClothingID()));
			}
		}
		// 设置是否已申请发货
		if (orden.getDeliveryID() != null && !"".equals(orden.getDeliveryID())) {
			orden.setDeliveryStatusName(CDict.YES.getName());
		} else {
			orden.setDeliveryStatusName(CDict.NO.getName());
		}
		if (orden.getSizeCategoryID() != null && !"".equals(orden.getSizeCategoryID())) {
			orden.setSizeCategoryName(DictManager.getDictNameByID(orden.getSizeCategoryID()));
			if (orden.getSizeAreaID() != null && !"".equals(orden.getSizeAreaID())) {
				orden.setSizeCategoryName(orden.getSizeCategoryName() + DictManager.getDictNameByID(orden.getSizeAreaID()) + " ");
				if (orden.getSizeSpec() != null && !"".equals(orden.getSizeSpec())) {
					orden.setSizeCategoryName(orden.getSizeCategoryName() + orden.getSizeSpec());
				}
			}
		}
		if (orden.getSizeBodyTypeValues() != null && !"".equals(orden.getSizeBodyTypeValues())) {
			String[] strIDs = Utility.getStrArray(orden.getSizeBodyTypeValues());
			String strBodyTypes = "";
			for (String strID : strIDs) {
				// //着装风格
				int nCategoryID = DictManager.getDictByID(Utility.toSafeInt(strID)).getCategoryID();
				strBodyTypes += DictCategoryManager.getDictCategoryNameByID(nCategoryID) + ":";
				strBodyTypes += DictManager.getDictNamesByIDs(strID) + "&nbsp;";
			}
			orden.setSizeBodyTypeNames(strBodyTypes.substring(0, strBodyTypes.length() - 1));
		}
		// 订单 明细
		List<OrdenDetail> details = this.getOrdenDetails(orden);
		if (details != null && details.size() > 0) {
			orden.setOrdenDetails(details);
		}
		// 着装风格
		String clothingStyleNames = "";
		for (OrdenDetail ordenDetail : details) {
			String styles = orden.getComponentTexts();
			if (!"".equals(styles) && styles != null) {
				String[] style = styles.split(",");
				for (int i = 0; i < style.length; i++) {
					String[] clothingstyle = style[i].split(":");
					if (Utility.toSafeString(ordenDetail.getSingleClothingID()).equals(clothingstyle[0]) && clothingstyle.length > 1) {
						clothingStyleNames += DictManager.getDictNamesByIDs(clothingstyle[0]) + ":" + DictManager.getDictNamesByIDs(clothingstyle[1]) + "&nbsp;";
					}
				}
			}
		}
		orden.setClothingStyleName(clothingStyleNames);
		if ("6000".equals(Utility.toSafeString(orden.getClothingID())) && "10052".equals(Utility.toSafeString(orden.getSizeCategoryID()))) {
			orden.setStyleDYName(ResourceHelper.getValue("DY_" + orden.getStyleDY()));
		}
		String str = "";
		for (OrdenDetail ordenDetail : details) {
			if (ordenDetail.getSingleClothingID().equals(CDict.ClothingPants.getID()) && orden.getMorePants() == 10050) {
				if (ordenDetail.getAmount() > 1) {
					orden.setClothingName(orden.getClothingName() + "+" + ordenDetail.getSingleClothingName());
				} else {
					orden.setClothingName(orden.getClothingName() + "+1");
				}
			}
			str += this.getSizePartName(orden, ordenDetail.getSingleClothingID()) + "<br>";
		}
		orden.setSizePartNames(str);
		if (orden.getStopCause() != null && !"".equals(orden.getStopCause()) && !"-1".equals(orden.getStopCause())) {
			orden.setStopCauseName(DictManager.getDictNamesByIDs(Utility.toSafeString(orden.getStopCause())));
		}
		//老平台净体量体信息（成衣、净体都有时）
		if(orden.getJtSize() != null){
			String strJtSizeName="";
			String strSize ="";
			String[] partValues = Utility.getStrArray(orden.getJtSize());
			for (String partValue : partValues) {
				String[] pv = partValue.split(":");
					if (pv != null && pv.length == 2 && !"|".equals(pv[1].trim())) {
						String value = pv[1];
						if("10108".equals(pv[0]) && pv[1].split("|").length==2){
							value = pv[1].split("|")[0];
						}
						strSize += ResourceHelper.getValue("Dict_"+pv[0])+":"+value+"&nbsp;";
					}
			}
			if(!"".equals(strSize)){
				strJtSizeName = "("+ResourceHelper.getValue("Dict_10052")+"："+strSize+")";
			}
			orden.setJtSizeName(strJtSizeName);
		}
		
		if (orden.getStatusID() != null && !"".equals(orden.getStatusID())) {
			Dict currentStatus = DictManager.getDictByID(orden.getStatusID());
			if (currentStatus != null) {
				orden.setStatusName(currentStatus.getName());
				if (isBeforPlateMaking(currentStatus)) {

					if (orden.getPubDate() != null) {
						Date overdueDate = DateHelper.getDateSkipHours(orden.getPubDate(), 72);

						if (new Date().after(overdueDate)) {
							orden.setIsPubOverdue(CDict.YES.getID());
						}
					}
				}
				String strOperationStop = "";// 是否停滞
				if (orden.getIsStop() != null && !"".equals(orden.getIsStop())) {
					if (CDict.NO.getID().equals(orden.getIsStop())) {
						strOperationStop = "<a class='operation' onclick=$.csOrdenList.isStop('" + orden.getOrdenID() + "','" + orden.getIsStop() + "')>" + ResourceHelper.getValue("Button_Stop") + "</a>";
					} else if (CDict.YES.getID().equals(orden.getIsStop())) {
						strOperationStop = "<a class='operation' onclick=$.csOrdenList.isStop('" + orden.getOrdenID() + "','" + orden.getIsStop() + "')>" + ResourceHelper.getValue("Button_Cancel") + "</a>";
						orden.setStatusName(ResourceHelper.getValue("Button_IsStop"));
					}
				}

				String strOperationRemove = "<a class='operation' onclick=$.csOrdenList.remove('" + orden.getOrdenID() + "')>" + ResourceHelper.getValue("Button_Remove") + "</a>";
				String strOperation = "<a class='operation' onclick=$.csOrdenList.openEdit('" + orden.getOrdenID() + "')>" + ResourceHelper.getValue("Button_Edit") + "</a>";
				// if
				// (CDict.OrdenStatusSaving.getID().equals(orden.getStatusID()))
				// {// 订单状态=保存中
				if (CDict.OrdenStatusSaving.getID().equals(orden.getStatusID()) || CDict.OrdenStatusPaid.getID().equals(orden.getStatusID())) {// 订单状态=保存中或已支付
					orden.setConstDefine(orden.getConstDefine() + strOperation + strOperationRemove);
				}
				if (CurrentInfo.isAdmin() && isBeforPlateMaking(currentStatus)) {
					orden.setConstDefine(orden.getConstDefine() + strOperationStop);
				} else if (CurrentInfo.isAdmin()) {
					orden.setConstDefine(strOperationStop);
				}
			}
		}
		return orden;
	}

	public Map<Integer, Float> getSizePartValue(Orden orden, int nClothingID) {
		Map<Integer, Float> mapPartValue = new HashMap<Integer, Float>();
		String[] partValues = Utility.getStrArray(orden.getSizePartValues());
		for (String partValue : partValues) {
			String[] pv = partValue.split(":");
			/** 把标准号的上衣臀围 西裤臀围区分 改成标准号与成衣一样 提交到BL里时 上衣臀围与西裤围臀围分开录 */
			// if("10204".equals(Utility.toSafeString(orden.getSizeAreaID()))
			// && orden.getSizeCategoryID() == 10054 //标准号
			// && partValue.contains(":") == false //西裤臀围
			// && nClothingID == 2000 &&
			// !"".equals(Utility.toSafeString(pv[0]))){
			// float value = Utility.toSafeFloat(pv[0]);
			// mapPartValue.put(10108, value);
			// }else{
			if (pv != null && pv.length == 2) {
				float value = Utility.toSafeFloat(pv[1]);
				mapPartValue.put(Utility.toSafeInt(pv[0]), value);
			}
			// 成衣尺寸西裤臀围取第二个
			if (pv != null && pv.length == 1 && partValue.contains(":") == false && nClothingID == 2000
			/* && orden.getSizeCategoryID() == 10053 */) {
				mapPartValue.remove(10108);
				mapPartValue.put(10108, Utility.toSafeFloat(pv[0]));
			}
			// }
		}
		return mapPartValue;
	}

	private boolean isBeforPlateMaking(Dict currentStatus) {
		return currentStatus.getSequenceNo() <= CDict.OrdenStatusPlateMaking.getSequenceNo();
	}

	public long getOrdensCount(String strKeyword, String strMemberCode, int nStatusID, int nClothingID, Date dealDate, Date dealToDate, Date fromDate, Date toDate, String strPubMemberID) {
		long count = 0;
		try {
			Query query = getOrdensQuery("COUNT(*)", strKeyword, strMemberCode, nStatusID, nClothingID, dealDate, dealToDate, fromDate, toDate, strPubMemberID);
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}

	public String updateOrdenStatus(String strOrdenID, int nStatusID, String strMemo) {

		String strResult = Utility.RESULT_VALUE_OK;
		try {

			Orden orden = this.getOrdenByID(strOrdenID);
			orden.setStatusID(nStatusID);
			orden.setMemo(strMemo);
			dao.saveOrUpdate(orden);

			if (CDict.OrdenStatusPlateMaking.getID().equals(orden.getStatusID())) {
				String strTemp = submitToERP(orden);
				if (StringUtils.isNotEmpty(strTemp)) {
					strResult = strTemp;
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		}

		return strResult;
	}

	// 删除
	public void removeOrdenByID(String strOrdenID) {
		dao.remove(Orden.class, strOrdenID);
	}

	public String removeOrdens(String removeIDs) {
		if (removeIDs.equals("")) {
			return "请选择待删除项";
		}

		Transaction transaction = null;
		Session session = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();

			String[] arrOrdenIDs = Utility.getStrArray(removeIDs);
			for (Object OrdenID : arrOrdenIDs) {
				if (OrdenID != null && OrdenID != "") {
					this.removeOrdenByID(session, Utility.toSafeString(OrdenID));
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

	private void removeOrdenByID(Session session, String strOrdenID) {
		dao.remove(session, Orden.class, strOrdenID);
	}

	private void removeOrdenDetailByID(String strOrdenID) {
		try {
			dao.remove(Orden.class, strOrdenID);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public String getDefaultClothingID() {
		return Utility.toSafeString(CDict.ClothingSuit2PCS.getID());
	}

	// 选择刺绣位置，没选择刺绣颜色和字体时，保存默认的颜色和字体
	public void Embroid(Orden orden) {
		String embroids = "";
		String[] positions = CDict.EMBROIDPOSITION.split(",");
		String[] colors = CDict.EMBROIDCOLOR.split(",");
		String[] fonts = CDict.EMBROIDFONT.split(",");
		String[] color = CDict.COLORS.split(",");
		String[] font = CDict.FONTS.split(",");
		if (orden.getComponents() != null && orden.getComponents().length() > 0) {
			String[] strComponentID = orden.getComponents().split(",");
			for (int i = 0; i < strComponentID.length; i++) {
				Dict dictId = DictManager.getDictByID(Utility.toSafeInt(strComponentID[i]));
				if (dictId != null) {
					for (int j = 0; j < positions.length; j++) {
						if (positions[j].equals(Utility.toSafeString(dictId.getParentID()))) {
							for (int c = 0; c < colors.length; c++) {// 颜色
								int n = 0;
								for (int ci = 0; ci < strComponentID.length; ci++) {
									Dict dictIdc = DictManager.getDictByID(Utility.toSafeInt(strComponentID[ci]));
									if (colors[c].equals(Utility.toSafeString(dictIdc.getParentID())) && c == j) {
										n++;
									}
								}
								if (n == 0 && c == j) {
									embroids += "," + color[j];
								}
							}
							for (int f = 0; f < colors.length; f++) {// 字体
								int n = 0;
								for (int ci = 0; ci < strComponentID.length; ci++) {
									Dict dictIdf = DictManager.getDictByID(Utility.toSafeInt(strComponentID[ci]));
									if (fonts[f].equals(Utility.toSafeString(dictIdf.getParentID())) && f == j) {
										n++;
									}
								}
								if (n == 0 && f == j) {
									embroids += "," + font[j];
								}
							}
							if (j == 2) {// 绣字大小
								int n = 0;
								for (int ci = 0; ci < strComponentID.length; ci++) {
									Dict dictIds = DictManager.getDictByID(Utility.toSafeInt(strComponentID[ci]));
									if (CDict.EMBROIDSIZE.equals(Utility.toSafeString(dictIds.getParentID()))) {
										n++;
									}
								}
								if (n == 0) {
									embroids += "," + CDict.SIZE;
								}
							}
						}
					}
				}
			}
			orden.setComponents(orden.getComponents() + embroids);
		}
	}

	/**
	 * 保存/提交订单
	 * 
	 * @param customer
	 * @param ordens
	 * @return
	 */
	public String submitOrdens(Customer customer, List<Orden> ordens) {
		String strResult = "";
		String strOrdenID = "";
		try {
			if (customer.getName() != null) {
				if (!customer.getName().equals(customer.getOldName()) || customer.getOldName() == null) {
					customer.setID(null);
				}
			}
			new CustomerManager().saveCustomer(customer);
			for (Orden orden : ordens) {
				if (customer.getName() != null) {
					orden.setCustomerID(customer.getID());
					orden.setCustomer(customer);
				}
				orden.setPubDate(new Date());
				this.Embroid(orden);

				// if (StringUtils.isEmpty(Utility.toSafeString(orden
				// .getStatusID()))
				// || CDict.OrdenStatusSaving.getID().equals(
				// orden.getStatusID())) {
				// if (orden.getAutoID() != null && orden.getAutoID() > 0) {
				// orden.setStatusID(CDict.OrdenStatusFabricNotArrive
				// .getID());
				// }
				// }

				if (StringUtils.isEmpty(orden.getOrdenID()) || orden.getOrdenID().length() == 36) {
					orden.setOrdenID(this.getNextOrdenID());
					orden.setSysCode(this.getNextSysCode());
				}
				orden.setIsStop(CDict.NO.getID());

				List<OrdenDetail> details = orden.getOrdenDetails();
				this.removeOrdenDetailByID(orden.getOrdenID());
				dao.saveOrUpdate(orden);

				// 面料价+加工费+工艺价格
				Double totalNum = Double.valueOf(0);

				if (details != null) {
					for (OrdenDetail detail : details) {
						detail.setOrdenID(orden.getOrdenID());
						dao.saveOrUpdate(detail);
						// 得到订单数量
						Integer amount = detail.getAmount();
						// 得到加工费
						Double cmtPrice = detail.getCmtPrice();
						// 得到面料价格
						Double fabricPrice = detail.getFabricPrice();
						// 得到工艺价格
						Double processPrice = detail.getProcessPrice();

						// 得到订单明细的价格
						totalNum += amount * (cmtPrice + fabricPrice + processPrice);
					}
				}

				Double ordenPrice = Double.valueOf(0);

				Member member = new MemberManager().getMemberByID(orden.getPubMemberID());
				ordenPrice = totalNum * member.getRetailDiscountRate() / 100;

				// 价格向上取整，并保留到十位
				// ordenPrice /= 10.0;
				// ordenPrice = Math.ceil(ordenPrice);
				// ordenPrice *= 10.0;

				// 保存订单价格
				orden.setOrdenPrice(ordenPrice);
				dao.saveOrUpdate(orden);

				// 如果订单的状态时“制版”“待支付”，说明客户想提交
				if (CDict.OrdenStatusStayPayments.getID().equals(orden.getStatusID()) || CDict.OrdenStatusPlateMaking.getID().equals(orden.getStatusID())) {
					Member parentMember = new MemberManager().getMemberByID(member.getParentID());
					Integer isDaBUser = BlMemberManager.isDaBUser(member.getGroupID(), parentMember.getGroupID());
					// 大B用户
					if (isDaBUser == 0) {
						strResult += processCash(orden.getPubMemberID(), member.getName(), ordenPrice, CDealItem.SUBMITORDENCUTMONEY, orden);
					}
					// 小B用户
					else if (isDaBUser == 1) {
						strResult += processCash(parentMember.getID(), member.getName(), ordenPrice, CDealItem.XIAOB_SUBMITORDENCUTMONEY, orden);
					}
					// 异常
					else {
						strResult += ResourceHelper.getValue("Cash_MemberError");
						orden.setStatusID(CDict.OrdenStatusSaving.getID());
						dao.saveOrUpdate(orden);
					}

				}

				// 用于订单支付
				strOrdenID += orden.getOrdenID() + "&";
			}
			HttpContext.setSessionValue("SESSION_ORDENID", strOrdenID.substring(0, strOrdenID.length() - 1));
			if (strResult.endsWith(",")) {
				strResult = strResult.substring(0, strResult.length() - 1);
			}
			return strResult;
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		}
		return strResult;
	}

	/**
	 * 预提交订单
	 * 
	 * @param customer
	 * @param ordens
	 * @return
	 */
	public String preSubmitOrdens(Customer customer, List<Orden> ordens, String tg, String tgkd, String fk, String type) {
		String strResult = "";
		try {
			if (customer.getName() != null) {
				if (!customer.getName().equals(customer.getOldName()) || customer.getOldName() == null) {
					customer.setID(null);
				}
			}
			for (Orden orden : ordens) {
				if (customer.getName() != null) {
					orden.setCustomerID(customer.getID());
					orden.setCustomer(customer);
				}
				orden.setPubDate(new Date());
				this.Embroid(orden);
				orden.setIsStop(CDict.NO.getID());
				strResult += preSubmitToERP(orden, tg, tgkd, fk, type);
			}
			if (strResult.endsWith(",")) {
				strResult = strResult.substring(0, strResult.length() - 1);
			}

			return strResult;
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		}
		return strResult;
	}

	private String preSubmitToERP(Orden orden, String tg, String tgkd, String fk, String type) {
		String strResult = "";
		try {
			String strTemp = new XmlManager().preSubmitToErp(orden, tg, tgkd, fk);
			System.out.println(orden.getOrdenID() + "预提交信息返回：" + new Date() + strTemp);
			String strCode = "";
			String strContent = "";
			String strReplaceContent = "";
			if (strTemp.length() > 0 && !"Bl_Error_152".equals(strTemp) && !"OK".equals(strTemp)) {
				Errors errors = (Errors) XmlManager.doStrXmlToObject(strTemp, Errors.class);
				for (ErrorMessage error : errors.getList()) {
					strCode = error.getCode();
					strContent = error.getContent();
					strReplaceContent = error.getReplaceContent();
					if ("1".equals(strCode) && "pre".equals(type)) {// 预提交--成功，返回code=1，Content=
																	// 单耗
						try {
							strResult = this.preSubmitInfo(strContent);
							// strResult =
							// ResourceHelper.getValue("Fabric_Usage")+" : "+strContent+" cm";
						} catch (Exception e) {
						}
					} else {// 失败，返回code=错误id，Content=错误信息，ReplaceContent=*替换值
						String strErrorValue = "";
						if (strCode.length() > 0) {// 存在code值
							strErrorValue = ResourceHelper.getValue("Bl_Error_" + strCode);
						} else {// 无code值
							strErrorValue = strContent;
						}
						if (null != strReplaceContent) {
							String[] strReplace = strReplaceContent.split("~");// 多个*值，以~隔开
							for (int i = 0; i < strReplace.length; i++) {
								strErrorValue = strErrorValue.replaceFirst("\\*", strReplace[i]);
							}
						}
						strResult += strErrorValue + " ";
					}
				}

			} else if ("Bl_Error_152".equals(strTemp)) {// 数据库连接
				strResult += ResourceHelper.getValue("Bl_Error_152") + " ";
			} else {
				strResult += " BL未返回信息! ";
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		}
		// strResult = this.preSubmitInfo("");
		return strResult;
	}

	public String preSubmitInfo(String strContent) {
		// strContent="{\"ordenNo\":\"XXXX13110588\",\"sizeCm\":159.0,\"sizeInch\":62.6,\"sizeInfo\":{\"MXF\":\"YXC:61.0,ZXC:61.0,XF:38.0,HYC:68.8,ZJK:43.5,ZYW:82.0,TU:97.0,XIONGW:95.0\",\"MXK\":\"YXC:61.0,ZXC:61.0,XF:38.0,HYC:68.8,ZJK:43.5,ZYW:82.0,TU:97.0,XIONGW:95.0\",\"MMJ\":\"YXC:61.0,ZXC:61.0,XF:38.0,HYC:68.8,ZJK:43.5,ZYW:82.0,TU:97.0,XIONGW:95.0\"}}";
		String strOrdenNo = Utility.toSafeString(EntityHelper.getValueByKey(strContent, "ordenNo"));
		String strSizeCm = Utility.toSafeString(EntityHelper.getValueByKey(strContent, "sizeCm"));
		String strSizeInch = Utility.toSafeString(EntityHelper.getValueByKey(strContent, "sizeInch"));
		String strSizeInfo = Utility.toSafeString(EntityHelper.getValueByKey(strContent, "sizeInfo"));
		String strMXFSize = Utility.toSafeString(EntityHelper.getValueByKey(strSizeInfo, "MXF"));
		String strMXKSize = Utility.toSafeString(EntityHelper.getValueByKey(strSizeInfo, "MXK"));
		String strMCYSize = Utility.toSafeString(EntityHelper.getValueByKey(strSizeInfo, "MCY"));
		String strMMJSize = Utility.toSafeString(EntityHelper.getValueByKey(strSizeInfo, "MMJ"));
		String strMDYSize = Utility.toSafeString(EntityHelper.getValueByKey(strSizeInfo, "MDY"));

		String str = "<table style='border: 1px solid #c69b6e;'><tr><td style='border: 1px solid #c69b6e;width:80px;'>" + ResourceHelper.getValue("Orden_Code") + "</td><td style='border: 1px solid #c69b6e;width:200px;'>" + strOrdenNo + "</td></tr>" + "<tr><td style='border: 1px solid #c69b6e;'>" + ResourceHelper.getValue("Fabric_Usage") + "</td><td style='border: 1px solid #c69b6e;'>" + strSizeCm + " cm &nbsp" + strSizeInch + " inch</td></tr>";

		String strSizeAll = strMXFSize + ";" + strMXKSize + ";" + strMCYSize + ";" + strMMJSize + ";" + strMDYSize + ";";
		String[] strClothingSize = strSizeAll.split(";");
		String strClothing = "";
		for (int i = 0; i < strClothingSize.length; i++) {
			if (!"".equals(strClothingSize[i])) {
				String sizes = "";
				String[] strSize = strClothingSize[i].split(",");
				int n = 0;
				for (int j = 0; j < strSize.length; j++) {
					String[] size = strSize[j].split(":");
					sizes += ResourceHelper.getValue("Size_" + size[0]) + ":" + size[1] + "&nbsp;&nbsp;";
					n = j + 1;
					if (n % 2 == 0) {
						sizes += "</br>";
					}
				}
				if (i == 0) {
					strClothing = "Dict_3";
				} else if (i == 1) {
					strClothing = "Dict_2000";
				} else if (i == 2) {
					strClothing = "Dict_3000";
				} else if (i == 3) {
					strClothing = "Dict_4000";
				} else if (i == 4) {
					strClothing = "Dict_6000";
				}

				str += "<tr><td style='border: 1px solid #c69b6e;'>" + ResourceHelper.getValue(strClothing) + ResourceHelper.getValue("Dict_10053") + "</td><td style='border: 1px solid #c69b6e;'>" + sizes + "</td></tr>";
			}
		}

		str += "</table>";

		return str;
	}

	/**
	 * 订单扣款处理
	 * 
	 * @param memberId
	 *            扣款账户的用户ID
	 * @param ordenMemberName
	 *            下单用户的用户名
	 * @param cashNum
	 *            订单的金额
	 * @param dealItemId
	 *            交易项目
	 * @param orden
	 *            订单
	 * @return
	 */
	private String processCash(String memberId, String ordenMemberName, Double cashNum, int dealItemId, Orden orden) {
		String strResult = "";
		Cash cash = new CashManager().getCashByMemberID(memberId);
		Member member = new MemberManager().getMemberByID(memberId);
		Member currentMember = CurrentInfo.getCurrentMember();
		// 如果是虚拟支付
		if (CDict.PAYTYPE_IMITATION.getID().equals(member.getPayTypeID())) {
			if (currentMember.getUserStatus() != null) {
				// 善融支付
				strResult += submitToERP(orden);
				if (!"".equals(strResult)) {
					return strResult;
				}
				/*System.out.println("善融支付：订单号"+orden.getOrdenID()+";金额"+cash.getNum());
				Deal deal = new Deal();
				Date dealDate = new Date(); // 交易日期
				deal.setAccountOut(cashNum);// 交易金额（支出）
				deal.setDealDate(new java.sql.Date(dealDate.getTime()));
				Double localNum = cash.getNum();
				deal.setDealItemId(dealItemId);
				deal.setOrdenId(orden.getOrdenID());// 订单ID（下单或撤销订单时必须填写）
				deal.setMemberId(memberId);// 用户ID
				deal.setLocalNum(localNum);
				deal.setMemo("建行支付");
				dao.saveOrUpdate(deal);*/
			} else {
				if (cash == null) {
					return ResourceHelper.getValue("Cash_AccountNotExists");
				} else if (cash.getNoticeNum() == null || cash.getStopNum() == null || cash.getNum() == null) {
					return ResourceHelper.getValue("Cash_AccountNotSet");
				} else {
					// 账户余额不为空，停用金额不为空，提醒金额不为空
					java.math.BigDecimal c = new java.math.BigDecimal(cash.getNum());// 扣款前余额
					java.math.BigDecimal d = new java.math.BigDecimal(cashNum); // 订单金额
					Double localNum = c.subtract(d).doubleValue(); // 扣款后余额
					if (localNum >= cash.getStopNum() || cash.getNoticeNum() < 0) {
						// 当前余额小于和等于停用金额或者提醒金额为负数，执行扣款
						Deal deal = new Deal();
						Double accountOut = cashNum; // 交易金额（支出）
						Date dealDate = new Date(); // 交易日期

						deal.setAccountOut(accountOut);
						deal.setDealDate(new java.sql.Date(dealDate.getTime()));
						if (CDealItem.XIAOB_SUBMITORDENCUTMONEY == dealItemId) {
							deal.setMemo(ordenMemberName);
						}
						deal.setDealItemId(dealItemId);
						deal.setOrdenId(orden.getOrdenID());// 订单ID（下单或撤销订单时必须填写）
						deal.setMemberId(memberId);// 用户ID
						deal.setLocalNum(localNum);
						Session session= DataAccessObject.openSessionFactory().openSession();
						Transaction transaction=session.beginTransaction();
						try {
							session.saveOrUpdate(deal);
							cash.setNum(localNum);
							session.saveOrUpdate(cash);
							// 提交ERP
							strResult += submitToERP(orden);
							if (!"".equals(strResult)) {
								transaction.rollback();
								return strResult;
							}else{
								transaction.commit();
							}
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
							transaction.rollback();
							return "ERROR-1";
						}finally{
							session.close();
						}
					} else {
						// 账户余额不足，不能提交订单！
						orden.setStatusID(CDict.OrdenStatusSaving.getID());
						dao.saveOrUpdate(orden);
						return ResourceHelper.getValue("Cash_AccountNotEnough");
					}
				}
			}
		} else {
			// 平台外支付或在线支付
			Deal deal = new Deal();
			Double accountOut = cashNum; // 交易金额（支出）
			Date dealDate = new Date(); // 交易日期
			Double localNum = cash.getNum() - cashNum; // 当前余额
			deal.setAccountOut(accountOut);
			deal.setDealDate(new java.sql.Date(dealDate.getTime()));
			if (CDealItem.XIAOB_SUBMITORDENCUTMONEY == dealItemId) {
				deal.setMemo(ordenMemberName);
			}
			deal.setDealItemId(dealItemId);
			deal.setOrdenId(orden.getOrdenID());// 订单ID（下单或撤销订单时必须填写）
			deal.setMemberId(memberId);// 用户ID
			deal.setLocalNum(localNum);
			dao.saveOrUpdate(deal);
			// 提交ERP
			strResult += submitToERP(orden);
		}
		return strResult;
	}

	private String submitToERP(Orden orden) {
		String strResult = "";
		try {
			// 待支付、制版
			if (CDict.OrdenStatusStayPayments.getID().equals(orden.getStatusID()) || CDict.OrdenStatusPlateMaking.getID().equals(orden.getStatusID())) {
				String strStatus= Utility.toSafeString(orden.getStatusID());
				orden.setStatusID(10035);
				dao.saveOrUpdate(orden);
				String strTemp = new XmlManager().submitToErp(orden);
				LogPrinter.info(orden.getOrdenID() + "错误信息返回时间：" + new Date() + strTemp);
				String strCode = "";
				String strContent = "";
				String strReplaceContent = "";
				if (strTemp.length() > 0 && !"Bl_Error_152".equals(strTemp) && !"Error".equals(strTemp)) {
					Errors errors = (Errors) XmlManager.doStrXmlToObject(strTemp, Errors.class);
					for (ErrorMessage error : errors.getList()) {
						strCode = error.getCode();
						strContent = error.getContent();
						strReplaceContent = error.getReplaceContent();
						if ("1".equals(strCode)) {// 成功，返回code=1，Content=交期
							try {
								SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
								Date date = sf.parse(strContent);
								orden.setJhrq(date);
								if("10030".equals(strStatus)){
									orden.setStatusID(10030);
								}else if("10039".equals(strStatus)){
									orden.setStatusID(10039);
								}
								System.out.println(strStatus+":"+orden.getStatusID()+":"+orden.getJhrq());
								dao.saveOrUpdate(orden);
							} catch (Exception e) {
								strResult += " 交期未返回! ";
							}
						} else {// 失败，返回code=错误id，Content=错误信息，ReplaceContent=*替换值
							String strErrorValue = "";
							if (strCode.length() > 0) {// 存在code值
								strErrorValue = ResourceHelper.getValue("Bl_Error_" + strCode);
							} else {// 无code值
								strErrorValue = strContent;
							}
							if (null != strReplaceContent) {
								// strErrorValue = strErrorValue.replace("*",
								// strReplaceContent) + " ";
								String[] strReplace = strReplaceContent.split("~");// 多个*值，以~隔开
								for (int i = 0; i < strReplace.length; i++) {
									strErrorValue = strErrorValue.replaceFirst("\\*", strReplace[i]);
								}
							}
							strResult += strErrorValue + " ";
						}
					}

				} else if ("Bl_Error_152".equals(strTemp)) {// 数据库连接
					strResult += ResourceHelper.getValue("Bl_Error_152") + " ";
				} else {
					strResult += " BL未返回信息! ";
				}
				if (strResult.length() > 0) {// 提交失败，保存订单
					LogPrinter.info(orden.getOrdenID() + "订单提交失败：" + new Date() + strResult);
					orden.setStatusID(10035);
					orden.setMemo("提交BL 失败 ");
					dao.saveOrUpdate(orden);
//					List<OrdenDetail> details = orden.getOrdenDetails();
//					if (details != null) {
//						for (OrdenDetail detail : details) {
//							detail.setOrdenID(orden.getOrdenID());
//							dao.saveOrUpdate(detail);
//						}
//					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.error(e.getMessage());
		}
		return strResult;
	}

	// 获取BL提示内容
	public String GetBLPrompt(String strTemp, String strOrdenId) {
		String strResult = "";
		String[] strTempAll = strTemp.split(";");
		for (int i = 0; i < strTempAll.length; i++) {
			String[] strTemps = strTempAll[i].split(",");
			String strBLName = "";
			if ("Bl_Error_".equals(strTemps[0])) {// 无错误提示
				for (int j = 2; j < strTemps.length; j++) {
					strBLName += strTemps[j];
				}
			} else {// 有错误提示
				strBLName = ResourceHelper.getValue(strTemps[0]);
				if (strBLName.indexOf('*') > 0) {// 有替换值
					strBLName = strBLName.replace("*", strTemps[1]) + " ";
				}
			}
			strResult += strBLName + " ";
		}

		return strResult;
	}

	private String getNextOrdenID() {
		Member currentMember = CurrentInfo.getCurrentMember();
		StringBuffer sbNext = new StringBuffer();
		sbNext.append(currentMember.getOrdenPre());
		if (currentMember.getOrdenPre().length() != 8) {
			sbNext.append(new SimpleDateFormat("yyMM").format(new Date()));
		}
		String strMaxOrdenID;
		try {
			String hql = "SELECT MAX(OrdenID) FROM Orden WHERE PubMemberID=?";
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
			query.setString(0, currentMember.getID());
			strMaxOrdenID = Utility.toSafeString(query.uniqueResult());
			if (strMaxOrdenID == null || "".equals(strMaxOrdenID)) {
				sbNext.append("0001");
			} else {
				sbNext.append(new DecimalFormat("0000").format(Utility.toSafeInt(strMaxOrdenID.substring(strMaxOrdenID.length() - 4, strMaxOrdenID.length())) + 1));
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return sbNext.toString();
	}

	private String getNextSysCode() {
		StringBuffer sbNext = new StringBuffer();
		// TODO 订单前缀
		Member currentMember = CurrentInfo.getCurrentMember();
		if (currentMember.getOrdenPre().length() != 8) {
			sbNext.append(Orden_Head);
		} else {
			sbNext.append("TX");
		}

		sbNext.append(new SimpleDateFormat("yyMMdd").format(new Date()));
		String strMaxSysCode;
		try {
			String hql = "SELECT MAX(SysCode) FROM Orden where syscode like '" + sbNext + "%'";
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
			strMaxSysCode = Utility.toSafeString(query.uniqueResult());
			if (strMaxSysCode == null || "".equals(strMaxSysCode)) {
				sbNext.append("0001");
			} else {
				sbNext.append(new DecimalFormat("0000").format(Utility.toSafeInt(strMaxSysCode.substring(strMaxSysCode.length() - 4, strMaxSysCode.length())) + 1));
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return sbNext.toString();
	}

	/*
	 * public List<?> getOrdenStatistic(boolean bAll, String strMemberID, Date
	 * from, Date to, int moneySignID) { List<?> result = null; try { Member
	 * member = new MemberManager().getMemberByID(strMemberID); String
	 * strMemberQuery = "AND m.Code = :MemberCode "; String strMemberCode =
	 * member.getCode(); if (bAll) { strMemberQuery =
	 * "AND m.Code LIKE :MemberCode "; strMemberCode += "%"; } String hql =
	 * "SELECT o.ClothingID,SUM(d.Amount),SUM(d.CmtPrice)+SUM(d.ProcessPrice)+SUM(d.FabricPrice) AS Price FROM Orden o,OrdenDetail d, Member m WHERE o.PubMemberID = m.ID AND d.OrdenID = o.OrdenID "
	 * ; hql += strMemberQuery; hql +=
	 * "AND o.PubDate > :FromDate AND o.PubDate <= :ToDate "; if(moneySignID
	 * >-1){ hql += " and m.MoneySignID= :moneySignID "; }
	 * 
	 * hql += "GROUP BY o.ClothingID"; SQLQuery query =
	 * DataAccessObject.openSession().createSQLQuery(hql);
	 * query.setString("MemberCode", strMemberCode); query.setDate("FromDate",
	 * from); query.setDate("ToDate", to); if(moneySignID >-1){
	 * query.setInteger("moneySignID", moneySignID); }
	 * 
	 * result = query.list(); } catch (Exception e) {
	 * LogPrinter.error(e.getMessage()); } finally {
	 * DataAccessObject.closeSession(); } return result; }
	 */

	public List<?> getOrdenStatistic(boolean bAll, String strMemberID, Date from, Date to, int moneySignID, int statusID) {
		List<?> result = null;
		try {
			Member member = new MemberManager().getMemberByID(strMemberID);
			String strMemberQuery = "AND m.Code = :MemberCode ";
			String strMemberCode = member.getCode();
			if (bAll) {
				strMemberQuery = "AND m.Code LIKE :MemberCode ";
				strMemberCode += "%";
			}
			String hql = "SELECT o.ClothingID,SUM(d.Amount),SUM(d.CmtPrice)+SUM(d.ProcessPrice)+SUM(d.FabricPrice) AS Price FROM Orden o,OrdenDetail d, Member m WHERE o.PubMemberID = m.ID AND d.OrdenID = o.OrdenID ";
			hql += strMemberQuery;
			hql += "AND o.PubDate > :FromDate AND o.PubDate <= :ToDate ";
			if (moneySignID > -1) {
				hql += " and m.MoneySignID= :moneySignID ";
			}
			if (statusID > -1) {
				hql += " and o.statusid= :statusID ";
			}
			hql += "GROUP BY o.ClothingID";
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
			query.setString("MemberCode", strMemberCode);
			query.setDate("FromDate", from);
			query.setDate("ToDate", to);
			if (moneySignID > -1) {
				query.setInteger("moneySignID", moneySignID);
			}
			if (statusID > -1) {
				query.setInteger("statusID", statusID);
			}
			result = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return result;
	}

	public List<?> getOrdenExportStatistic(String strMemberID, Date from, Date to, int moneySignID, int statusID) {
		List<?> result = null;
		try {
			Member member = new MemberManager().getMemberByID(strMemberID);
			String strMemberCode = member.getCode();
			String strMemberQuery = "AND m.Code LIKE :MemberCode ";
			strMemberCode += "%";
			// String hql =
			// "SELECT o.ClothingID,SUM(d.Amount),SUM(d.CmtPrice)+SUM(d.ProcessPrice)+SUM(d.FabricPrice) AS Price,o.statusid,m.MoneySignID FROM Orden o,OrdenDetail d, Member m WHERE o.PubMemberID = m.ID AND d.OrdenID = o.OrdenID ";
			String hql = "SELECT o.ClothingID,count(*),SUM(case when o.morepants=10050 then 1 when o.morepants=10051 then 1 else o.morepants end),SUM(case when o.morepants=10050 then 1 end),SUM(o.ordenprice) AS Price,o.statusid,m.MoneySignID FROM Orden o, Member m WHERE o.PubMemberID = m.ID  ";
			hql += strMemberQuery;
			hql += "AND o.PubDate > :FromDate AND o.PubDate <= :ToDate ";
			if (moneySignID > -1) {
				hql += " and m.MoneySignID= :moneySignID ";
			}
			if (statusID > -1) {
				hql += " and o.statusid= :statusID ";
			}
			hql += "GROUP BY o.ClothingID,m.MoneySignID,o.statusid order by o.ClothingID,o.statusid";
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
			query.setString("MemberCode", strMemberCode);
			query.setDate("FromDate", from);
			query.setDate("ToDate", to);
			if (moneySignID > -1) {
				query.setInteger("moneySignID", moneySignID);
			}
			if (statusID > -1) {
				query.setInteger("statusID", statusID);
			}
			result = query.list();
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return result;
	}

	public List<Dict> getStatusStatistic(String strMemberCode) {
		List<Dict> status = new ArrayList<Dict>();
		try {
			String hql = "SELECT o.StatusID,COUNT(1) FROM Orden o,Member m WHERE o.PubMemberID = m.ID AND m.Code LIKE  ?  AND o.IsStop = ? GROUP BY o.StatusID";
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
			query.setString(0, strMemberCode + "%");
			query.setInteger(1, CDict.NO.getID());
			List<?> result = query.list();
			for (Iterator<?> it = result.iterator(); it.hasNext();) {
				Object[] row = (Object[]) it.next();
				Dict dict = DictManager.getDictByID(Utility.toSafeInt(row[0]));
				dict.setName(dict.getName() + "(" + row[1] + ")");
				status.add(dict);
			}
			String hql1 = "SELECT o.IsStop,COUNT(1) FROM Orden o,Member m WHERE o.PubMemberID = m.ID AND m.Code LIKE  ? AND o.IsStop = ? GROUP BY o.IsStop";
			SQLQuery query1 = DataAccessObject.openSession().createSQLQuery(hql1);
			query1.setString(0, strMemberCode + "%");
			query1.setInteger(1, CDict.YES.getID());
			List<?> result1 = query1.list();
			for (Iterator<?> it1 = result1.iterator(); it1.hasNext();) {
				Object[] row = (Object[]) it1.next();
				if (row[0] != null) {
					Dict dict = DictManager.getDictByID(CDict.OrdenStatusStop.getID());
					dict.setName(dict.getName() + "(" + row[1] + ")");
					status.add(dict);
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return status;
	}

	public long getOverdueCount(String strMemberCode) {
		long count = 0;
		try {
			String hql = "SELECT COUNT(1) FROM Orden o,Member m WHERE o.PubMemberID = m.ID AND m.Code LIKE  ?";
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
			query.setString(0, strMemberCode + "%");
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}

		return count;
	}

	// 保存订单停滞原因
	public String updateOrdenStopCause(String strOrdenID, int nStopCauseID) {
		int nStopCause = Utility.toSafeInt(nStopCauseID);
		int nIsStop = 0;
		if (nStopCauseID > 0) {
			nIsStop = Utility.toSafeInt(CDict.YES.getID());
		} else {
			nIsStop = Utility.toSafeInt(CDict.NO.getID());
		}
		try {
			Orden orden = this.getOrdenByID(strOrdenID);
			orden.setIsStop(nIsStop);
			orden.setStopCause(nStopCause);
			dao.saveOrUpdate(orden);
			return Utility.RESULT_VALUE_OK;
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
			return e.getMessage();
		}
	}

	// 刺绣信息
	public String getTempSingleDesignedEmbroiderysName(List<Embroidery> emberoiderys) {
		String strSingleDesignedEmbroiderysName = "";
		for (Embroidery emberoidery : emberoiderys) {
			if (emberoidery != null) {
				if (emberoidery.getColor() != null) {
					strSingleDesignedEmbroiderysName += "<div class='depthDesign_Class'><label>" + DictManager.getDictNameByID(emberoidery.getColor().getParentID()) + "</label> : <font color='#FFBB77'>" + emberoidery.getColor().getName() + "</font></div>";
				}
				if (emberoidery.getFont() != null) {
					strSingleDesignedEmbroiderysName += "<div class='depthDesign_Class'><label>" + DictManager.getDictNameByID(emberoidery.getFont().getParentID()) + "</label> : <font color='#FFBB77'>" + emberoidery.getFont().getName() + "</font></div>";
				}
				if (emberoidery.getLocation() != null) {
					strSingleDesignedEmbroiderysName += "<div class='depthDesign_Class'><label>" + DictManager.getDictNameByID(emberoidery.getLocation().getParentID()) + "</label> : <font color='#FFBB77'>" + emberoidery.getLocation().getName() + "</font></div>";
				}
				if (emberoidery.getSize() != null) {
					strSingleDesignedEmbroiderysName += "<div class='depthDesign_Class'><label>" + DictManager.getDictNameByID(emberoidery.getSize().getParentID()) + "</label> : <font color='#FFBB77'>" + emberoidery.getSize().getName() + "</font></div>";
				}
				if (emberoidery.getContent() != null) {
					strSingleDesignedEmbroiderysName += "<div class='depthDesign_Class'><label>" + DictManager.getDictNameByID(421) + "</label> : <font color='#FFBB77'>" + emberoidery.getContent() + "</font></div>";
				}
			}
		}

		return strSingleDesignedEmbroiderysName;
	}

	// 工艺信息
	public String getTempSingleDesignedComponentsName(List<Dict> singleDesignedComponents, List<Dict> defaultComponents) {
		String strSingleDesignedComponentsName = "";
		if (singleDesignedComponents != null) {
			for (Dict component : singleDesignedComponents) {
				Dict parent = DictManager.getDictByID(component.getParentID());
				if (parent != null) {
					strSingleDesignedComponentsName += "<div class='process_Class'><label>" + parent.getName() + "</label> : <font color='#FFBB77'>" + component.getName() + "</font></div>";
				}
			}
		}
		if (defaultComponents != null) {
			for (Dict component : defaultComponents) {
				Dict parent = DictManager.getDictByID(component.getParentID());
				if (parent != null && parent.getIsShow() != null && parent.getIsShow() == 1) {
					strSingleDesignedComponentsName += "<div class='process_Class'><label>" + parent.getName() + "</label> : <font color='#FFBB77'>" + component.getName() + "</font></div>";
				}
			}
		}
		return strSingleDesignedComponentsName;
	}

	// 尺寸信息
	public String getTempSizePartName(Orden orden, int nClothingID) {
		// 默认值
		int nAreaID = -1;
		String strSpecHeight = "undefined";
		if (orden.getSizeCategoryID() == CDict.CLOTHINGSIZEID) {
			nAreaID = orden.getSizeAreaID();
			for (OrdenDetail od : orden.getOrdenDetails()) {
				if (Utility.toSafeString(nClothingID).equals(Utility.toSafeString(od.getSingleClothingID()))) {
					strSpecHeight = od.getSpecHeight();
				}
			}
		}
		/*
		 * if (orden.getSizeCategoryID() == CDict.CLOTHINGSIZEID) {// 西服、西裤
		 * 标准号加减 nAreaID = 10201;// 英美码 strSpecHeight = "34"; } if (nClothingID
		 * == CDict.ClothingChenYi.getID() && orden.getSizeCategoryID() ==
		 * CDict.CLOTHINGSIZEID) {// 衬衣 // 标准号加减 nAreaID = 10201;// 英美码
		 * strSpecHeight = "38/XXS"; }
		 */
		List<SizeStandard> sizeStandards = new SizeManager().getSizeStandard(nClothingID, orden.getSizeCategoryID(), nAreaID, strSpecHeight, "undefined", orden.getSizeUnitID());

		String strCY = "";
		if (orden.getClothingID() == 3000) {
			if (Utility.contains(orden.getComponents(), "3029")) {
				strCY = "3029";// 短袖
			}
		}

		int strUnitSize = orden.getSizeUnitID();
		String strPartNames = "";
		for (SizeStandard size : sizeStandards) {
			for (Map.Entry<Integer, Float> entry : this.getSizePartValue(orden, nClothingID).entrySet()) {
				Integer key = entry.getKey();
				Float value = entry.getValue();
				if (size.getPartID().equals(key)) {
					String str = "10113,10114,10135,10173";
					if (str.contains(Utility.toSafeString(size.getPartID()))) {
						// if((Utility.toSafeString(size.getPartID()).equals("10113")
						// ||
						// Utility.toSafeString(size.getPartID()).equals("10114"))){
						if (!"".equals(strCY) && Utility.toSafeString(size.getPleatID()).equals("3029")) {
							strPartNames += "<div class='partName_Class'><label>" + DictManager.getDictNameByID(key) + "</label> : <font color='#FFBB77'>" + value + "</font>";
							if (CDict.UnitInch.getID().equals(strUnitSize)) {
								strPartNames += " 英寸</div>";
							} else {
								strPartNames += " cm</div>";
							}
						} else if ("".equals(strCY) && !Utility.toSafeString(size.getPleatID()).equals("3029")) {
							strPartNames += "<div class='partName_Class'><label>" + DictManager.getDictNameByID(key) + "</label> : <font color='#FFBB77'>" + value + "</font>";
							if (CDict.UnitInch.getID().equals(strUnitSize)) {
								strPartNames += " 英寸</div>";
							} else {
								strPartNames += " cm</div>";
							}
						}
					} else {
						strPartNames += "<div class='partName_Class'><label>" + DictManager.getDictNameByID(key) + "</label> : <font color='#FFBB77'>" + value + "</font>";
						if (CDict.UnitInch.getID().equals(strUnitSize)) {
							strPartNames += " 英寸</div>";
						} else {
							strPartNames += " cm</div>";
						}
					}
				}
			}
		}
		return strPartNames;
	}

	public String getSizePartName(Orden orden, int nClothingID) {
		// 默认值
		int nAreaID = -1;
		String strSpecHeight = "undefined";
		if (orden.getSizeCategoryID() == CDict.CLOTHINGSIZEID) {
			nAreaID = orden.getSizeAreaID();
			for (OrdenDetail od : orden.getOrdenDetails()) {
				if (Utility.toSafeString(nClothingID).equals(Utility.toSafeString(od.getSingleClothingID()))) {
					strSpecHeight = od.getSpecHeight();
				}
			}
		}
		/*
		 * if (orden.getSizeCategoryID() == CDict.CLOTHINGSIZEID) {// 西服、西裤
		 * 标准号加减 nAreaID = 10201;// 英美码 strSpecHeight = "34"; } if (nClothingID
		 * == CDict.ClothingChenYi.getID() && orden.getSizeCategoryID() ==
		 * CDict.CLOTHINGSIZEID) {// 衬衣 // 标准号加减 nAreaID = 10201;// 英美码
		 * strSpecHeight = "38/XXS"; }
		 */
		List<SizeStandard> sizeStandards = new SizeManager().getSizeStandard(nClothingID, orden.getSizeCategoryID(), nAreaID, strSpecHeight, "undefined", orden.getSizeUnitID());

		String strCY = "";
		if (orden.getClothingID() == 3000) {
			if (Utility.contains(orden.getComponents(), "3029")) {
				strCY = "3029";// 短袖
			}
		}

		String strPartNames = "";
		for (SizeStandard size : sizeStandards) {
			for (Map.Entry<Integer, Float> entry : this.getSizePartValue(orden, nClothingID).entrySet()) {
				Integer key = entry.getKey();
				Float value = entry.getValue();
				if (size.getPartID().equals(key)) {
					String str = "10113,10114,10135,10173";
					if (str.contains(Utility.toSafeString(size.getPartID()))) {
						// if((Utility.toSafeString(size.getPartID()).equals("10113")
						// ||
						// Utility.toSafeString(size.getPartID()).equals("10114"))){
						if (!"".equals(strCY) && Utility.toSafeString(size.getPleatID()).equals("3029")) {
							strPartNames += "<label>" + DictManager.getDictNameByID(key) + "</label> : " + value + "&nbsp;";
						} else if ("".equals(strCY) && !Utility.toSafeString(size.getPleatID()).equals("3029")) {
							strPartNames += "<label>" + DictManager.getDictNameByID(key) + "</label> : " + value + "&nbsp;";
						}
					} else {
						strPartNames += "<label>" + DictManager.getDictNameByID(key) + "</label> : " + value + "&nbsp;";
					}
				}
			}
		}
		return strPartNames;
	}

	// 特体信息(除正常外)
	public String getTempBodyName(String strBodyID) {
		String BodyName = "";
		if (!"".equals(strBodyID) && strBodyID != null) {
			String[] bName = strBodyID.split(",");
			for (int i = 0; i < bName.length; i++) {
				if (CDict.NORMALBODY.indexOf(Utility.toSafeString(bName[i])) < 1) {
					BodyName += "<div class='partName_Class'><label>" + DictCategoryManager.getDictCategoryNameByID(DictManager.getDictByID(Utility.toSafeInt(bName[i])).getCategoryID()) + "</label>: <font color='#FFBB77'>" + DictManager.getDictNameByID(Utility.toSafeInt(bName[i])) + "</font></div>";
				}
			}
		}

		return BodyName;
	}

	// 加入默认工艺信息
	public List<Dict> GetComponent(List<Dict> singleDesignedComponents, int nSingleClothingID, String strFabricCode) {
		List<Dict> defaultComponent = new ClothingManager().getDefaultComponent(nSingleClothingID, strFabricCode);
		for (Dict components : singleDesignedComponents) {
			int componentParentID = components.getParentID();
			for (int j = 0; j < defaultComponent.size(); j++) {
				if (componentParentID == defaultComponent.get(j).getParentID()) {
					defaultComponent.remove(j);
				}
			}
		}
		return defaultComponent;
	}

	/**
	 * 将错误代码写入文件中 追加文件：使用FileOutputStream，在构造FileOutputStream时，把第二个参数设为true
	 * 
	 * @param fileName
	 * @param content
	 */
	public static void insertFile(String file, String conent) {
		BufferedWriter out = null;
		try {
			out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file, true)));
			out.write(conent);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				out.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public static String getNumber(String obj) {
		StringBuffer sbuf = new StringBuffer(obj);
		int i = sbuf.indexOf("+");
		if (i > 0) {
			return sbuf.substring(i + 1).toString();
		}
		return null;
	}

	// 修改订单状态
	public static int updateOrderStates(String strSysCode, String strChuKuDan, String strSstates, String strOrdenid) {
		System.out.println("更新订单：" + strSysCode + ";状态：" + strSstates + "出库单号：" + strChuKuDan);
		String strSQL = "UPDATE ORDEN SET statusid=?,chukudanid=? WHERE SYSCODE=? and ordenid=?";
		Transaction transaction = DataAccessObject.openSession().beginTransaction();
		Query query = DataAccessObject.openSession().createSQLQuery(strSQL);
		query.setString(0, strSstates);
		query.setString(1, strChuKuDan);
		query.setString(2, strSysCode);
		query.setString(3, strOrdenid);
		int i = query.executeUpdate();
		if (i > 0) {
			transaction.commit();
		} else {
			transaction.rollback();
		}
		return i;
	}

	// 修改订单状态10035、交货日期null
	public static int updateOrderStatusJhrq(String strSysCode) {
		int i = 0;
		int nStatusid = 10035;
		String strSQL = "UPDATE Orden o SET  o.StatusID=? ,o.Jhrq=? WHERE o.SysCode=?";
		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(strSQL);
			query.setInteger(0, nStatusid);
			query.setDate(1, null);
			query.setString(2, strSysCode);
			i = query.executeUpdate();
			transaction.commit();
		} catch (Exception e) {
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} finally {
			if (session != null) {
				session.close();
			}
		}
		return i;
	}

	/* 刺绣提示 */
	public String checkEmbroidery(List<Orden> ordens) {
		String strTS = "";
		String[] emb = CDict.EMBROID.split(",");
		String[] embposition = CDict.EMBROIDPOSITION.split(",");
		for (Orden orden : ordens) {
			int m = 0;
			int mm = 0;
			if (orden.getComponentTexts() != null && !"".equals(orden.getComponentTexts())) {// ComponentTexts
																								// 不为空
				String[] strComponentsTexts = orden.getComponentTexts().split(",");// ComponentTexts
				String[] strComponents = (orden.getComponents() == null ? "" : orden.getComponents().replace("_", ",")).split(",");// Components
				for (int i = 1; i < strComponentsTexts.length; i++) {
					String[] strId = strComponentsTexts[i].split(":");
					Dict dict = DictManager.getDictByID(Utility.toSafeInt(strId[0]));// 刺绣设计id
					for (int j = 0; j < emb.length; j++) {
						if (dict.getParentID() == Utility.toSafeInt(emb[j]) && strId.length > 1) {// 有刺绣内容
							m = 1;
							for (int n = 0; n < strComponents.length; n++) {
								if (!"".equals(strComponents[n])) {
									Dict gydict = DictManager.getDictByID(Utility.toSafeInt(strComponents[n]));// 刺绣位置id
									Dict parentdict = DictManager.getDictByID(gydict.getParentID());// 刺绣设计id
									if (dict.getParentID().equals(parentdict.getParentID()) && CDict.EMBROIDPOSITION.indexOf(Utility.toSafeString(parentdict.getID())) > -1) {// 有刺绣位置
										m = 2;
										break;
									}
								}
							}
							if (m == 1) {
								strTS = ResourceHelper.getValue("Embroidery_Error");
								return strTS;
							}
						}
					}
				}
			}

			if (orden.getComponents() != null && !"".equals(orden.getComponents())) {// Components
																						// 不为空
				String[] strComponentsTexts = (orden.getComponentTexts() == null ? "" : orden.getComponentTexts()).split(",");// ComponentTexts
				String[] strComponents = orden.getComponents().replace("_", ",").split(",");// Components
				for (int i = 0; i < strComponents.length; i++) {
					Dict gydict = DictManager.getDictByID(Utility.toSafeInt(strComponents[i]));// 刺绣位置id
					Dict parentdict = DictManager.getDictByID(gydict.getParentID());// 刺绣设计id
					for (int j = 0; j < embposition.length; j++) {
						if (gydict.getParentID() == Utility.toSafeInt(embposition[j])) {// 有刺绣位置
							mm = 1;
							if (orden.getComponentTexts() != null && !"".equals(orden.getComponentTexts())) {
								for (int n = 0; n < strComponentsTexts.length; n++) {
									String[] strId = strComponentsTexts[n].split(":");
									if (!"".endsWith(strId[0])) {
										Dict dict = DictManager.getDictByID(Utility.toSafeInt(strId[0]));
										if (dict.getParentID().equals(parentdict.getParentID()) && strId.length > 1) {// 有刺绣内容
											mm = 2;
											break;
										}
									}
								}
							}
							if (mm == 1) {
								strTS = ResourceHelper.getValue("Embroidery_Error");
								return strTS;
							}
						}
					}
				}
			}
		}
		return strTS;

	}

	// 判断刺绣内容长度
	public String checkEmbroideryContent(List<Orden> ordens) {
		String strError = "";
/*		for (Orden orden : ordens) {
			if (orden.getComponentTexts() != null && !"".equals(orden.getComponentTexts()) && orden.getComponents() != null) {// ComponentTexts不为空
				String[] strComponentsTexts = orden.getComponentTexts().split(",");// ComponentTexts
				String[] strComponents = orden.getComponents().split(",");// Components
				for (int n = 0; n < strComponentsTexts.length; n++) {
					String[] strId = strComponentsTexts[n].split(":");
//					if (!"".endsWith(strId[0]) && strId.length > 1 
//							&& ("421".equals(strId[0]) || "2207".equals(strId[0]) || "3676".equals(strId[0]) 
//									|| "4149".equals(strId[0]) || "6396".equals(strId[0]))) {// 有刺绣内容
					if (!"".endsWith(strId[0]) && strId.length > 1 && "3676".equals(strId[0])) {// 有刺绣内容-衬衣
						String[] texts = strId[1].split("_");
						Dict content = DictManager.getDictByID(Utility.toSafeInt(strId[0]));
						int num = 0;
						String tempStr = "";
						for (int i = 0; i < strComponents.length; i++) {
							tempStr = strComponents[i].indexOf("_") > 0 ? strComponents[i].split("_")[0] : strComponents[i];
							Dict componentDict = DictManager.getDictByID(Utility.toSafeInt(tempStr));
							Dict location = DictManager.getDictByID(componentDict.getParentID());
							String position = Utility.toSafeString(componentDict.getParentID());// 刺绣位置
//								if (content.getParentID().equals(location.getParentID()) && ("1218".equals(position) || "2507".equals(position) || "3201".equals(position) 
//										|| "4550".equals(position) || "6976".equals(position))) {// 刺绣位置
							if (content.getParentID().equals(location.getParentID()) && "3201".equals(position)) {// 刺绣位置-衬衣
								if (componentDict.getMemo() != null && String_length(texts[num]) > Utility.toSafeInt(componentDict.getMemo())) {
//										strError += componentDict.getName() + " 刺绣内容不能超过" + componentDict.getMemo() + "个字符<br/>";
									String err = ResourceHelper.getValue("Orden_CheckEmbroideryLen");
									err = err.replace("*", componentDict.getMemo());
									strError += componentDict.getName() + " " +err + "<br/>";
								}
								num++;
							}
						}
					}
				}
			}
		}*/
		return strError;
	}
	//判断中英文字符长度
	public static int String_length(String value) {
		int valueLength = 0;
		String chinese = "[\u4e00-\u9fa5]";
		for (int i = 0; i < value.length(); i++) {
			String temp = value.substring(i, i + 1);
			if (temp.matches(chinese)) {
				valueLength += 2;
			}else {
				valueLength += 1;
			}
		}
		return valueLength;
	}

	/* 加急订单修改交货日期 */
	/*public void saveJhrq(String strOrdenID, String strNewJhrq) {
		Date NewJhrq = Utility.toSafeDateTime(strNewJhrq);
		Orden orden = getOrdenByID(strOrdenID);
		Date OldJhrq = Utility.toSafeDateTime(orden.getJhrq());
		orden.setJhrq(NewJhrq);
		Calendar aCalendar = Calendar.getInstance();
		aCalendar.setTime(NewJhrq);
		int nDay1 = aCalendar.get(Calendar.DAY_OF_YEAR);
		aCalendar.setTime(OldJhrq);
		int nDay2 = aCalendar.get(Calendar.DAY_OF_YEAR);
		int nDay = nDay2 - nDay1;
		int priceUnit = CurrentInfo.getCurrentMember().getMoneySignID();
		if (priceUnit == CDict.MoneySignDollar.getID()) {
			orden.setOrdenPrice(orden.getOrdenPrice() + (nDay * 10));
		} else {
			orden.setOrdenPrice(orden.getOrdenPrice() + (nDay * 62));
		}
		dao.saveOrUpdate(orden);
		try {
			// 更新订单交期-BXPP
			Object[] params = new Object[] { orden.getSysCode(), strNewJhrq };
			Class<?>[] classTypes = new Class<?>[] { String.class, String.class };
			XmlManager.invokeService(WebService_Bxpp_Address, WebService_NameSpace, "doSaveDeliveryTime", params, classTypes);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}*/
	/**
	 * 获取订单衬类型
	 * @param ordenProcess 订单工艺信息
	 * @param typeID 衬类型parentid
	 * @return type 衬类型 ecode
	 */
	public String getSingleProcessType(String ordenProcess,String typeID){
		String type="";
		String[] process = ordenProcess.split(",");

		for(int i=0; i<process.length; i++){
			Dict dict = DictManager.getDictByID(Utility.toSafeInt(process[i]));
			if(dict != null && typeID.equals(Utility.toSafeString(dict.getParentID()))){
				type=dict.getEcode();
				break;
			}
		}
		
		return type;
	}
	/**
	 * 获取工艺类型--衬类型
	 * @param clothingID 服装分类
	 * @param process 订单工艺
	 * @param gyType 默认衬类型
	 * @return gyType 订单衬类型ecode
	 */
	public String getProcessType(int clothingID,String process,String gyType){
		String gyType1="";
		String gyType2="";
		String gyType3="";
		if(clothingID == 1 || clothingID == 2 || clothingID == 3 || clothingID == 6  || clothingID == 7){//西服
			gyType1=getSingleProcessType(process,"1230");//工艺类型
			gyType2=getSingleProcessType(process,"431");//衬类型
			if("".equals(gyType1) && !"".equals(gyType2)){
				gyType =gyType2;
			}else if("B022".equals(gyType1)){//全手工
				if("000A".equals(gyType2)){
					gyType ="0AAA";//全手工全毛衬
				}else if("000B".equals(gyType2) || "".equals(gyType2)){
					gyType ="0AAB";//全手工半毛衬
				}
			}else if("B023".equals(gyType1)){//半手工
				if("000A".equals(gyType2)){
					gyType ="00AA";//半手工全毛衬
				}else if("000B".equals(gyType2) || "".equals(gyType2)){
					gyType ="0BAA";//半手工半毛衬
				}
			}
		}else if(clothingID == 4000 || clothingID == 4){//马夹
			gyType3=getSingleProcessType(process,"4992");
			if(!"".equals(gyType3)){
				gyType=gyType3;
			}
		}else if(clothingID == 2000){//西裤
			gyType3=getSingleProcessType(process,"2224");
			if(!"".equals(gyType3)){
				gyType=gyType3;
			}
		}else if(clothingID == 6000){//大衣
			gyType3=getSingleProcessType(process,"6409");
			if(!"".equals(gyType3)){
				gyType=gyType3;
			}
		}else if(clothingID == 90000 || clothingID == 5){//礼服、礼服套装
			gyType3=getSingleProcessType(process,"90061");
			if(!"".equals(gyType3)){
				gyType=gyType3;
			}
		}else if(clothingID == 95000){//女西服
			gyType3=getSingleProcessType(process,"95001");
			if(!"".equals(gyType3)){
				gyType=gyType3;
			}
		}else if(clothingID == 98000){//女西裤
			gyType3=getSingleProcessType(process,"98019");
			if(!"".equals(gyType3)){
				gyType=gyType3;
			}
		}
		
		return gyType;
	}
	/**
	 * 计算 产品零售价定价规范 加急费用
	 * @param type 衬类型
	 * @param jhrq 工作日
	 * @param discounts 单价折算价格
	 * @return price 扣除加急费后的订单价格
	 */
	public double getPriceLS(String type, int jhrq, double discounts){
		double price=0.0;
		//产品零售价定价规范
		double pcs1 = 200;//5 8
		double pcs2 = 300;//4 7
		double pcs3 = 500;//3 6
		
		if("0AAA".equals(type) || "0AAB".equals(type) 
				|| "0AAD".equals(type) || "0AAC".equals(type)){
			if(jhrq==6){
				price=Math.floor(pcs3*discounts);
			}else if(jhrq==7){
				price=Math.floor(pcs2*discounts);
			}else if(jhrq==8){
				price=Math.floor(pcs1*discounts);
			}
		}else{
			if(jhrq==3){
				price=Math.floor(pcs3*discounts);
			}else if(jhrq==4){
				price=Math.floor(pcs2*discounts);
			}else if(jhrq==5){
				price=Math.floor(pcs1*discounts);
			}
		}
		
		return price;
	}
	/**
	 * 计算 面料加工费定价规范  加急费用
	 * @param type 衬类型
	 * @param jhrq 工作日
	 * @param discounts 单价折算价格
	 * @param cmtPrice CMT价格
	 * @param clothing 服装分类
	 * @return price 加急费用
	 */
	public double getPriceML(String type, int jhrq, String cmtPrice, String clothing){
		double price=0.0;
		//面料加工费定价规范
		double cmt_pcs1 = 0.3;//5 8
		double cmt_pcs2 = 0.7;//4 7
		double cmt_pcs3 = 1;//3 6
		
		String gyType=clothing+type;
		String[] cmt = cmtPrice.split(",");
		for(int i=0; i<cmt.length; i++){
			String[] cmtX = cmt[i].split(":");
			if(gyType.equals(Utility.toSafeString(cmtX[0]))){
				Double priceX = Utility.toSafeDouble(cmtX[1]);
				if("0AAA".equals(type) || "0AAB".equals(type) 
						|| "0AAD".equals(type) || "0AAC".equals(type)){
					if(jhrq==6){
						price=priceX*cmt_pcs3;
					}else if(jhrq==7){
						price=priceX*cmt_pcs2;
					}else if(jhrq==8){
						price=priceX*cmt_pcs1;
					}
				}else{
					if(jhrq==3){
						price=priceX*cmt_pcs3;
					}else if(jhrq==4){
						price=priceX*cmt_pcs2;
					}else if(jhrq==5){
						price=priceX*cmt_pcs1;
					}
				}
			}
		}
		
		return price;
	}
	/**
	 * 计算衬衣加急费用
	 * @param priceType 产品零售价定价规范、面料加工费定价规范
	 * @param jhrq 加急工作天数
	 * @param cmtPrice CMT价格
	 * @return 加急费用
	 */
	public double getPriceCY(int priceType, int jhrq, String cmtPrice){
		double price=0.0;
		//产品零售价定价规范
		double cy_3 = 100;
		double cy_4 = 60;
		double cy_5 = 40;
		//面料加工费定价规范
		double cmt_3=1;
		double cmt_4=0.7;
		double cmt_5=0.3;
		if(priceType == 20150 || priceType == 20137){//产品零售价定价规范（青岛红领制衣有限公司）
			if(jhrq==3){
				price=cy_3;
			}else if(jhrq==4){
				price=cy_4;
			}else if(jhrq==5){
				price=cy_5;
			}
		}else if(priceType == 20151){//面料加工费定价规范
			String[] cmt = cmtPrice.split(",");
			for(int i=0; i<cmt.length; i++){
				String[] cmtCY = cmt[i].split(":");
				if("MCY".equals(Utility.toSafeString(cmtCY[0]))){
					Double priceCY = Utility.toSafeDouble(cmtCY[1]);
					if(jhrq==3){
						price=priceCY*cmt_3;
					}else if(jhrq==4){
						price=priceCY*cmt_4;
					}else if(jhrq==5){
						price=priceCY*cmt_5;
					}
				}
			}
		}
		return price;
		
	}
	/**
	 * 订单加急 扣款、修改交货日期
	 * @param strOrdenID 订单号
	 * @param strNewJhrq 加急工作日
	 * @return 衬衣及普通衬 不得少于3个工作日，0AAA、0AAB不得少于6个工作日
	 */
	public String saveJhrq(String strOrdenID, String strNewJhrq) {
		String strResult=Utility.RESULT_VALUE_OK;
		//1.订单只进行一次加急操作
		Orden orden = getordenByOrderId(strOrdenID);//所选订单
		Date jhrqDate = orden.getJhrq();
		List<Deal> dealList = new BlDealManager().getDeals(orden.getPubMemberID(),strOrdenID,83);
		if(dealList.size()>0){
			strResult = ResourceHelper.getValue("JHRQ_Operating" );
			return strResult;
		}
		//2.计算价格
		Double price = 0.0;//加急费用
		int jhrq = Utility.toSafeInt(strNewJhrq);
		Member member = new MemberManager().getMemberByID(orden.getPubMemberID());//当前用户
		int priceType=member.getBusinessUnit();//产品零售价定价规范、面料加工费定价规范
		String process = orden.getComponents()==null?"":orden.getComponents();
		System.out.println("数量"+orden.getMorePants()+"|加急前："+strOrdenID+"|要求加急工作天数:"+jhrq+"|订单交货日期:"+orden.getJhrq()+"|订单价格:"+orden.getOrdenPrice()+"|"+new Date());
		int amount = orden.getMorePants();
		if(orden.getClothingID() == 3000){//衬衣 加急扣款
			price = getPriceCY(priceType, jhrq, member.getCmtPrice());
			price = price*amount;
			orden.setOrdenPrice(orden.getOrdenPrice()+price);
		}else{//套装、西服、西裤、马夹、大衣、礼服、女西服、女西裤 加急扣款
			String gyType=getProcessType(orden.getClothingID(),process,member.getLiningType());
			if(("0AAA".equals(gyType) || "0AAB".equals(gyType) || "0AAD".equals(gyType) || "0AAC".equals(gyType)) && jhrq<6){
				strResult =ResourceHelper.getValue("JHRQ_emergencyFee" );//"不能少于6个工作日";
			}else{//计算价格
				//单价折算
				double discounts_3 = 2/3.0;//西服
				double discounts_2000 = 1/3.0;//西裤
				double discounts_4000 = 1/6.0;//马夹
				double discounts_6000 = 9/10.0;//大衣
				
				
				if(orden.getMorePants() == 10050 || orden.getMorePants() == 10051){
					amount = 1;
				}
				
				if(priceType == 20150 || priceType == 20137){//产品零售价定价规范（青岛红领制衣有限公司）
					if(orden.getClothingID() == 1 || orden.getClothingID() == 2 || 
							orden.getClothingID() == 4  || orden.getClothingID() == 5 || 
							orden.getClothingID() == 6 || orden.getClothingID() == 7){//套装
						//一套
						price=getPriceLS(gyType, jhrq, 1);
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
						//追加一条西裤
						if(orden.getMorePants() == 10050){
							price += price*0.3;
							orden.setOrdenPrice(orden.getOrdenPrice()+price);
						}
					}else if(orden.getClothingID() == 3 || 
							orden.getClothingID() == 90000 || orden.getClothingID() == 95000){//上衣
						price=getPriceLS(gyType, jhrq, discounts_3);
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
					}else if(orden.getClothingID() == 2000 || orden.getClothingID() == 98000){//西裤
						price=getPriceLS(gyType, jhrq, discounts_2000);
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
						//追加一条西裤
						if(orden.getClothingID() == 2000 && orden.getMorePants() == 10050){
							price += price*2;
							orden.setOrdenPrice(orden.getOrdenPrice()+price);
						}

					}else if(orden.getClothingID() == 4000){//马夹
						price=getPriceLS(gyType, jhrq, discounts_4000);
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
					}else if(orden.getClothingID() == 6000){//大衣
						price=getPriceLS(gyType, jhrq, discounts_6000);
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
					}
				}else if(priceType == 20151){//面料加工费定价规范
					if(orden.getClothingID() == 1 || orden.getClothingID() == 2 || 
							orden.getClothingID() == 4 || orden.getClothingID() == 5 || 
							orden.getClothingID() == 6 || orden.getClothingID() == 7){//套装
						//一套
						price=getPriceML(gyType, jhrq, member.getCmtPrice(), "");
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
						//追加一条西裤
						if(orden.getMorePants() == 10050){
							price += price*0.3;
							orden.setOrdenPrice(orden.getOrdenPrice()+price);
						}
					}else if(orden.getClothingID() == 3){//上衣
						price=getPriceML(gyType, jhrq, member.getCmtPrice(), "MXF_");
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
					}else if(orden.getClothingID() == 2000){//西裤
						price=getPriceML(gyType, jhrq, member.getCmtPrice(), "MXK_");
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
						//追加一条西裤
						if(orden.getMorePants() == 10050){
							price += price*2;
							orden.setOrdenPrice(orden.getOrdenPrice()+price);
						}
					}else if(orden.getClothingID() == 4000){//马夹
						price=getPriceML(gyType, jhrq, member.getCmtPrice(), "MMJ_");
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
					}else if(orden.getClothingID() == 6000){//大衣
						price=getPriceML(gyType, jhrq, member.getCmtPrice(), "MDY_");
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
					}
					else if(orden.getClothingID() == 90000){//礼服
						price=getPriceML(gyType, jhrq, member.getCmtPrice(), "MLF_");
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
					}
					else if(orden.getClothingID() == 95000){//女西服
						price=getPriceML(gyType, jhrq, member.getCmtPrice(), "WXF_");
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
					}
					else if(orden.getClothingID() == 98000){//女西裤
						price=getPriceML(gyType, jhrq, member.getCmtPrice(), "WXK_");
						price = price*amount;
						orden.setOrdenPrice(orden.getOrdenPrice()+price);
					}
				}
			}
		}
		//3.保存扣款
		if(Utility.RESULT_VALUE_OK.equals(strResult)){
			boolean isCash = true;
			Double localNum = 0.0;
			String strMember = member.getID();
			Member parentMember = new MemberManager().getMemberByID(member.getParentID());
			Integer isDaBUser = BlMemberManager.isDaBUser(member.getGroupID(), parentMember.getGroupID());
			if (isDaBUser == 0) {// 大B用户
				strMember = member.getID();
			}else if (isDaBUser == 1) {// 小B用户
				strMember = parentMember.getID();
			}
			Cash cash = new CashManager().getCashByMemberID(strMember);
			if (CDict.PAYTYPE_IMITATION.getID().equals(member.getPayTypeID())) {
				if (cash == null) {
					return ResourceHelper.getValue("Cash_AccountNotExists");
				} else if (cash.getNoticeNum() == null || cash.getStopNum() == null || cash.getNum() == null) {
					return ResourceHelper.getValue("Cash_AccountNotSet");
				} else {
					// 账户余额不为空，停用金额不为空，提醒金额不为空
					java.math.BigDecimal c = new java.math.BigDecimal(cash.getNum());// 扣款前余额
					java.math.BigDecimal d = new java.math.BigDecimal(price); // 订单金额
					localNum = c.subtract(d).doubleValue(); // 扣款后余额
					if (localNum >= cash.getStopNum() || cash.getNoticeNum() < 0) {
						isCash = true;
					}else {// 账户余额不足！
						isCash = false;
						return ResourceHelper.getValue("Cash_AccountNotEnough");
					}
				}
			}
			if(isCash){
				try {// 更新订单交期-BXPP
					Object[] params = new Object[] { orden.getSysCode(), strNewJhrq };
					Class<?>[] classTypes = new Class<?>[] { String.class, String.class };
					String jhrqNew=(String)XmlManager.invokeService(WebService_Bxpp_Address, WebService_NameSpace, "doSaveDeliveryTime", params, classTypes);
					Errors errors = (Errors) XmlManager.doStrXmlToObject(jhrqNew, Errors.class);
					String strCode ="";
					String strContent ="";
					for (ErrorMessage error : errors.getList()){
						strCode = error.getCode();
						strContent = error.getContent();
						if ("1".equals(strCode)){
							try {
								SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
								Date date = sf.parse(strContent);
								orden.setJhrq(date);
								System.out.println("加急后："+strOrdenID+"|要求加急工作天数："+jhrq+"|新交货日期："+strContent+"|加急费："+price+"|"+new Date());
								if(jhrqDate.equals(date) || date.after(jhrqDate)){
									price=0.0;
								}
								strResult = jhrqCash(orden.getPubMemberID(), member.getName(), price, orden,CDealItem.EMERGENCY_FEE,cash,member,localNum);
							} catch (Exception e) {
								strResult = ResourceHelper.getValue("JHRQ_Error");
								e.printStackTrace();
							}
						}else{
							strResult = ResourceHelper.getValue("JHRQ_NoCreate")+strContent;
							System.out.println("未生成加急交期!Code:"+strCode+",Content:"+strContent);
						}
					}
				} catch (Exception e) {
					strResult = ResourceHelper.getValue("JHRQ_Error");
					e.printStackTrace();
				}
			}
		}
		
		return strResult;
	}
	/**
	 * 加急订单 现金扣费
	 * @param memberId 用户id
	 * @param ordenMemberName 用户姓名
	 * @param cashNum 扣款金额
	 * @param dealItemId 是否小B用户
	 * @param orden 订单信息
	 * @param itemID 加急费id 
	 * @param member 用户信息
	 * @param localNum 当前剩余金额 
	 * @return strResult 返回错误信息
	 */
	private String jhrqCash(String memberId, String ordenMemberName, Double cashNum, Orden orden,int itemID,Cash cash,Member member,Double localNum) {
		String strResult = Utility.RESULT_VALUE_OK;
		int dealItemId=0;
		Member parentMember = new MemberManager().getMemberByID(member.getParentID());
		Integer isDaBUser = BlMemberManager.isDaBUser(member.getGroupID(), parentMember.getGroupID());
		if (isDaBUser == 0) {// 大B用户
			dealItemId = CDealItem.SUBMITORDENCUTMONEY;
		}else if (isDaBUser == 1) {// 小B用户
			dealItemId = CDealItem.XIAOB_SUBMITORDENCUTMONEY;
		}else {// 异常
			strResult = ResourceHelper.getValue("Cash_MemberError");
			return strResult;
		}
		// 如果是虚拟支付
		if (CDict.PAYTYPE_IMITATION.getID().equals(member.getPayTypeID())) {
				Deal deal = new Deal();
				Double accountOut = cashNum; // 交易金额（支出）
				Date dealDate = new Date(); // 交易日期
				deal.setAccountOut(accountOut);
				deal.setDealDate(new java.sql.Date(dealDate.getTime()));
				if (CDealItem.XIAOB_SUBMITORDENCUTMONEY == dealItemId) {
					deal.setMemo(ordenMemberName);
				}
				deal.setDealItemId(itemID);
				deal.setOrdenId(orden.getOrdenID());// 订单ID（下单或撤销订单时必须填写）
				deal.setMemberId(memberId);// 用户ID
				deal.setLocalNum(localNum);
				Session session= DataAccessObject.openSessionFactory().openSession();
				Transaction transaction=session.beginTransaction();
				try {
					session.saveOrUpdate(deal);
					cash.setNum(localNum);
					session.saveOrUpdate(cash);
					//保存订单-交货日期、订单价格
					session.saveOrUpdate(orden);
					transaction.commit();
				} catch (Exception e) {
					e.printStackTrace();
					transaction.rollback();
					return "ERROR-1";
				}finally{
					session.close();
				}
		} else {
			// 平台外支付或在线支付
			Deal deal = new Deal();
			Double accountOut = cashNum; // 交易金额（支出）
			Date dealDate = new Date(); // 交易日期
			localNum = cash.getNum() - cashNum; // 当前余额
			deal.setAccountOut(accountOut);
			deal.setDealDate(new java.sql.Date(dealDate.getTime()));
			if (CDealItem.XIAOB_SUBMITORDENCUTMONEY == dealItemId) {
				deal.setMemo(ordenMemberName);
			}
			deal.setDealItemId(itemID);
			deal.setOrdenId(orden.getOrdenID());// 订单ID（下单或撤销订单时必须填写）
			deal.setMemberId(memberId);// 用户ID
			deal.setLocalNum(localNum);
			dao.saveOrUpdate(deal);
			//保存订单-交货日期、订单价格
			dao.saveOrUpdate(orden);
		}
		return strResult;
}		
	
	/**
	 * 根据订单ID更新发货信息
	 * 
	 * @param strOrdenId
	 *            订单ID
	 */
	public void updateOrdenById(String strOrdenId) {

		String strSQL = "UPDATE Orden SET DeliveryID='', DeliveryDate='' WHERE OrdenID=?";

		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(strSQL);
			query.setString(0, strOrdenId);
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
	}

	/**
	 * 获取用户已入库订单的数量
	 * 
	 * @param pubMemberID
	 *            用户ID
	 * @param type
	 * @return
	 */
	public long getStoragedOrdenAmount(String pubMemberID, String type) {
		long count = 0;
		try {
			String hql = "SELECT COUNT(*) FROM Orden o WHERE StatusID=:StatusID AND PubMemberID=:PubMemberID AND (o.DeliveryID = '' OR o.DeliveryID IS NULL)";
			if ("shirt".equals(type)) {
				hql = hql + " AND o.ClothingID=3000";
			} else {
				hql = hql + " AND o.ClothingID<>3000";
			}
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("PubMemberID", pubMemberID);
			// 状态为已入库的订单
			query.setInteger("StatusID", CDict.OrdenStatusStorage.getID());
			count = Utility.toSafeLong(query.uniqueResult());
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return count;
	}

	/**
	 * 获取用户已入库的订单
	 * 
	 * @param pubMemberID
	 *            用户ID
	 * @param type
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Orden> getStoragedOrdens(String pubMemberID, String type) {
		List<Orden> ordens = new ArrayList<Orden>();
		try {
			String hql = "SELECT o FROM Orden o, Member m,Customer c WHERE o.PubMemberID = m.ID AND c.ID = o.CustomerID  AND m.ID = ? AND o.StatusID=? AND (o.DeliveryID = '' OR o.DeliveryID IS NULL)";
			if ("shirt".equals(type)) {
				hql = hql + " AND o.ClothingID=3000";
			} else {
				hql = hql + " AND o.ClothingID<>3000";
			}
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString(0, pubMemberID);
			// 状态为已入库的订单
			query.setInteger(1, CDict.OrdenStatusStorage.getID());

			ordens = (List<Orden>) query.list();
			for (Orden orden : ordens) {
				extendOrden(orden);
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordens;
	}

	/**
	 * 获取客户列表
	 * 
	 * @param memberCode
	 * @param from
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Member> getBlOrdensClient(String memberCode, String from) {
		List<Member> ordens = new ArrayList<Member>();
		try {
			String hql = "SELECT DISTINCT m.ID,m.Name,m.GroupID FROM Orden o, Member m WHERE o.PubMemberID = m.ID AND m.Code LIKE :MemberCode";
			if ("BlViewOrdenList".equals(from)) {
				hql += "  AND o.statusID=:statusID";
			}
			hql += " ORDER BY m.GroupID ASC";
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
			query.setString("MemberCode", "%" + memberCode + "%");
			if ("BlViewOrdenList".equals(from)) {
				query.setInteger("statusID", CDict.STATUS_DELIVERED.getID());
			}
			List<Object[]> list = new ArrayList<Object[]>();
			list = query.list();
			if (list.size() > 0) {
				for (Object[] obj : list) {
					Member member = new Member();
					if (obj[0] != null) {
						member.setID(obj[0].toString());
					}
					if (obj[1] != null) {
						member.setName(obj[1].toString());
					}
					ordens.add(member);
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordens;
	}

	/**
	 * 获取memberCode下的所有子用户信息(存在订单为发货状态)
	 * 
	 * @param memberCode
	 * @param from
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Member> getBlOrdensClients(String memberCode, String from) {
		List<Member> ordens = new ArrayList<Member>();
		try {
			String hql = "SELECT DISTINCT m.ID,m.Name,m.GroupID FROM Orden o, Member m WHERE  m.Code LIKE :MemberCode AND o.statusID=:statusID and m.groupid  not in (10253,10254,10255,10256,10257,10258) ORDER BY m.GroupID ASC";
			SQLQuery query = DataAccessObject.openSession().createSQLQuery(hql);
			query.setString("MemberCode", "%" + memberCode + "%");
			query.setInteger("statusID", CDict.STATUS_DELIVERED.getID());
			List<Object[]> list = new ArrayList<Object[]>();
			list = query.list();
			if (list.size() > 0) {
				for (Object[] obj : list) {
					Member member = new Member();
					if (obj[0] != null) {
						member.setID(obj[0].toString());
					}
					if (obj[1] != null) {
						member.setName(obj[1].toString());
					}
					ordens.add(member);
				}
			}
		} catch (Exception e) {
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordens;
	}

	// 判断驳头宽是否在可选范围
	public String checkLapelWidth(List<Orden> ordens) {
		String str = "";
		for (Orden orden : ordens) {
			String[] strComponents = Utility.getStrArray((orden.getComponents() == null ? "" : orden.getComponents()));
			List<Dict> components = new ArrayList<Dict>();
			if (orden.getClothingID() == 1 || orden.getClothingID() == 2 || orden.getClothingID() == 3) {// 西服
				int num = 0;
				Dict component = DictManager.getDictByID(97);// 默认8.3
				Dict componentBT = DictManager.getDictByID(51);// 默认平驳头
				Dict componentKZ = DictManager.getDictByID(37);// 默认单排两粒扣
				for (String strComponent : strComponents) {
					Dict dict = DictManager.getDictByID(Utility.toSafeInt(strComponent));
					if (dict != null) {
						if (dict.getParentID() == 35) {// 前面扣
							componentKZ = dict;
						} else if (dict.getParentID() == 50) {// 平驳头
							componentBT = dict;
						} else if (dict.getParentID() == 82) {// 驳头宽
							num++;
							component = dict;
						}
					}
				}
				components.add(componentBT);
				components.add(componentKZ);
				if (num == 0 && componentBT.getID() != 884) {// 立领、无驳头宽
					String strLapelWidthId = new DictManager().getLapelWidthId(Utility.toSafeString(componentKZ.getID()), Utility.toSafeString(componentBT.getID()));
					component = DictManager.getDictByID(Utility.toSafeInt(strLapelWidthId));
				}
				// 立领无驳头宽
				if (component.getAffectedAllow() == null) {
					str = ResourceHelper.getValue("Error_BTK");
				} else {
					if (componentBT.getID() != 884 && !new ClothingManager().allowedByOther(components, component)) {
						str = ResourceHelper.getValue("Error_BTK");
					}
				}
			} else if (orden.getClothingID() == 6000) {// 大衣
				Dict component = null;
				Dict componentKZ = DictManager.getDictByID(6016);// 单排三粒扣
				Dict componentBT = DictManager.getDictByID(6030);// 戗驳头
				for (String strComponent : strComponents) {
					Dict dict = DictManager.getDictByID(Utility.toSafeInt(strComponent));
					if (dict != null) {
						if (dict.getParentID() == 6013) {// 前面扣
							componentKZ = dict;
						} else if (dict.getParentID() == 6028) {// 平驳头
							componentBT = dict;
						} else if (dict.getParentID() == 6997) {// 驳头宽
							component = dict;
						}
					}
				}
				components.add(componentBT);
				components.add(componentKZ);
				if (component != null && !new ClothingManager().allowedByOther(components, component)) {
					str = ResourceHelper.getValue("Error_BTK");
				}
			}
		}
		return str;

	}

	public String checkNameLabel(List<Orden> ordens) {
		String str = "";
		for (Orden orden : ordens) {
			Member m = CurrentInfo.getCurrentMember();
			if ((m.getBusinessUnit() == 20138 || m.getBusinessUnit() == 20144) && orden.getClothingID() <= 3) {// 凯妙、凯妙加盟商用户必录刺绣信息--客户名牌(除无客户名牌外)
				if (!orden.getComponents().contains("420_") && !Utility.contains(orden.getComponents(), "1590")) {
					str = ResourceHelper.getValue("Error_NameLabel");
					break;
				}
			} else if (!"".equals(orden.getComponents()) && orden.getClothingID() <= 3) {
				// 工艺录上客户名牌位置必须录刺绣信息--客户名牌
				String[] components = Utility.getStrArray(orden.getComponents());
				for (String com : components) {
					if (!"".equals(com) && !com.contains("_")) {
						Dict dict = DictManager.getDictByID(Utility.toSafeInt(com));
						if (dict.getParentID() == 1589 && dict.getID() != 1590 && !orden.getComponents().contains("420_")) {
							str = ResourceHelper.getValue("Error_NameLabel");
							break;
						}
					}
				}
			}
		}
		return str;
	}

	public List<Orden> embroideContents(List<Orden> ordens) {// 刺绣内容相同
		for (Orden orden : ordens) {
			String[] positions = Utility.getStrArray(CDict.EMBROIDPOSITION);
			if (!"".equals(orden.getComponents())) {
				for (String pos : positions) {
					int num = 0;
					Dict dictPosition = DictManager.getDictByID(Utility.toSafeInt(pos));
					String[] components = Utility.getStrArray(orden.getComponents());
					for (String com : components) {
						if (!"".equals(com)) {
							Dict dict = DictManager.getDictByID(Utility.toSafeInt(com));
							if (pos.equals(Utility.toSafeString(dict.getParentID()))) {
								num++;
							}
						}

					}
					if (num > 1) {
						String[] componentTexts = Utility.getStrArray(orden.getComponentTexts());
						for (String comText : componentTexts) {
							String[] contents = comText.split(":");
							if (contents.length == 2) {
								Dict dict = DictManager.getDictByID(Utility.toSafeInt(contents[0]));
								if (dictPosition.getParentID().equals(dict.getParentID())) {
									String strContent = comText;
									for (int i = 1; i < num; i++) {
										strContent += "_" + contents[1];
									}
									orden.setComponentTexts(orden.getComponentTexts().replace(comText, strContent));
								}
							}
						}
					}
				}
			}
		}
		return ordens;
	}

	public String ordenFabric(String strType, String strOrdenID, String strSysCode, String strFabricType, String strBigFabricLen, String strSmallFabricLen, String strFabricCode, String strNewFabricCode) {
		// strType: 2=放行，1=停滞
		String strError = "";
		String strSQL = "UPDATE Orden o SET  o.Memo=?,o.IsStop=?,o.StopCause=? WHERE o.OrdenID =? and o.SysCode=?";
		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(strSQL);
			String memo = "";
			if ("3".equals(strType)) {// 3=换面料
				memo = strOrdenID + " " + strFabricCode + " " + ResourceHelper.getValue("Fabric_Message_CHANGE") + " " + strNewFabricCode;
			} else {// 2=放行，1=停滞
				memo = strFabricType + "," + strFabricCode + "," + strBigFabricLen + "," + strSmallFabricLen;
			}
			query.setString(0, memo);// 面料长度
			if ("2".equals(strType)) {// 放行
				query.setInteger(1, CDict.NO.getID());
				query.setInteger(2, -1);
			} else if ("1".equals(strType)) {// 停滞
				query.setInteger(1, CDict.YES.getID());// 停滞
				query.setInteger(2, 20108);// 面料不够
			} else if ("3".equals(strType)) {// 换面料
				query.setInteger(1, CDict.NO.getID());
				query.setInteger(2, -1);
			}
			query.setString(3, strOrdenID);// 订单号
			query.setString(4, strSysCode);// 系统单号
			int i = query.executeUpdate();
			if (i > 0) {
				transaction.commit();

				Orden orden = this.getOrdenByID(strOrdenID);
				Message message = new Message();
				List<Message> messages = new ArrayList<Message>();
				message.setPubMemberID("4028198134569d0f013456a4cba90006");// 红领
				message.setReceiverID(orden.getPubMemberID());
				message.setPubDate(new Date());
				String content = "";
				if ("1".equals(strType)) {// 停滞
					content = ResourceHelper.getValue("Fabric_Message_" + strFabricType) + " " + strFabricCode;
					content += ResourceHelper.getValue("FabricSize_Message_2") + strBigFabricLen;
					content += ResourceHelper.getValue("FabricSize_Message_1") + strBigFabricLen;
					message.setContent(content);
					message.setTitle(strOrdenID + " " + ResourceHelper.getValue("Fabric_Message_NO"));
				} else if ("2".equals(strType)) {// 放行
					content = strOrdenID + " " + ResourceHelper.getValue("Fabric_Message_YES");
					message.setContent(content);
					message.setTitle(content);
				} else if ("3".equals(strType)) {// 换面料
					content = strOrdenID + " " + strFabricCode + " " + ResourceHelper.getValue("Fabric_Message_CHANGE") + " " + strNewFabricCode;
					message.setContent(content);
					message.setTitle(content);
				}
				messages.add(message);
				new MessageManager().saveMessages(messages);
				strError = "1";// 成功
			} else {
				strError = "0";// 无此订单
				transaction.rollback();
			}
		} catch (Exception e) {
			strError = "2";// 失败
			transaction.rollback();
			LogPrinter.error(e.getMessage());
		} /*
		 * finally { if (session != null) { session.close(); } }
		 */
		return strError;
	}

	/**
	 * 获得用户的面料价格
	 * 
	 * @param fabric
	 *            面料号
	 * @param member
	 *            用户
	 * @param nSize
	 *            订单数量
	 * @param strSort
	 *            分类
	 * @return
	 * @throws Exception
	 */

	public double getOrderDetailFabricPrice(Fabric fabric, Member member, int nSize, Integer singleClothingId) {
		double sumPrice = 0.0;
		FabricPriceManager fabricPriceManager = new FabricPriceManager();
		// 判断该面料对该用户当前时间段是否有折扣
		// 默认为无折扣
		Double discount = 100.0;
		FabricDiscount fabricDiscount = new FabricDiscountManager().getFabricDiscountByMemberAndFabricAndDate(fabric.getCode(), member.getID());
		if (fabricDiscount != null && !"".equals(fabricDiscount)) {
			discount = fabricDiscount.getDiscount();
		}
		// 查询用户经营单位查询用户面料价格
		double dFabricPrice = 0.0;
		if (CDict.FabricSupplyCategoryRedCollar.getID().equals(fabric.getFabricSupplyCategoryID())) {
			FabricPrice fabricPrice = new FabricPriceManager().getFabricPriceByAreaAndFabric(member.getBusinessUnit(), fabric.getCode());

			// 美元用户
			if (CDict.MoneySignDollar.getID().equals(member.getMoneySignID())) {
				dFabricPrice = Utility.toSafeDouble(fabricPrice.getDollarPrice());
				// 人民币用户
			} else {
				dFabricPrice = Utility.toSafeDouble(fabricPrice.getRmbPrice());
			}
		}
		if (nSize >= 2) {
			Fabricconsume fabricconsume = fabricPriceManager.getFabricConsume(member.getUsername(), "MXK"); // 客户对应的西裤单耗

			// 西装上衣
			if (CDict.ClothingShangYi.getID().equals(singleClothingId)) {
				Fabricconsume tFabricconsume = fabricPriceManager.getFabricConsume(member.getUsername(), "T"); // 客户对应的一套单耗
				java.math.BigDecimal c = new java.math.BigDecimal(String.valueOf(tFabricconsume.getFabricsize()));
				java.math.BigDecimal d = new java.math.BigDecimal(String.valueOf(fabricconsume.getFabricsize()));
				double size = c.subtract(d).doubleValue();
				dFabricPrice *= size;
			}

			// 西裤
			if (CDict.ClothingPants.getID().equals(singleClothingId)) {
				dFabricPrice *= fabricconsume.getFabricsize();
			}

			// 马甲
			if (CDict.ClothingMaJia.getID().equals(singleClothingId)) {
				Fabricconsume tFabricconsume = fabricPriceManager.getFabricConsume(member.getUsername(), "MMJ"); // 客户马甲
				dFabricPrice *= tFabricconsume.getFabricsize();
			}

			// 配件
			if (CDict.ClothingPeiJian.equals(singleClothingId)) {

			}
		} else if (nSize == 1) {
			Dict dict = DictManager.getDictByID(singleClothingId);
			Fabricconsume fabricconsume = fabricPriceManager.getFabricConsume(member.getUsername(), dict.getEcode()); // 客户单条的单耗
			dFabricPrice *= fabricconsume.getFabricsize();

		}
		sumPrice += dFabricPrice;// 面料的价格
		sumPrice *= discount; // 是否有折扣
		// 得到折扣后面料价格
		sumPrice /= 100.0;
		return sumPrice;
	}

	public double getProcessPrice(String strEcode, String strUsername) {
		String hql = " FROM Userdictprice up where up.username=:strUsername and code=:strEcode";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setString("strUsername", strUsername);
			query.setString("strEcode", strEcode);
			@SuppressWarnings("unchecked")
			List<Userdictprice> list = query.list();
			if (list != null && !list.isEmpty()) {
				return list.get(0).getPrice();
			}
		} catch (Exception e) {
			// TODO: handle exception
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return 0.0;
	}

	public double getCmtPrice(String componentIds, String nClothingID) {
		if (componentIds.indexOf(",") == componentIds.length() - 1) {
			componentIds = componentIds.substring(0);
		}
		return 0.00;
	}

	// 检查客户订单号是否必填、重复
	public String checkUserOrdenNo(List<Orden> ordens) {
		String strError = "";
		for (Orden orden : ordens) {
			Member member = new MemberManager().getMemberByID(orden.getPubMemberID());
			if (member.getIsUserNo() != null && member.getIsUserNo() == 10050 && "".equals(orden.getUserordeNo())) {
				strError += ResourceHelper.getValue("Error_UserOrdenNoNull");// 客户单号不为空！
			}
			if (!"".equals(orden.getUserordeNo())) {
				long count = 0;
				try {
					String hql = "SELECT COUNT(*) FROM Orden o WHERE UserordeNo =:UserordeNo AND OrdenID <>:OrdenID";
					Query query = DataAccessObject.openSession().createQuery(hql);
					query.setString("UserordeNo", orden.getUserordeNo());
					query.setString("OrdenID", orden.getOrdenID());
					count = Utility.toSafeLong(query.uniqueResult());
				} catch (Exception e) {
					LogPrinter.error(e.getMessage());
				} finally {
					DataAccessObject.closeSession();
				}
				if (count > 0) {
					strError += ResourceHelper.getValue("Error_UserOrdenNo");// 客户单号重复！
				}
			}
		}
		return strError;
	}

	/** 查询要更新同步的数据 */
	public List<Orden> findSynchronousOrdens() {
		List<Orden> ordenList = new ArrayList<Orden>();
		// String sqlhql =
		// "select * from Orden o where o.companyscode is not null and (o.SENDSTATUS != o.STATUSID or o.SENDSTATUS is not null)";
		String hql = "from Orden o where o.CompanysCode is not null and (o.SendStatus != o.StatusID  or o.SendStatus is null)";
		try {
			// Query query =
			// DataAccessObject.openSession().createSQLQuery(sqlhql);
			// ordenList = (List<Orden>) query.setResultTransformer(
			// Criteria.ALIAS_TO_ENTITY_MAP).list();

			Query query = DataAccessObject.openSession().createQuery(hql);
			ordenList = query.list();
		} catch (HibernateException e) {
			ordenList.clear();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordenList;
	}

	/** 查询要更新同步的数据 */
	public List<Orden> findSynchronousOrdensByCompanysCode(String companysCode) {
		List<Orden> ordenList = new ArrayList<Orden>();
		String hql = "from Orden o where o.CompanysCode = '" + companysCode + "' and (o.SendStatus != o.StatusID  or o.SendStatus is null) and o.StatusID in ('10031','10032','10033','10034')";

		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			ordenList = query.list();
		} catch (HibernateException e) {
			ordenList.clear();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordenList;
	}

	/** s根据 每次发送的条数 和总次数 查询要更新同步的数据 */
	public List<Orden> findSynchronousOrdensByCompanysCodeAndPage(String companysCode, int nPageIndex, int nPageSize) {
		List<Orden> ordenList = new ArrayList<Orden>();
		String hql = "from Orden o where o.CompanysCode = '" + companysCode + "' and (o.SendStatus != o.StatusID  or o.SendStatus is null) and o.StatusID in ('10031','10032','10033','10034')";
		// String hql = "from Orden o where o.OrdenID = 'MW12080005'";

		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			ordenList = query.list();
		} catch (HibernateException e) {
			ordenList.clear();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return ordenList;
	}

	/** s根据 每次发送的条数 和总次数 查询要更新同步的数据 */
	public String findSynchronousOrdenIDSByCompanysCodeAndPage(String companysCode, int nPageIndex, int nPageSize) {
		String ids = "";
		List<String> idArr = new ArrayList<String>();
		String hql = "SELECT o.OrdenID from Orden o where o.CompanysCode = '" + companysCode + "' and (o.SendStatus != o.StatusID  or o.SendStatus is null) and o.StatusID in ('10031','10032','10033','10034')";
		try {
			Query query = DataAccessObject.openSession().createQuery(hql);
			query.setFirstResult(nPageIndex * nPageSize);
			query.setMaxResults(nPageSize);
			idArr = query.list();
		} catch (HibernateException e) {
			// e.printStackTrace();
			LogPrinter.error(e.getMessage());
		} finally {
			DataAccessObject.closeSession();
		}
		return Arrays.toString(idArr.toArray());
	}

	/**
	 * 更新 发送成功的数据
	 * 
	 * @param sendData
	 */
	public void updateSendSuccessOrdens(String ids) {
		Session session = null;
		Transaction transaction = null;
		String hql = "update Orden o set o.SendStatus = o.StatusID where o.OrdenID in (" + ids + ")";

		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			session.createQuery(hql).executeUpdate();
			session.flush();
			session.clear();
			transaction.commit();
		} catch (HibernateException e) {
			transaction.rollback();
		} finally {
			session.close();
		}
		LogPrinter.info("订单发送状态更新完成");
	}

	/**
	 * 处理发送失败的订单
	 * 
	 * @param failedids
	 */
	public void updateSendfailedOrdens(String failedids) {
		Session session = null;
		Transaction transaction = null;
		String hql = "UPDATE Orden o set o.SendStatus = 0 where o.OrdenID in (" + failedids + ")";

		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			session.createQuery(hql).executeUpdate();
			session.flush();
			session.clear();
			transaction.commit();
		} catch (HibernateException e) {
			transaction.rollback();
		} finally {
			session.close();
		}
		LogPrinter.info("处理发送错误的订单" + failedids);
	}

	/**
	 * 验证款式工艺与录入工艺是否冲突
	 * 
	 * @param procInputs
	 * @param strID
	 */
	public boolean validateStyleProc(String procInputs, String strID, Integer clothingID) {
		List<CurableStyle> curableStyles = DictManager.getStyleNumByID(strID);
		StringBuffer ecodeBuffer = new StringBuffer();
		for (CurableStyle style : curableStyles) {
			ecodeBuffer.append(style.getCode() + ",");
		}
		String codesString = ecodeBuffer.toString();
		if (codesString.endsWith(",")) {
			codesString = codesString.substring(0, codesString.lastIndexOf(","));
		}
		List<Dict> styleDicts = new ArrayList<Dict>();
		List<Dict> inputDicts = new ArrayList<Dict>();

		String[] styleCode = codesString.split(",");
		String[] inputCode = procInputs.split(",");
		Dict tempDict = null;

		// 查出 款式表的工艺
		for (int i = 0; i < styleCode.length; i++) {
			tempDict = findDictByEcode(styleCode[i], clothingID);
			if (null != tempDict) {
				styleDicts.add(tempDict);
			}
		}
		// 查出录入的工艺
		for (int i = 0; i < inputCode.length; i++) {
			tempDict = findDictByEcode(inputCode[i], clothingID);
			if (null != tempDict) {
				inputDicts.add(tempDict);
			}
		}
		// 如果有录入 或 款式工艺为空 设置成冲突
		boolean isConflict = false;
		if ((curableStyles.size()>0 &&  styleDicts.isEmpty()) || inputDicts.isEmpty()) {
			isConflict = true;
			return isConflict;
		}

		// 验证是否冲突
		for (int i = 0; i < styleDicts.size(); i++) {
			for (int j = 0; j < inputDicts.size(); j++) {
				// 如果有相同的上级id
				if (styleDicts.get(i).getParentID() == inputDicts.get(j).getParentID() || styleDicts.get(i).getParentID().equals(inputDicts.get(j).getParentID())) {
					// 1 同一种工艺
					if (styleDicts.get(i).getID() == inputDicts.get(j).getID() || styleDicts.get(i).getID().equals(inputDicts.get(j).getID())) {
						isConflict = true;
						return isConflict;
					}
					// 2 同一上级id 但本身状态是10001
					if (styleDicts.get(i).getStatusID() == 10001 || inputDicts.get(j).getStatusID() == 10001) {
						isConflict = true;
						return isConflict;
					}
					// 3 父id 是10050的
					if (styleDicts.get(i).getParentID() == 10050 || inputDicts.get(j).getStatusID() == 10050) {
						isConflict = true;
						return isConflict;
					}
					// 4.1 款式工艺中有 无数量的 工艺(如无扣) 但是 录入工艺是有数量的(如一粒扣)
					if (styleDicts.get(i).getAffectedDisabled() != null && !"".equals(styleDicts.get(i).getAffectedDisabled()) && (inputDicts.get(j).getID().toString()).indexOf(styleDicts.get(i).getAffectedDisabled()) > 0) {
						isConflict = true;
						return isConflict;
					}
					// 4.2 录入工艺中有无数量工艺(无扣子) 但款式工艺中是有数量工艺
					if (inputDicts.get(j).getAffectedDisabled() != null && !"".equals(inputDicts.get(j).getAffectedDisabled()) && (styleDicts.get(i).getID().toString()).indexOf(inputDicts.get(j).getAffectedDisabled()) > 0) {
						isConflict = true;
						return isConflict;
					}
				}
			}
		}
		return isConflict;
	}

	/**
	 * 根据 ecode查得唯一工艺
	 * 
	 * @param ecode
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Dict findDictByEcode(String ecode, int clothingID) {
		Dict clothingDict = DictManager.getDictByID(clothingID);
		Dict dict = null;
		String hql = " from Dict d where d.Ecode = '" + ecode.toUpperCase() + "'";
		Session session = null;
		List<Dict> clothDictList = new ArrayList<Dict>();
		try {
			session = DataAccessObject.openSession();
			List<Dict> dictList = session.createQuery(hql).list();
			if (!dictList.isEmpty()) {
				for (Dict temp : dictList) {
					if (clothingDict.getCode().equals(temp.getCode().substring(0, 4))) {
						clothDictList.add(temp);
					}
				}
			}
			if (clothDictList.size() == 1) {
				dict = clothDictList.get(0);
			} else if (clothDictList.size() > 1) {
				boolean isSpecialProc = false;
				// 是否特殊工艺，如果是特殊工艺直接取特殊工艺
				for (Dict temp : clothDictList) {

					if (temp.getStatusID() != null && temp.getStatusID() == 10008) {
						dict = temp;
						isSpecialProc = true;
						break;
					}
				}
				// 已经判断不是特殊工艺的,是否是选定工艺，待定工艺取父id为待定工艺的
				if (!isSpecialProc) {
					// 五个待定 工艺，如果父id 是待定工艺 ，则直接选 取
					String procs = "2630,1184,6994,3021,4999";
					for (Dict temp : clothDictList) {
						if (temp.getParentID().toString().indexOf(procs) > 0) {
							dict = temp;
							break;
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}
		return dict;
	}

	/**
	 * 根据 ecode，ecode,ecode 查出对应 的 dict List
	 * 
	 * @param ecodes
	 * @return
	 */
	public List<Dict> findDictsByEcodes(String ecodes, int clothingID) {
		List<Dict> dicts = new ArrayList<Dict>();
		String[] ecodeArr = ecodes.split(",");
		Dict tempDict = null;
		for (int i = 0; i < ecodeArr.length; i++) {
			tempDict = findDictByEcode(ecodeArr[i], clothingID);
			if (null != tempDict) {
				dicts.add(tempDict);
			}
		}
		return dicts;
	}

	public void UpdateOrdenByComp(String ordenId, String code, String text) {
		String strSQL = "UPDATE Orden SET Components=?, ComponentTexts=? WHERE OrdenID=?";

		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(strSQL);
			query.setString(0, code);
			query.setString(1, text);
			query.setString(2, ordenId);
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
	}

	// 下单扣款订单状态、交货日期
	public void updateOrder(String ordenID, String statusID) {
		String strSQL = "UPDATE Orden o SET  o.StatusID=? ";
		if ("10035".equals(statusID) || "10370".equals(statusID)) {
			strSQL += " ,o.Jhrq=? ";
		}
		strSQL += " WHERE o.OrdenID=?";
		Session session = null;
		Transaction transaction = null;
		try {
			session = DataAccessObject.openSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(strSQL);
			query.setInteger(0, Utility.toSafeInt(statusID));
			if ("10035".equals(statusID)) {
				query.setDate(1, null);
				query.setString(2, ordenID);
			}
			if ("10030".equals(statusID)) {
				query.setString(1, ordenID);
			}
			if ("10370".equals(statusID)) {//状态为撤销
				query.setDate(1, null);
				query.setString(2, ordenID);
			}
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
	}
	
	public String checkSemiFinished(List<Orden> ordens) {
		String strError = "";
		for (Orden orden : ordens) {
			int num = 0;
			String[] process = orden.getComponents().split(",");
			String[] str = {"1993","2998","4998"};
			for(String semi : str){
				for(String pro : process){
					if(pro.equals(semi)){
						num++;
					}
				}
			}
			String clothing = orden.getClothingID().toString();
			if(num == 1 && ("1".equals(clothing) || "4".equals(clothing) || "6".equals(clothing))){
				strError = ResourceHelper.getValue("Orden_semiFinished");
				return strError;
			}else if((num == 1 || num == 2) && ("2".equals(clothing))){
				strError = ResourceHelper.getValue("Orden_semiFinished");
				return strError;
			}
		}
		
		return strError;
		
	}
	
	public String checkFabricCategroy(List<Orden> ordens){
		
		String strError = "";
		
		for (Orden orden : ordens) {
			if(orden.getFabricCode().trim().length()<4){
				strError = ResourceHelper.getValue("CHECK_FABRICLEN");//"面料编码长度不能小于4位字符!";
			}
			Fabric fabric = new FabricManager().getFabricByCode(orden.getFabricCode());
			if (CDict.FABRIC_HEAD.indexOf(orden.getFabricCode().substring(0, 2)+",")>-1 
					&& !"5000".equals(Utility.toSafeString(orden.getClothingID()))) {
				if(fabric == null){
					strError = ResourceHelper.getValue("CHECK_FABRICINFO");//"请维护面料信息!";
				}else{
					if("10050".equals(Utility.toSafeString(fabric.getIsStop()))){
						strError = ResourceHelper.getValue("CHECK_FABRICISSTOP");//"此面料已禁用!";
					}else{
						if ("8030".equals(Utility.toSafeString(fabric.getCategoryID())) && !"3000".equals(Utility.toSafeString(orden.getClothingID()))){//衬衣
							strError = ResourceHelper.getValue("CHECK_FABRICINFO_3000");//"此面料为衬衣面料,请选择正确面料!";
						}else if ("8050".equals(Utility.toSafeString(fabric.getCategoryID())) && !"6000".equals(Utility.toSafeString(orden.getClothingID()))){//大衣
							strError = ResourceHelper.getValue("CHECK_FABRICINFO_6000");//"此面料为大衣面料,请选择正确面料!";
						}else if ("8001".equals(Utility.toSafeString(fabric.getCategoryID())) 
								&& ("6000".equals(Utility.toSafeString(orden.getClothingID())) || "3000".equals(Utility.toSafeString(orden.getClothingID())))){//西服
							strError = ResourceHelper.getValue("CHECK_FABRICINFO_3");//"此面料为西服面料,请选择正确面料!";
						}
					}
				}
			}
		}
		return strError;
	}
	
	
}