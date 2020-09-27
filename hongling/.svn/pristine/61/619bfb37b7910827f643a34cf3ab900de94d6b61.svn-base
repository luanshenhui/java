package centling.service.discount;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import centling.business.BlDiscountManager;
import centling.dto.DiscountDto;
import centling.entity.Discount;
import chinsoft.business.CDict;
import chinsoft.core.EntityHelper;
import chinsoft.core.LogPrinter;
import chinsoft.core.Utility;
import chinsoft.service.core.BaseServlet;

public class SaveDiscount extends BaseServlet {
	private static final long serialVersionUID = -306857932644496942L;

	@Override
	public void service(HttpServletRequest request, HttpServletResponse response) {
		try {
			super.service();
			boolean flag = true;
			String msg = "";
			String strFormData = getParameter("formData");
			String discountid = EntityHelper.getValueByParamID(strFormData);
			// 2c9086493c237e15013c238073c70001
			String memberId = (String) EntityHelper.getValueByKey(strFormData,
					"memberId");
			Object fm = EntityHelper.getValueByKey(strFormData, "fromNum");
			Object tm = EntityHelper.getValueByKey(strFormData, "toNum");
			Object dd = EntityHelper
					.getValueByKey(strFormData, "disClothingId");
			Integer disClothingId = Integer.valueOf(dd.toString().trim());
			Integer fromNo = Integer.valueOf(fm.toString().trim());
			Integer toNo = Integer.valueOf(tm.toString().trim());
			if (fromNo >= toNo) {
				flag = false;
				msg = "起始数量不能大于等于终止数量";
			} else {
				List<DiscountDto> data = new BlDiscountManager().getDiscounts(
						0, CDict.PAGE_SIZE*100, memberId, null);

				for (int i = 0; i < data.size(); i++) {
					DiscountDto dto = data.get(i);
					if (dto.getDisClothingId().intValue() == disClothingId
							.intValue()) {
						if (!dto.getID().equals(discountid)) {
							// 用户设定的初始值小于或等于已经存在的开始值(西服)
							if (fromNo.intValue()>=dto.getFromNum() && fromNo.intValue()<= dto.getToNum().intValue()||(toNo.intValue()>=dto.getFromNum() && toNo.intValue()<= dto.getToNum().intValue())||(toNo.intValue()>=dto.getToNum() && fromNo.intValue()<= dto.getFromNum().intValue())) {
								flag = false;
								msg = "数量错误，已经存在此范围内的折扣";
							}
						}
					}
				}
			}
			if (flag) {
				Discount discount = null;
				if (!"".equals(discountid)) {
					discount = new BlDiscountManager()
							.getDiscountByID(discountid);
				}

				if (discount == null) {
					discount = new Discount();
				}
				discount = (Discount) EntityHelper.updateEntityFromFormData(
						discount, strFormData);
				new BlDiscountManager().saveDiscount(discount);
				output(Utility.RESULT_VALUE_OK);
			} else {
				output(msg);
			}

		} catch (Exception err) {
			LogPrinter.debug(err.getMessage());
		}
	}
}
