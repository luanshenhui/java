package hongling.service.assemble;

import hongling.business.AssembleManager;
import hongling.entity.Assemble;
import hongling.entity.StyleProcess;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;

import chinsoft.business.EcodeRedirectManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

public class ParseImportAssembleUtil {
	private AssembleManager assembleDao = new AssembleManager();

	public List<Assemble> parseExcel(String path) throws Exception {
		List<Assemble> assembles = new ArrayList<Assemble>();
		InputStream is = null;
		Workbook workbook = null;
		Sheet sheet = null;
		try {
			is = new FileInputStream(path);
			workbook = Workbook.getWorkbook(is);
			// sheetrowcolumn下标都是从0开始的

			for (int numSheet = 0; numSheet < workbook.getNumberOfSheets(); numSheet++) {
				sheet = workbook.getSheet(numSheet);
				if (sheet == null) {
					continue;
				}
				int column = sheet.getColumns();
				int row = sheet.getRows();
				// System.out.println("共有" + row + "行，" + column + "列数据");
				Assemble assemble;
				for (int rownum = 1; rownum < row; rownum++) {
					assemble = new Assemble();
					// 第0列是序号
					// 第一列1代码
					Cell cell1 = sheet.getCell(1, rownum);
					// if (cell1.getContents() == null
					// || "".equals(cell1.getContents())) {
					// continue;
					// }
					assemble.setCode(cell1.getContents());
					// 2服装分类
					Cell cell2 = sheet.getCell(2, rownum);
					assemble.setClothName(cell2.getContents());
					// 3款式风格
					Cell cell3 = sheet.getCell(3, rownum);
					assemble.setStyleName(cell3.getContents());
					// 4款式工艺
					Cell cell4 = sheet.getCell(4, rownum);
					assemble.setProcess(cell4.getContents());
					// 5特殊工艺
					Cell cell5 = sheet.getCell(5, rownum);
					assemble.setSpecialProcess(cell5.getContents());
					// 6类似品牌
					Cell cell6 = sheet.getCell(6, rownum);
					assemble.setBrands(cell6.getContents());
					// 7默认面料
					Cell cell7 = sheet.getCell(7, rownum);
					assemble.setDefaultFabric(cell7.getContents());
					// 8适用面料
					Cell cell8 = sheet.getCell(8, rownum);
					assemble.setFabrics(cell8.getContents());
					// 9中文标题
					Cell cell9 = sheet.getCell(9, rownum);
					assemble.setTitleCn(cell9.getContents());
					// 10杋标题
					Cell cell10 = sheet.getCell(10, rownum);
					assemble.setTitleEn(cell10.getContents());
					assembles.add(assemble);
				}
			}
			// 操作完成时，关闭对象，释放占用的内存空间
			workbook.close();
			is.close();
		} catch (Exception e) {
			Assemble temp = new Assemble();
			temp.setID(0);
			temp.setTitleCn("工作薄 " + sheet.getName() + " 信息不完整");
			assembles = new ArrayList<Assemble>();
			assembles.add(temp);
			return assembles;
		} finally {
			if (is != null) {
				is.close();
			}
		}

		// 处理如果有代码拆分的
		List<Assemble> tagartList = new ArrayList<Assemble>();
		for (Assemble assemble : assembles) {
			assemble.setProcess(this.findCurableStyleBySplitEcode(assemble
					.getProcess()));
			tagartList.add(assemble);
		}

		return tagartList;
	}

	/**
	 * 处理代码拆分的，返回拆分后的款式工艺
	 * 
	 * @param ecode
	 * @return
	 */
	public String findCurableStyleBySplitEcode(String codes) {
		String splitsStr = "";
		EcodeRedirectManager ecodeRedirectManager = new EcodeRedirectManager();
		if (null != codes && !"".equals(codes)) {
			// ecode,ecode如果dict里没再此ecode的数据，再查是否是代码拆分的
			if (codes.indexOf(",") > 0) {
				String[] codeArr = codes.split(",");
				for (String tempEcode : codeArr) {
					// dict表中没有数据才去查拆分表
					if (!dicthasecode(tempEcode)) {
						splitsStr = ecodeRedirectManager
								.findCodesBySplitEcode(tempEcode);
						// 将查到的拆分表的 拆分code:eocde,ecode替换原导入code中的拆分代码
						if (splitsStr != null && !"".equals(splitsStr)) {
							codes.replace(tempEcode, splitsStr);
						}
					}
				}
			}
		}
		return codes;
	}

