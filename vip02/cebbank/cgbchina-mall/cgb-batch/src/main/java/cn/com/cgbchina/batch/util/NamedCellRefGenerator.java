package cn.com.cgbchina.batch.util;

import org.jxls.command.CellRefGenerator;
import org.jxls.common.CellRef;
import org.jxls.common.Context;

/**
 * @author xiewl 指定命名的CellRef生成器
 */
public class NamedCellRefGenerator implements CellRefGenerator {

	private String sheetName = "Sheet";

	public NamedCellRefGenerator() {
	}

	public NamedCellRefGenerator(String sheetName) {
		this.sheetName = sheetName;
	}

	@Override
	public CellRef generateCellRef(int index, Context context) {
		return new CellRef(sheetName + (index + 1) + "!A1");
	}

}
