package hongling.service.assemble;

import hongling.business.AssembleManager;
import hongling.business.StyleProcessManager;
import hongling.entity.StyleProcess;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import org.hibernate.HibernateException;
import org.hibernate.Query;

import chinsoft.business.EcodeRedirectManager;
import chinsoft.core.DataAccessObject;
import chinsoft.core.Utility;

public class ParseImportStyleUtil {
	private AssembleManager assembleDao = new AssembleManager();

	public List<StyleProcess> parseExcel(String path) throws Exception {
		List<StyleProcess> styleprocesses = new ArrayList<StyleProcess>();
		InputStream is = null;
		Workbook workbook = null;
		try {
			is = new FileInputStream(path);
			workbook = Workbook.getWorkbook(is);

			for (int numSheet = 0; numSheet < workbook.getNumberOfSheets(); numSheet++) {
				Sheet sheet = workbook.getSheet(numSheet);
				if (sheet == null) {
					continue;
				}
				int column = sheet.getColumns();
				int row = sheet.getRows();
				// System.out.println("共有" + row + "行，" + column + "列数据");
				StyleProcess styleprocess;
				for (int rownum = 1; rownum < row; rownum++) {
					styleprocess = new StyleProcess();
					// 第0列是序号
					// 1款式号
					Cell cell1 = sheet.getCell(1, rownum);
					styleprocess.setStyleCode(cell1.getContents());
					// 2面料
					Cell cell2 = sheet.getCell(2, rownum);
					styleprocess.setFabricCode(cell2.getContents());
					// 3款式工艺ID
					Cell cell3 = sheet.getCell(3, rownum);
					styleprocess.setProcess(cell3.getContents());
					// 4特殊工艺ID
					Cell cell4 = sheet.getCell(4, rownum);
					styleprocess.setSpecialProcess(cell4.getContents());
					// 5款式工艺ecode
					styleprocess.setProcessCode(cell3.getContents());
					// 6特殊工艺ecode
					styleprocess.setSpecialProcessCode(cell4.getContents());

					styleprocesses.add(styleprocess);
				}
			}
			// 操作完成时，关闭对象，释放占用的内存空间
			workbook.close();
			is.close();
		} catch (Exception e) {
			e.printStackTrace(System.out);
		} finally {
			if (is != null) {
				is.close();
			}
		}
		// 处理如果有代码拆分的
		List<StyleProcess> tagartList = new ArrayList<StyleProcess>();
		for (StyleProcess proc : styleprocesses) {
			tagartList.add(this.findCurableStyleBySplitEcode(proc));
		}

		return tagartList;
	}

	/**
	 * 处理代码拆分的，返回拆分后的款式工艺
	 * 
	 * @param ecode
	 * @return
	 */
	public static StyleProcess findCurableStyleBySplitEcode(StyleProcess proc) {
		String codes = proc.getProcess();

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
							proc.setProcess(codes);
						}
					}
				}
			}
		}
		return proc;
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
	public String validateImportCodes(List<StyleProcess> styleprocesses) {
		String result = "";
		StyleProcessManager manager = new StyleProcessManager();
		for (StyleProcess temp : styleprocesses) {
			if (manager.validateCode(temp.getStyleCode()) > 0) {
				result += temp.getStyleCode() + ",";
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
	public String validateImportData(List<StyleProcess> styleprocess) {

		String result = "";
		StyleProcessManager manager = new StyleProcessManager();

		String codeRegex = "^(\\w+\\,)*(\\w+){0,1}$";
//		String specialRegex = "(\\w+:[\\w\\u4e00-\\u9fa5\\ufe30-\\uffa0]+,)*(\\w+:[\\w\\u4e00-\\u9fa5\\ufe30-\\uffa0]+)*";
		String specialRegex = "(\\w+:...+,)*(\\w+:...+)*";
		for (StyleProcess temp : styleprocess) {

			/* 检查 code 不空 有无重复 */
			if (null == temp.getStyleCode() || "".equals(temp.getStyleCode())) {
				return "款式的code不能为空!  <br>";
			}
			/*
			 * if (manager.validateCode(temp.getStyleCode()) > 0) { result +=
			 * "代码" + temp.getStyleCode() + "已存在  \n"; }
			 */
			/* 检查 款式工艺 */
			if (temp.getProcess() != null && !"".equals(temp.getProcess())) {
				if (!temp.getProcess().matches(codeRegex)) {
					result += "代码是" + temp.getStyleCode() + "的工艺格式"+temp.getProcess()+"不正确  <br>";
				}

			}
			/* 检查 特殊工艺* */
			/*
			 * if (temp.getSpecialProcess() != null &&
			 * !"".equals(temp.getSpecialProcess())) {
			 *//******* 包含中文 正则表达式 配不上 ******************/
			/*
			 * if (temp.getSpecialProcess().trim().matches(specialRegex)) {
			 * result += "代码是" + temp.getStyleCode() + "的特殊工艺"+temp.getSpecialProcess()+"格式不正确  <br>"; }
			 * 
			 * }
			 */
			/* 检查 面料 */
			if (temp.getFabricCode() != null
					&& !"".equals(temp.getFabricCode())) {
				if (temp.getFabricCode().matches(codeRegex)) {

				} else {
					result += "代码是" + temp.getStyleCode() + "的面料"+temp.getFabricCode()+"格式不正确  <br>";
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
	public List<StyleProcess> saveFormatImport(List<StyleProcess> styleprocess) {
		StyleProcess temp = null;
		List<StyleProcess> tempList = new ArrayList<StyleProcess>();
		try {
			for (int num = 0; num < styleprocess.size(); num++) {
				temp = styleprocess.get(num);
				/* 处理款式工艺 */
				temp.setProcess(this.getProcessIDs(temp.getProcess(),
						temp.getSpecialProcess()));

				/* 处理特殊工艺 */
				temp.setSpecialProcess(this.getSpecialProcess(temp
						.getSpecialProcess()));
				
				if (Utility.contains(temp.getProcess(), "3029")) {// 工艺录入短袖
					temp.setShirt(3029);
				} else {// 默认长袖
					temp.setShirt(3028);
				}

				tempList.add(temp);
				temp = null;
			}
		} catch (Exception e) {

			e.printStackTrace();
			if (null != temp) {
				// System.out.println("处理导入文件格式时出现异常,code 是" + temp.getCode());
				temp.setID(0);
				tempList = new ArrayList<StyleProcess>();
				tempList.add(temp);
				return tempList;
			}
			System.out.println("处理导入文件时出异常，code不明");
			// e.printStackTrace();
		}
		return tempList;
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
			// 多条
			if (specEcode.indexOf(",") > 0) {
				specialProc = specEcode.split(",");
				for (int i = 0; i < specialProc.length; i++) {
					each = specialProc[i].split(":")[0];
					idmemos += ","
							+ assembleDao.getSpecialProcByEcode(each).getID()
									.toString() + ":"
							+ specialProc[i].split(":")[1];
				}
			} else if (specEcode.indexOf(":") > 0) {
				// 一条
				idmemos += ","
						+ assembleDao
								.getSpecialProcByEcode(specEcode.split(":")[0])
								.getID().toString() + ":"
						+ specEcode.split(":")[1];
			}
			return idmemos;
		}
		return null;

	}

}
