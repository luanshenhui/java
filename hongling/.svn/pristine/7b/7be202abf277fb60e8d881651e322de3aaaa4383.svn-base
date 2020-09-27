package hongling.service.assemble;

import hongling.business.AssembleManager;
import hongling.entity.Assemble;

import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CurrentInfo;
import chinsoft.core.EntityHelper;
import chinsoft.core.Utility;
import chinsoft.entity.Dict;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class SaveAssemble extends BaseServlet {
	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		String strResult = Utility.RESULT_VALUE_OK;

		try {
			super.service();
			String strFormData = getParameter("formData");

			Map<String, Object> maps = EntityHelper.jsonToMap(strFormData);

			Integer strAssID = Utility.toSafeInt((maps.get("ID") == null && ""
					.equals(maps.get("ID"))) ? null : maps.get("ID"));

			// 获得当前登陆用户
			Member loginUser = CurrentInfo.getCurrentMember();
			Assemble assemble = new Assemble();

			assemble = (Assemble) EntityHelper.updateEntityFromFormData(
					assemble, strFormData);
			assemble.setCreateBy(loginUser.getName());
			assemble.setCreateTime(new Date());
			assemble.setStatus(1);

			/** 把特殊工艺ids 加到普通工艺里 ************************************************************/
			// 页面获取的特殊工艺信息
			String specialIDS = (String) maps.get("specialProcess");

			if (null != specialIDS && !"".equals(specialIDS)) {
				if (specialIDS.startsWith(",")) {
					specialIDS = specialIDS.substring(1, specialIDS.length());
				}
				String ecode = "";
				String toIDS = "";
				String[] specialStrs = specialIDS.split(",");
				if (null != specialIDS && specialStrs.length != 0) {
					String[] oneSpeproc;
					Dict dict;
					for (int i = 0; i < specialStrs.length; i++) {
						oneSpeproc = specialStrs[i].split(":");
						ecode = oneSpeproc[0];
						dict = new AssembleManager()
								.getSpecialProcByEcode(ecode);
						if (null != dict) {
							toIDS += dict.getID() + ",";
						}
					}
				}
				String procids = (String) maps.get("process");
				procids += "," + toIDS;
				if (procids.endsWith(",")) {
					procids = procids.substring(0, procids.lastIndexOf(","));
				}
				if (procids.startsWith(",")) {
					procids = procids.substring(1, procids.length());
				}
				assemble.setProcess(procids);
			}
			/************* 特殊工艺 ,ecode:memo,ecode:memo得保存 成,id:memo,id:memo ******************************/
			specialIDS = new AssembleManager().formatSpecialProcess(specialIDS);
			assemble.setSpecialProcess(specialIDS);

			if (assemble.getClothingID() == 3000) {// 衬衣
				if (Utility.contains(assemble.getProcess(), "3029")) {// 工艺录入短袖
					assemble.setShirt(3029);
				} else {// 默认长袖
					assemble.setShirt(3028);
				}
			}

			if (maps.get("ID").toString() == null
					|| "".equals(maps.get("ID").toString())) {
				// System.out.println("添加");
				new AssembleManager().saveAssemble(assemble);
			} else {
				assemble.setID(Utility.toSafeInt(maps.get("ID")));
				// System.out.println("修改");
				new AssembleManager().updateAssemble(assemble);
			}
		} catch (Exception err) {
			output("error:" + err.getMessage());
			strResult = "保存失败";
			err.printStackTrace();
		}
		output(strResult);
	}
}
