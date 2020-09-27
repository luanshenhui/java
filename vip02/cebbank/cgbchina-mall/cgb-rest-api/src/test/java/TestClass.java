import java.math.BigDecimal;
import java.text.DecimalFormat;

/**
 * Comment: Created by 11150321050126 on 2016/5/4.
 */
public class TestClass {
	public static void main(String[] args) {
		DecimalFormat df = new DecimalFormat("#.00");
		System.out.println(df.format(new BigDecimal(123.332)));
	}

	static {
		System.out.println("sssssss");
	}
}
