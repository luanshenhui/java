package day01;

public class FinallyDemo {
	public static void main(String[] args) {
		try{
		// 建立数据库的连接
		
		
		// 将数据保存到数据库   这里出现错误
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			// 关闭数据库连接
		}
		
	}
}
