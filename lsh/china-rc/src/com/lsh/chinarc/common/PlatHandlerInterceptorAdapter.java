package com.lsh.chinarc.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class PlatHandlerInterceptorAdapter extends HandlerInterceptorAdapter {
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {

		// ����Permission Annotation��ʵ�ַ�����Ȩ�޿���
		// HandlerMethod ��Ҫ��ӦJar����λ�ã������һֱΪfalse
		if (handler.getClass().isAssignableFrom(HandlerMethod.class)) {
			HandlerMethod handlerMethod = (HandlerMethod) handler;
			/*
			 * 1��ȷ�ϵ�ǰ��controller�Ƿ���Ҫ����Ȩ���ж��������Ҫ�������֤��
			 * 2����controller����Ҫ��֤������֤��ǰ�ķ����Ƿ���ҪȨ����֤����Ҫ�������֤������Ҫ������
			 */
			// ��ȡcontrollerע�⣬ controller����Ƿ���Ҫ��֤Ȩ�޿���
			PlatPermission permission = handlerMethod.getMethod()
					.getDeclaringClass().getAnnotation(PlatPermission.class);
			if (permission != null && !permission.validate()) // ����Ҫ��֤Ȩ��
			{
				return super.preHandle(request, response, handler);
			}
			// ��ȡ����ע�⣬��������Ƿ���Ҫ��֤Ȩ�޿���
			permission = handlerMethod.getMethod().getAnnotation(
					PlatPermission.class);
			if (permission != null && !permission.validate()) // ����Ҫ��֤Ȩ��
			{
				return super.preHandle(request, response, handler);
			}
			// Ȩ���ж�,û��Ȩ������ת����Ȩ��ҳ�棬��Ȩ��������������
		}

		return super.preHandle(request, response, handler);
	}

}
