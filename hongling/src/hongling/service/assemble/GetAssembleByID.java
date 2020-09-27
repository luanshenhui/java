package hongling.service.assemble;

import hongling.business.AssembleManager;
import hongling.entity.Assemble;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.service.core.BaseServlet;

public class GetAssembleByID extends BaseServlet {
	@Override
	protected void service(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			super.service();

			int id = Utility.toSafeInt(getParameter("id"));
			Assemble assemble = new AssembleManager().findAssembleById(id);
			if (null != assemble.getClothingID()
					&& !"".equals(assemble.getClothingID())) {
				assemble.setClothName(new AssembleManager().getDictByID(
						assemble.getClothingID()).getName());
			}
			if (null != assemble.getStyleID()
					&& !"".equals(assemble.getStyleID())
					&& -1 != assemble.getStyleID()) {
				assemble.setStyleName(new AssembleManager().getDictByID(
						assemble.getStyleID()).getName());
			}

			/**************** 把工艺信息里的 特殊工艺处理掉 **********************/

			if (null != assemble.getSpecialProcess()
					&& !"".equals(assemble.getSpecialProcess())
					&& null != assemble.getProcess()) {
				String procIDs = assemble.getProcess();
				String specialStrs = assemble.getSpecialProcess();
				// 先把最前面的逗号去掉
				if (null != specialStrs && !"".equals(specialStrs)
						&& specialStrs.startsWith(",")) {
					specialStrs = specialStrs
							.substring(1, specialStrs.length());
				}
				String[] specialTemp = specialStrs.split(",");
				String ecode;
				String toIDS = "";

				String[] oneSpeproc;
				Dict dict;
				// 把 特殊工艺处理成 ,xx,xx,xx,格式 再把普通工艺中的 特殊工艺 ids去掉
				for (int i = 0; i < specialTemp.length; i++) {
					oneSpeproc = specialTemp[i].split(":");
					ecode = oneSpeproc[0];
					dict = new AssembleManager().getSpecialProcByEcode(ecode);
					if (null != dict) {
						toIDS += dict.getID() + ",";
					}
				}
				if (toIDS.endsWith(",")) {
					toIDS = toIDS.substring(0, toIDS.lastIndexOf(","));
				}
				if (procIDs.indexOf(toIDS) >= 0) {
					procIDs = procIDs.replace(toIDS, "");
					if (procIDs.endsWith(",")) {
						procIDs = procIDs
								.substring(0, procIDs.lastIndexOf(","));
					}
					assemble.setProcess(procIDs);
				}
			}
			// 编辑页面的 工艺信息显示
			String processIds = "";
			if (assemble.getProcess() != null) {
				processIds = assemble.getProcess();
				if (processIds.startsWith(",")) {
					processIds = processIds.substring(1, processIds.length());
				}
			}
			String processStr = new AssembleManager().getProcessStr(processIds);
			if (null != processStr && !"".equals(processStr)) {
				processStr = processStr.replace(",", "\n");
				assemble.setProcessDesc(processStr);
			}

			String viewFlag = request.getParameter("view");
			if (null != viewFlag
					&& (viewFlag == "view" || viewFlag.equals("view"))) {
				// 把 工艺的ID 字符 串变成 描述的字符串
				assemble.setProcess(new AssembleManager()
						.getProcessStr(assemble.getProcess()));
				// 把 特殊工艺的信息 字符 串变成 适用的字符串
				assemble.setSpecialProcess(new AssembleManager()
						.getSpecialProc(assemble));

			}
			output(assemble);
		} catch (Exception e) {
			e.printStackTrace();
			LogPrinter.debug("GetOrdenById_err" + e.getMessage());
		}
	}
}
