<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="com.engine.workflow.biz.requestForm.LayoutInfoBiz"%>
<%@ page import="com.engine.workflow.biz.requestForm.PrintInfoBiz" %>
<%@ page import="com.engine.workflow.util.CommonUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%
	User user = CommonUtil.getUserByRequest(request, response);
	int ismode = Util.getIntValue(Util.null2String(request.getParameter("ismode")), 0);
	int modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")), 0);
	boolean isPreView = "true".equals(Util.null2String(request.getParameter("isPreView")));
	boolean supportSPA = false;
	if(ismode == 0){
		supportSPA = true;
	}else if(ismode == 1){	//模板模式
		String agent = Util.null2String(request.getHeader("user-agent"));
		if (agent.indexOf("Trident") == -1){		//非IE内核浏览器不支持模板模式打印
%>
				<script type="text/javascript">
					window.alert("<%=SystemEnv.getHtmlLabelName(387190,user.getLanguage())%>");
					if("<%=isPreView %>" != "true"){
						try{
							window.top.close();
						}catch(e){
							window.close();
						}
					}
				</script>
<%
			return;
		}
	}else if(ismode == 2){	//Html模式
		supportSPA = true;
	}
	if(supportSPA && !isPreView){
		String requestid = Util.null2String(request.getParameter("requestid"));
		String clientIP = request.getRemoteAddr();
		new PrintInfoBiz().insertPrintLog(requestid, clientIP, user);
	}
	
	String url = supportSPA ? "/spa/workflow/static4form/index.html?_rdm="+System.currentTimeMillis()+"#/main/workflow/req?" : "/workflow/request/PrintRequest.jsp?";
	Enumeration em = request.getParameterNames();
	while(em.hasMoreElements()){
		String paramName = (String) em.nextElement();
		String paramValue = request.getParameter(paramName);
		url += paramName + "=" + paramValue + "&";
	}
	if(url.endsWith("&"))
		url = url.substring(0, url.length()-1);
	if(url.indexOf("isprint") == -1)
		url += "&isprint=1";
	response.sendRedirect(url);
	return;
%>