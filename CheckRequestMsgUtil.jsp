
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.google.common.base.Strings" %>

<%@ page import="weaver.workflow.request.RequestOperationMsgManager" %>
<%@ page import="weaver.workflow.msg.entity.MsgEntity" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.cloudstore.dev.api.bean.MessageBean" %>

<%@ page import="com.cloudstore.dev.api.bean.MessageType" %>
<%@ page import="com.engine.msgcenter.biz.*" %>
<%@ page import="com.engine.msgcenter.constant.MsgConfigConstant" %>
<%@ page import="weaver.workflow.msg.entity.MsgNoticeType" %>


<!DOCTYPE>
<html>
  <head>
	<%@ include file="/systeminfo/init_wev8.jsp" %>

	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script  src='/js/ecology8/request/freeWorkflowShow_wev8.js'></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	
	<link rel="stylesheet" href="/js/jquery/ui/jquery-ui_wev8.css">
	<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/ui.draggable_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/ui.resizable_wev8.js"></script>
	<script language="javascript" src="/js/jquery/ui/ui.droppable_wev8.js"></script>

	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
	
	<link href="/css/ecology8/request/freeWorkflowShow_wev8.css" type=text/css rel=STYLESHEET>

	<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
	<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>

  </head>
  
  <body >
  	<div style="border:1px double #e7e7e7; width: 800px;height: 900px;overflow-y: auto;margin:20px auto;padding:10px 10px; ">
	  <%
		  int reqId = Util.getIntValue(Util.null2String(request.getParameter("reqId")),-1);
		  int userid = Util.getIntValue(Util.null2String(request.getParameter("userid")),-1);
		  if(reqId == -1){
	  %>
		<form id='queryForm' name="queryForm" method="post" action="CheckRequestMsgUtil.jsp">
				  <div id="querytable" style="width: 50%;margin: auto;background-color: cornsilk;">
					  <span>输入已有流程ID及检测人员ID，即可模拟推送新到达流程，用户配置校验结果</span>
					  <table style="width: 100%">
						  <tr><td>已有流程ID：</td><td><input type=text id="reqId" name="reqId" placeholder="例：108"/></td></tr>
						  <tr><td>检测人员ID：</td><td><input type=text id="userid" name="userid" placeholder="例：2"/></td></tr>
					  </table>
				  </div>
			      <div id="submit" style="width: 50%;margin: auto;background-color: cornsilk;">
					  <input type="submit" value="确定">
				  </div>
			  </form>
	  <%
		  }else{
		  	%>
			<p>check user config==============================start </p>
			<%
			  new BaseBean().writeLog("check user config==============================start");
		  		//1、模拟一个消息对象
			  MsgEntity msgEntity = new MsgEntity();
			  //查询流程基本信息
			  RecordSet rs = new RecordSet();
			  rs.executeQuery("select requestname,requestnamenew,workflowid,creater,createdate,createtime from workflow_requestbase where requestid = ?", reqId);
			  if (rs.next()) {
				  String detailName = Util.null2String(rs.getString("requestname"));
				  String detailTitle = Util.null2String(rs.getString("requestnamenew"));
				  String workflowId = Util.null2String(rs.getString("workflowid"));
				  String creator = Util.null2String(rs.getString("creater"));
				  String createDate = Util.null2String(rs.getString("createdate"));
				  String createTime = Util.null2String(rs.getString("createtime"));

				  msgEntity.setDetailId(String.valueOf(reqId));
				  msgEntity.setDetailName(detailName);
				  msgEntity.setDetailTitle(detailTitle);
				  msgEntity.setDetailBaseId(workflowId);
				  msgEntity.setCreator(creator);
				  msgEntity.setCreateDate(createDate);
				  msgEntity.setCreateTime(createTime);

				  rs.executeQuery("select wfb.workflowname,wfb.isvalid,wft.id,wft.typename from workflow_base wfb,workflow_type wft where wfb.id = ? and wfb.workflowtype = wft.id", workflowId);
				  if (rs.next()) {
					  msgEntity.setDetailBaseName(Util.null2String(rs.getString("workflowname")));
					  msgEntity.setDetailTypeId(Util.null2String(rs.getString("id")));
					  msgEntity.setDetailTypeName(Util.null2String(rs.getString("typename")));
				  }

				  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				  msgEntity.setOperaterDate(sdf.format(new Date()));
			  }
			  msgEntity.addUserId(String.valueOf(userid));  //
			  msgEntity.setMsgType(MessageType.WF_NEW_ARRIVAL);
			  msgEntity.setNoticeType(MsgNoticeType.NEW_ARRIVAL);

			  try{
				  List<MessageBean> messageBeans = new ArrayList<>();
				  messageBeans.add(msgEntity.parse2MessageBean());
				  if(messageBeans == null || messageBeans.isEmpty()) return;
				  ConfigManager configManager = new ConfigManager();
				  for(MessageBean messageBean : messageBeans){
					  String detailTitle = messageBean.getDetailTitle();
					  if(Strings.isNullOrEmpty(detailTitle)) continue;

					  Map<String, Object> params = messageBean.getParams();
					  if(params == null)continue;
					  String workflowId = Util.null2String(params.get("detailBaseId"));

					  MessageType messageType = messageBean.getMessageType();

					  //消息类型和对应人员映射关系
					  Map<WeaMessageTypeConfig,List<String>> typeConfigListMap = new HashMap<>();

					  List<WeaMessageConfig> weaMessageConfigs = configManager.loadUserConfig(messageType,messageBean.getUserList());
					  for(WeaMessageConfig weaMessageConfig: weaMessageConfigs){

						  String userId = Util.null2String(weaMessageConfig.getUserid());

						  List<WeaMessageTypeConfig> msgTypeConfigList = weaMessageConfig.getMsgTypeConfigList();
						  for(WeaMessageTypeConfig typeConfig : msgTypeConfigList){

							  //禁用
							  if(!typeConfig.isEnable()) continue;

							  //1、检查消息类型设置是否通过
							  boolean messageTypeTrue = false;
							  if(typeConfig.isHasDetail()){
								  List <WeaMessageConfigDetail> weaMessageConfigDetails = typeConfig.getDetailList();
								  for(WeaMessageConfigDetail weaMessageConfigDetail : weaMessageConfigDetails){
									  boolean defaultRuleCheck = weaMessageConfigDetail.defaultRuleCheck(workflowId);
									  if(defaultRuleCheck){
										  messageTypeTrue = true;
									  }
								  }
							  }

							  if(!messageTypeTrue) continue;
							%>
								<p>1、jh log: check user config==============================start </p>
							<%
							  new BaseBean().writeLog("1、jh log: check user config==============================start");
							  //2、检查用户规则
							  WeaMessageUserConfig userConfig = null;
							  List<WeaMessageUserConfig> userConfigList = weaMessageConfig.getUserConfigList();
							  for(WeaMessageUserConfig temp : userConfigList){
								  if(temp.getMsgTypeConfigId().equals(typeConfig.getId())){
									  userConfig = temp;
									  break;
								  }
							  }
							%>
								<p>2、jh log: userConfig=<%=userConfig.toString()%></p>
							<%
							  new BaseBean().writeLog("2、jh log: userConfig="+userConfig.toString());
							  boolean isSendMSg = false;
							%>
								<p>3、jh log: userConfig=<%=userConfig.isEnable()%></p>
							<%
							  new BaseBean().writeLog("3、jh log: userConfig="+userConfig.isEnable());
							  if(userConfig.isEnable()) {
								  //详细设置
								  boolean hasDetail = userConfig.isHasDetail();
							%>
								<p>4、jh log: hasDetail=<%=hasDetail%></p>
							<%
								  new BaseBean().writeLog("4、jh log: hasDetail="+hasDetail);
								  if (hasDetail) {

									  boolean isClude = false;
									  List<MessageType> includeMessageType = null;
									  switch (messageType.getCode()) {

										  case 21:
										  case 22:
										  case 23:
										  case 24:
										  case 19:
											  includeMessageType = userConfig.getInclude();
											  isClude = true;
											  break;
									  }
										%>
											<p>5、jh log: isClude=<%=isClude%></p>
										<%
									  new BaseBean().writeLog("5、jh log: isClude="+isClude);
									  if(includeMessageType!=null){
										  for(MessageType m : includeMessageType){
												%>
													<p>5.1、jh log: m.code=<%=m.getCode()%></p>
												<%
											  new BaseBean().writeLog("5.1、jh log: "+m.getCode());
										  }
									  }
										%>
											<p>5.2、jh log: messageType=<%=messageType.getCode()%></p>
										<%
									  new BaseBean().writeLog("5.2、jh log: messageType="+messageType.getCode());

									  List<WeaMessageConfigDetail> configDetails = userConfig.getDetailList();
										%>
											<p>6、jh log: configDetails=<%=configDetails.size()%></p>
										<%
									  new BaseBean().writeLog("6、jh log: configDetails="+configDetails.size());
									  for (WeaMessageConfigDetail configDetail : configDetails) {

										  String type = Util.null2String(configDetail.getType());
										  String path = Util.null2String(configDetail.getPath());
										%>
											<p>6.1、jh log: type=<%=type%></p>
											<p>6.2、jh log: path=<%=path%></p>
										<%
										  new BaseBean().writeLog("6.1、jh log: type="+type);
										  new BaseBean().writeLog("6.2、jh log: path="+path);

										  if (MsgConfigConstant.MSG_DEFAULT_CONFIG_PATH_DESIG.equals(type)) {  //指定
											  String[] pathArr = path.split(",");
											  List<String> paths = Arrays.asList(pathArr);

											  if (isClude) {
												  if (includeMessageType != null && includeMessageType.contains(messageType) && paths.contains(workflowId)) {
													  isSendMSg = true;
												  }
											  } else if (paths.contains(workflowId)) {
												  isSendMSg = true;
											  }
										  } else if (MsgConfigConstant.MSG_DEFAULT_CONFIG_PATH_EXCLUDE.equals(type)) {  //不包含
											  String[] pathArr = path.split(",");
											  List<String> paths = Arrays.asList(pathArr);

											  if (!paths.contains(workflowId)) {
												  if (isClude) {
													  if (includeMessageType != null && includeMessageType.contains(messageType)) {
														  isSendMSg = true;
													  }
												  } else {
													  isSendMSg = true;
												  }
											  }
										  } else if (MsgConfigConstant.MSG_DEFAULT_CONFIG_PATH_ALL.equals(type)) {  //全部
											  if (isClude) {
												  if (includeMessageType != null && includeMessageType.contains(messageType)) {
													  isSendMSg = true;
												  }
											  } else {
												  isSendMSg = true;
											  }
										  }
									  }
								  } else {
									  isSendMSg = true;
								  }
									%>
										<p>7、jh log: 校验是否通过=<%=isSendMSg%></p>
									<%
								  new BaseBean().writeLog("7、jh log: isSendMSg="+isSendMSg);
								  //new BaseBean().writeLog("7、jh log: users="+String.join(",",typeConfigListMap.get(typeConfig)));
								  if(isSendMSg){
									  List<String> users = typeConfigListMap.get(typeConfig);
									  if(users == null){
										  users = new ArrayList<>();
										  users.add(userId);
										  typeConfigListMap.put(typeConfig,users);
									  }else{
										  users.add(userId);
									  }
								  }
							  }
						  }
					  }
				  }
		  }catch(Exception e){
		  	new BaseBean().writeLog("消息推送异常：",e);
		  }

		  }


	  %>



	</div>
  </body>
</html>
