//package cn.lsh.web.controller.login.com;
//
//import org.aspectj.lang.JoinPoint;
//import org.aspectj.lang.ProceedingJoinPoint;
//import org.aspectj.lang.annotation.After;
//import org.aspectj.lang.annotation.AfterReturning;
//import org.aspectj.lang.annotation.AfterThrowing;
//import org.aspectj.lang.annotation.Around;
//import org.aspectj.lang.annotation.Aspect;
//import org.aspectj.lang.annotation.Before;
//import org.springframework.stereotype.Component;
//
//@Component
//@Aspect 
//public class AspectConfig {
//    @SuppressWarnings("unused")
//	@Around("execution(* cn.lsh.web.service.service.impl*(String, String))")
//    public Object  loginBefore(ProceedingJoinPoint joinPoint){
//        Object[] args = joinPoint.getArgs();
//        Object result = null;
//        try {
//            result = joinPoint.proceed();
//        } catch (Throwable e) {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        }
//        System.out.println("begin login:"+joinPoint.getTarget());
//        return result;
//    }
//    @AfterReturning(pointcut="execution(* cn.lsh.web.service.service.impl*",returning="rvt")
//    public Object loginAfter(JoinPoint  joinPoint,Object rvt){
//        System.out.println("login after:"+rvt);
//        return rvt;
//    }
//    
//    @Before(value = "cn.lsh.web.service.service.impl.getProvinceList()")
//    public void before(JoinPoint joinPoint) {
//        System.out.println("[Aspect1] before advise");
//    }
//
//    @Around(value = "cn.lsh.web.service.service.impl.getProvinceList()")
//    public void around(ProceedingJoinPoint pjp) throws  Throwable{
//        System.out.println("[Aspect1] around advise 1");
//        pjp.proceed();
//        System.out.println("[Aspect1] around advise2");
//    }
//
//    @AfterReturning(value = "cn.lsh.web.service.service.impl.getProvinceList()")
//    public void afterReturning(JoinPoint joinPoint) {
//        System.out.println("[Aspect1] afterReturning advise");
//    }
//
//    @AfterThrowing(value = "cn.lsh.web.service.service.impl.getProvinceList()")
//    public void afterThrowing(JoinPoint joinPoint) {
//        System.out.println("[Aspect1] afterThrowing advise");
//    }
//
//    @After(value = "cn.lsh.web.service.service.impl.getProvinceList()")
//    public void after(JoinPoint joinPoint) {
//        System.out.println("[Aspect1] after advise");
//    }
//
//
//}
//
