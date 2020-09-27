package cn.com.cgbchina.batch.util;

import org.jxls.command.CellRefGenerator;
import org.jxls.common.CellRef;
import org.jxls.common.Context;

/**
 * cellref生成器
 * 
 * @author Leonid Vysochyn
 */
public class SimpleCellRefGenerator implements CellRefGenerator {
	public CellRef generateCellRef(int index, Context context) {
		return new CellRef("Sheet" + (index + 1) + "!A1");
	}
}
