package cn.rkylin.apollo.common.util;

import java.util.Iterator;
import java.util.List;

/**
 * 工具类判断List集合是否空
 * @author zxy
 *
 */
public class ListUtils {
	public static boolean isEmpty(List list) {
		boolean isEmpty = false;
		if ((list == null) || (list.isEmpty())) {
			isEmpty = true;
		}
		return isEmpty;
	}

	public static boolean isBlank(List list) {
		boolean isEmpty = true;
		Iterator it;
		if (!isEmpty(list))
			isEmpty = false;
		else {
			for (it = list.iterator(); it.hasNext();) {
				Object temp = it.next();
				if (temp != null) {
					isEmpty = false;
					break;
				}
			}
		}
		return isEmpty;
	}
}
