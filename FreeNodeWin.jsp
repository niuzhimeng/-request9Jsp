<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
	int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),-1);
	int nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),-1);
	int requestid = Util.getIntValue(Util.null2String(request.getParameter("requestid")),-1);
	String isdialog = Util.null2String(request.getParameter("isdialog"));
	if("".equals(isdialog)){
		isdialog = "0";
	}
	int isset = Util.getIntValue(Util.null2String(request.getParameter("isset")),0);
	
	String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
	String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
	user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
%>

<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<%--html5 canvas绘图的js --%>
		<script type="text/javascript" src="/workflow/design/js/beans_wev8.js"></script>
		<script type="text/javascript" src="/workflow/design/js/design_wev8.js"></script>
		<script type="text/javascript" src="/workflow/design/js/xmlParse_wev8.js"></script>
		<script type="text/javascript" src="/workflow/design/js/canvasUtil_wev8.js"></script>
		<%--人力资源卡片的js --%>
		<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
		<script type="text/javascript" src="/js/messagejs/messagejs_wev8.js"></script>
		<script type="text/javascript" src="/qrcode/js/jquery.qrcode-0.7.0_wev8.js"></script>
		
		<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
		<!-- 样式表 -->
		<link rel="stylesheet" href="/social/css/base_public_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/social/css/base_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/social/css/im_wev8.css" type="text/css" />
		
		<style type="text/css">
			iframe{
				border: none !important;
			}
		</style>
	</head>
	<body>
		<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
		
		<%@ include file="/workflow/request/FreeNodeShowSimple.jsp" %>
		
		<%if("1".equals(isdialog)){%>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<table width="100%">
				<tr><td style="text-align:center;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31103,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="saveWorkflowPicture(this)">
					<input type="button" value="<%=SystemEnv.getHtmlLabelNames("615,18015",user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitWorkflow(this);">
				</td></tr>
			</table>
		</div>	
		<%}%>
	
<script type="text/javascript">

//关闭窗口
function clostWin()
{
	//关闭对话框
	window.top.freedialog.close();
}
</script>	
	
	</body>	
</html>