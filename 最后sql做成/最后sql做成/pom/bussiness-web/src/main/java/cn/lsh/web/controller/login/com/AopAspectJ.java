package cn.lsh.web.controller.login.com;

import java.util.List;

import javax.annotation.Resource;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.beans.factory.annotation.Autowired;

import cn.lsh.web.mapper.login.dao.LoginDao;
import cn.lsh.web.mapper.login.domain.AreaDomain;
import cn.lsh.web.service.service.LoginService;

@Aspect
public class AopAspectJ {
	@Autowired
	private LoginDao loginDao;

    /**  
     * 必须为final String类型的,注解里要使用的变量只能是静态常量类型的  
     */  
    public static final String EDP="execution(* cn.lsh.web.service.service.impl.LoginServiceImpl..*(..))";
    
    /**
     * 切面的前置方法 即方法执行前拦截到的方法
      * 在目标方法执行之前的通知
      * @param jp
     */
    @Before(EDP)
    public void doBefore(JoinPoint jp){
        
        System.out.println("=========执行前置通知==========@Before");
    }
    
    
    /**
     * 在方法正常执行通过之后执行的通知叫做返回通知
      * 可以返回到方法的返回值 在注解后加入returning 
     * @param jp
     * @param result
     */
    //result 是 string 类型 会限制
    @AfterReturning(value=EDP,argNames = "result",returning="result",pointcut=EDP )
    public void doAfterReturning(JoinPoint jp,Object result){
//    	result="hhdf";
        System.out.println("===========执行后置通知============AfterReturning"+result);
    }
    
    /**
     * 最终通知：目标方法调用之后执行的通知（无论目标方法是否出现异常均执行）
      * @param jp
     */
    @After(value=EDP)
    public void doAfter(JoinPoint jp){
    	List<AreaDomain> vo=loginDao.getProvinceList(new AreaDomain());
        System.out.println("===========执行最终通知============@After"+vo);
    }
    
    /**
     * 环绕通知：目标方法调用前后执行的通知，可以在方法调用前后完成自定义的行为。
      * @param pjp
     * @return
     * @throws Throwable
     */
    @SuppressWarnings("unused")
	@Around(EDP)
    public Object doAround(ProceedingJoinPoint pjp) throws Throwable{

        System.out.println("======执行环绕通知开始=========@Around");
        // 调用方法的参数
        Object[] args = pjp.getArgs();
        // 调用的方法名
        String method = pjp.getSignature().getName();
        // 获取目标对象
        Object target = pjp.getTarget();
        // 执行完方法的返回值
        // 调用proceed()方法，就会触发切入点方法执行
        Object result=pjp.proceed();
        System.out.println("输出,方法名：" + method + ";目标对象：" + target + ";返回值：" + result);
        System.out.println("======执行环绕通知结束=========");
        return result;
    }
    
    /**
     * 在目标方法非正常执行完成, 抛出异常的时候会走此方法
      * @param jp
     * @param ex
     */
    @AfterThrowing(value=EDP,throwing="ex")
    public void doAfterThrowing(JoinPoint jp,Exception ex) {
        System.out.println("===========执行异常通知============@AfterThrowing");
    }
}