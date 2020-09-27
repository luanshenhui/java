package chinsoft.service.orden;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import chinsoft.business.CDict;
import chinsoft.business.CDictCategory;
import chinsoft.business.ClothingManager;
import chinsoft.business.CurrentInfo;
import chinsoft.business.DictManager;
import chinsoft.business.FabricManager;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.entity.Component;
import chinsoft.entity.Detail;
import chinsoft.entity.Dict;
import chinsoft.entity.Member;
import chinsoft.service.core.BaseServlet;

public class GetTempFabricCode extends BaseServlet {

	private static final long serialVersionUID = -1759095872257443214L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
				output(getTempFabricCode());
		} catch (Exception e) {
			LogPrinter.info("该企业没有维护面料的价格或没有面料图片");
			LogPrinter.debug(e.getMessage());
		}
	}

}