	/**
	 * 判断dict中是否有 此代码 的工艺，如果有则不拆分
	 * 
	 * @param ecode
	 * @return
	 */
	private static boolean dicthasecode(String ecode) {
		long count = 0;
		StringBuffer hql = new StringBuffer();
		hql.append("SELECT COUNT(*)  FROM Dict d where d.Ecode = '" + ecode
				+ "'");
		try {
			Query query = DataAccessObject.openSession().createQuery(
					hql.toString());
			count = Utility.toSafeLong(query.uniqueResult());
			if (count > 0) {
				return true;
			}
			return false;
		} catch (HibernateException e) {
			return false;
		} finally {
			DataAccessObject.closeSession();
		}
	}

	/**
	 * 校验导入的excl的 code是否有重复 的
	 * 
	 * @param assembles
	 * @return
	 */
	public String validateImportCodes(List<Assemble> assembles) {
		String result = "";
		AssembleManager manager = new AssembleManager();
		for (Assemble temp : assembles) {
			if (manager.validateCode(temp.getCode()) > 0) {
				result += temp.getCode() + ",";
			}
		}
		if (result.endsWith(",")) {
			result = result.substring(0, result.lastIndexOf(","));
		}
		return result;
	}

	/**
	 * 检察数据合法性
	 * 
	 * @param assembles
	 * @return
	 */
	public String validateImportData(List<Assemble> assembles) {
		String result = "";
		AssembleManager manager = new AssembleManager();

		String allClothName = "MXF,MCY,MDY,MMJ,MXK";
		String allStyles = "SWXX,SWZZ,,SSXX,SSZZ,SSLF,SWLF";
		String codeRegex = "^(\\w+\\,)*(\\w+){0,1}$";
//		String specialRegex = "(\\w+:[\\w\\u4e00-\\u9fa5\\ufe30-\\uffa0]+,)*(\\w+:[\\w\\u4e00-\\u9fa5\\ufe30-\\uffa0]+)*";
		String specialRegex = "(\\w+:...+,)*(\\w+:...+)*";
		String tempCloth;
		String tempStyle;
		for (Assemble temp : assembles) {

			/* 检查 code 不空 有无重复 */
			if (null == temp.getCode() || "".equals(temp.getCode())) {
				return "款式的code不能为空!  <br/>";
			}
			if (manager.validateCode(temp.getCode()) > 0) {
				result += "代码" + temp.getCode() + "已存在 <br/>";
			}
			/* 检查 服装分类 */
			if (temp.getClothName() != null && !"".equals(temp.getClothName())) {
				tempCloth = temp.getClothName();
				if (allClothName.indexOf(tempCloth) < 0) {
					result += "代码是" + temp.getCode() + "的款式服装" + tempCloth
							+ "不正确  <br/>";
				}
			} else {
				result += "代码是" + temp.getCode() + "的款式服装不能为空  <br/>";
			}

			/* 检查 款式风格 */
			if (temp.getStyleName() != null && !"".equals(temp.getStyleName())) {
				tempStyle = temp.getStyleName();
				if (allStyles.indexOf(tempStyle) < 0) {
					result += "代码是" + temp.getCode() + "的款式风格"
							+ temp.getStyleName() + "不正确  <br/>";
				}
			} else {
				result += "代码是" + temp.getCode() + "的款式风格不能为空  <br/>";
			}

			/* 检查 款式工艺 */
			if (temp.getProcess() != null && !"".equals(temp.getProcess())) {
				if (!temp.getProcess().matches(codeRegex)) {
					result += "代码是" + temp.getCode() + "的工艺格式"
							+ temp.getProcess() + "不正确  <br/>";
				}

			}
			/* 检查 特殊工艺* */
			if (temp.getSpecialProcess() != null
					&& !"".equals(temp.getSpecialProcess())) {
				/******* 包含中文 正则表达式 配不上 ******************/
				if (!temp.getSpecialProcess().trim().matches(specialRegex)) {
					result += "代码是" + temp.getCode() + "的特殊工艺"
							+ temp.getSpecialProcess() + "格式不正确  <br/>";
				}

			}
			/* 检查 默认面料 */
			if (temp.getDefaultFabric() != null
					&& !"".equals(temp.getDefaultFabric())) {
				if (temp.getDefaultFabric().matches(codeRegex)) {

				} else {
					result += "代码是" + temp.getCode() + "的默认面料"
							+ temp.getDefaultFabric() + "格式不正确  <br/>";
				}
			}

			/* 检查 适用面料 */
			if (temp.getFabrics() != null && !"".equals(temp.getFabrics())) {
				if (temp.getFabrics().matches(codeRegex)) {

				} else {
					result += "代码是" + temp.getCode() + "的适用面料"
							+ temp.getFabrics() + "格式不正确  <br/>";
				}
			}
		}
		return result;
	}

