import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;


public class TimeDemo {

	/**
	 * long String 日历 互转
	 * @param args
	 * @throws ParseException 
	 */
	public static void main(String[] args) throws ParseException {
		// TODO Auto-generated method stub
		long a = System.currentTimeMillis();
		System.out.println("long:" + a);
		Date b = new Date();
		b.setTime(a);
		System.out.println("date:" + b);
		SimpleDateFormat format = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
		String c = format.format(b);
		System.out.println("String:" + c);
		b = format.parse(c);
		System.out.println("date:" + b);
		Calendar d = Calendar.getInstance();
		d.setTime(b);
		System.out.println(d);
		b = d.getTime();
		System.out.println(b);
		a = b.getTime();
		System.out.println(a);
	}

}
