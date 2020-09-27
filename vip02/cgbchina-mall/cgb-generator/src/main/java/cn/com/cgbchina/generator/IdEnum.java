package cn.com.cgbchina.generator;

import com.google.common.base.Objects;

/**
 * Created by 11140721050130 on 2016/5/1.
 */
public enum IdEnum {
	ORDER(0, "order"), ORDER_MAIN(1, "order_main"), GOODS(2, "goods"), ITEM(3, "item"), ORDER_SERIAL_NO(4,
			"order_serial_no"), JF_REFUND_SERIAL_NO(5, "jf_refund_serial_no"), PAY_WAY(6,
					"pay_way"), ITEM_MID(7, "item_mid"), INTF_SOAP(8, "interface_soap"),ITEM_MID_TRY(9,"item_mid_try");

	private int value;
	private String type;

	private IdEnum(int value, String type) {
		this.value = value;
		this.type = type;
	}

	public int value() {
		return this.value;
	}

	public static IdEnum fromNumber(Integer number) {
		for (IdEnum status : values()) {
			if (Objects.equal(number, Integer.valueOf(status.value()))) {
				return status;
			}
		}
		return null;
	}

	@Override
	public String toString() {
		return this.type;
	}

}