	/**
	 * 处理导入 execle的保存格式
	 * 
	 * @param assembles
	 * @return
	 */
	public List<Assemble> saveFormatImport(List<Assemble> assembles) {
		Assemble temp = null;
		List<Assemble> tempList = new ArrayList<Assemble>();
		try {
			for (int num = 0; num < assembles.size(); num++) {
				temp = assembles.get(num);
				/* 处理服装分类 */
				temp.setClothingID(this.getClothingIDByName(temp.getClothName()));

				/* 处理 款式风格 */
				temp.setStyleID(this.getStyleIDByName(temp.getClothingID(),
						temp.getStyleName()));
				/* 处理款式工艺 */
				temp.setProcess(this.getProcessIDs(temp.getProcess(),
						temp.getSpecialProcess()));

				/* 处理特殊工艺 */
				temp.setSpecialProcess(this.getSpecialProcess(temp
						.getSpecialProcess()));
				
				if (temp.getClothingID() == 3000) {// 衬衣
					if (Utility.contains(temp.getProcess(), "3029")) {// 工艺录入短袖
						temp.setShirt(3029);
					} else {// 默认长袖
						temp.setShirt(3028);
					}
				}

				/******************* 数据库中存的是 code,code的 先不用处理了 ********************************************/
				/* 处理默认面料 */
				// temp.setDefaultFabric(this.getDefaultFabric(temp
				// .getDefaultFabric()));
				/* 处理适用面料 */
				// temp.setFabrics(this.getFabric(temp.getFabrics()));
				tempList.add(temp);
				temp = null;
			}
		} catch (Exception e) {

			e.printStackTrace();
			if (null != temp) {
				// System.out.println("处理导入文件格式时出现异常,code 是" + temp.getCode());
				temp.setID(0);
				tempList = new ArrayList<Assemble>();
				tempList.add(temp);
				return tempList;
			}
			System.out.println("处理导入文件时出异常，code不明");
			// e.printStackTrace();
		}
		return tempList;
	}

	/**
	 * 把导入文件中 服装的代码 转换成id
	 * 
	 * @param clothName
	 *            服装代码 如西服 MXf
	 * @return clothingID
	 */
	private Integer getClothingIDByName(String clothName) {
		Integer clothingID = null;
		if ("MXF".equals(clothName)) {
			clothingID = 3;
		} else if ("MXK".equals(clothName)) {
			clothingID = 2000;
		} else if ("MDY".equals(clothName)) {
			clothingID = 6000;
		} else if ("MMJ".equals(clothName)) {
			clothingID = 4000;
		} else if ("MCY".equals(clothName)) {
			clothingID = 3000;
		}
		return clothingID;
	}

	/**
	 * 把导入文件中的 款式风格代码 转换成ID
	 * 
	 * @param styleName
	 *            导入文件中的款式风格 如 商务休闲:SWXX,SWZZ,,SSXX,SSZZ,SSLF,SWLF
	 * @return styleID 款式风格 的dict id
	 */
	private Integer getStyleIDByName(Integer clothingID, String styleName) {
		Integer styleID = null;
		// System.out.println(clothingID+":"+styleName);
		switch (clothingID) {
		case 3:// 西服上衣 code 0003
			if ("SWXX".equals(styleName)) {// 商务休闲
				styleID = 30885;
			} else if ("SWZZ".equals(styleName)) {// 商务正装
				styleID = 30887;
			} else if ("SSXX".equals(styleName)) {// 时尚休闲
				styleID = 30886;
			} else if ("SSZZ".equals(styleName)) {// 时尚正装
				styleID = 30888;
			} else if ("SSLF".equals(styleName)) {// 时尚礼服
				styleID = 30890;
			} else if ("SWLF".equals(styleName)) {// 商务礼服
				styleID = 30889;
			}
			break;
		case 2000:// 西裤 code 0004
			if ("SWXX".equals(styleName)) {// 商务休闲
				styleID = 40186;
			} else if ("SWZZ".equals(styleName)) {// 商务正装
				styleID = 40188;
			} else if ("SSXX".equals(styleName)) {// 时尚休闲
				styleID = 40187;
			} else if ("SSZZ".equals(styleName)) {// 时尚正装
				styleID = 40189;
			} else if ("SSLF".equals(styleName)) {// 时尚礼服
				styleID = 40191;
			} else if ("SWLF".equals(styleName)) {// 商务礼服
				styleID = 40190;
			}
			break;
		case 3000: // 衬衣 code 0006
			if ("SWXX".equals(styleName)) {// 商务休闲
				styleID = 50133;
			} else if ("SWZZ".equals(styleName)) {// 商务正装
				styleID = 50135;
			} else if ("SSXX".equals(styleName)) {// 时尚休闲
				styleID = 50134;
			} else if ("SSZZ".equals(styleName)) {// 时尚正装
				styleID = 50136;
			} else if ("SSLF".equals(styleName)) {// 时尚礼服
				styleID = 50138;
			} else if ("SWLF".equals(styleName)) {// 商务礼服
				styleID = 50137;
			}
			break;
		case 4000: // 马甲 code 0005
			if ("SWXX".equals(styleName)) {// 商务休闲
				styleID = 4658;
			} else if ("SWZZ".equals(styleName)) {// 商务正装
				styleID = 4660;
			} else if ("SSXX".equals(styleName)) {// 时尚休闲
				styleID = 4659;
			} else if ("SSZZ".equals(styleName)) {// 时尚正装
				styleID = 4661;
			} else if ("SSLF".equals(styleName)) {// 时尚礼服
				styleID = 4663;
			} else if ("SWLF".equals(styleName)) {// 商务礼服
				styleID = 4662;
			}
			break;
		case 6000:// 大衣 code 0007
			if ("SW".equals(styleName)) {//商务
				styleID = 6657;
			} else if ("XX".equals(styleName)) {// 休闲
				styleID = 6169;
			}
			break;
		default:
			styleID = null;
			break;
		}
		return styleID;
	}

