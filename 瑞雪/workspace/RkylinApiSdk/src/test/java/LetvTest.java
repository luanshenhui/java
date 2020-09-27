import org.junit.Test;

import com.letv.LevpClient;
import com.letv.account.AccountResponse;
import com.letv.common.LoggerUtil;
import com.letv.token.TokenResponse;

public class LetvTest {
	
	// 电商加密私钥
	private static String Api_Secret = "c73ffe07dc3347c49f83e305982da1c1";
	// 请求URL
	private static String ReqURL = "http://api.membership.levp.go.le.com/";
	// Channel
	private static String Channel = "458c9400e152bcd2";
	
    @Test
    public void test1() throws Exception
    {
        System.out.println("hello world");
        
		LoggerUtil.LogPath = Test.class.getResource("/").getPath();

		LevpClient cli = new LevpClient(ReqURL, Channel, Api_Secret);

		// 获取token
		TokenResponse rep = cli.GetToken();
		System.out.println(rep.header.getResult());

		String token = rep.body.getToken();
		System.out.println(token);

		if (token != "") {

			//查询渠道乐视用户
			AccountResponse repA = cli.GetAccount(token, "13591150781");
			System.out.println(repA.header.getResult());
			String open_id = repA.body.getOpen_id();

			/*if (open_id != "") {

				//创建乐视影视会员开通订单（充值）
				com.letv.order.OrderResponse reqq = cli.GenOrder(token, open_id,
						"123451243", "100", "12", "pro");

				System.out.println(reqq.header.getResult());
				System.out.println(reqq.header.getMsg());
				System.out.println(reqq.body.getCreate_time_YYYYMMDDHHmmss());
			}*/
		}
    }
}