	/**
	 * 把导入文件的所有工艺 ecode,ecode..和ecode:memo,ecode:memo处理成id,id,id...
	 * 
	 * @param procEcode
	 *            普通工艺的 ecode,ecode...
	 * @param specEcode
	 *            特殊工艺的 ecode:memo,ecode:memo...
	 * @return 处理好 id,id,id...
	 * @throws Exception
	 *             异常往上抛
	 */
	private String getProcessIDs(String procEcode, String specEcode)
			throws Exception {
		String[] processTemp;
		String[] specialProc;
		String each;
		String procIDS = "";
		if (null != procEcode && !"".equals(procEcode)) {
			// 多条工艺信息
			if (procEcode.indexOf(",") > 0) {
				processTemp = procEcode.split(",");
				// System.out.println(Arrays.toString(processTemp));
				for (int i = 0; i < processTemp.length; i++) {
					each = processTemp[i];
					// System.out.println(each);
					procIDS += assembleDao.getProcByEcode(each).getID()
							.toString()
							+ ",";
				}
			} else {
				// 一条工艺信息
				procIDS = assembleDao.getProcByEcode(procEcode).getID()
						.toString();
			}

		}
		if (null != specEcode && !"".equals(specEcode)) {
			// 把普通工艺的最后一个豆号切掉
			if (procIDS.endsWith(",")) {
				procIDS = procIDS.substring(0, procIDS.lastIndexOf(","));
			}
			/*********** 拼接特殊工艺的 ids *************************/
			if (specEcode.indexOf(",") > 0) {
				specialProc = specEcode.split(",");
				for (int i = 0; i < specialProc.length; i++) {
					procIDS += ","
							+ assembleDao
									.getSpecialProcByEcode(
											specialProc[i].split(":")[0])
									.getID().toString();
				}
			} else if (specEcode.indexOf(":") > 0) {
				procIDS += ","
						+ assembleDao
								.getSpecialProcByEcode(specEcode.split(":")[0])
								.getID().toString();
			}
		}
		if (procIDS.startsWith(",")) {
			procIDS = procIDS.substring(1, procIDS.length());
		}
		if (procIDS.endsWith(",")) {
			procIDS = procIDS.substring(0, procIDS.lastIndexOf(","));
		}

		return procIDS;
	}

	/**
	 * 把导入文件的 特殊工艺 ecode:memo,ecode:memo 处理成 id:memo,id:memo...
	 * 
	 * @param specEcode
	 *            导入的特殊工艺信息 ecode:memo...
	 * @return 处理过的特殊工信息 id:memo...
	 */
	private String getSpecialProcess(String specEcode) throws Exception {
		if (null != specEcode && !"".equals(specEcode)) {
			String idmemos = "";
			String[] specialProc;
			String each;
			if (null != specEcode && !"".equals(specEcode)) {
				// 多条
				if (specEcode.indexOf(",") > 0) {
					specialProc = specEcode.split(",");
					for (int i = 0; i < specialProc.length; i++) {
						each = specialProc[i].split(":")[0];
						idmemos += ","
								+ assembleDao.getSpecialProcByEcode(each)
										.getID().toString()
								+ ":"
								+ (specialProc[i].split(":").length > 1 ? specialProc[i]
										.split(":")[1] : "");
					}
				} else if (specEcode.indexOf(":") > 0) {
					// 一条
					idmemos += ","
							+ assembleDao
									.getSpecialProcByEcode(
											specEcode.split(":")[0]).getID()
									.toString()
							+ ":"
							+ (specEcode.split(":").length > 1 ? specEcode
									.split(":")[1] : "");
				}
				return idmemos;
			}
		}
		return null;

	}

	private String getDefaultFabric(String defaultFabricStr) {
		return null;
	}

	private String getFabric(String fabricStr) {
		if (fabricStr.indexOf(",") > 0) {
		} else {
			// 一条
			// assembleDao.getSpecialProcByEcode(temp.getProcess());
		}
		return null;
	}

}
