<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@page import="org.json.JSONObject"%> 
<%@page import="org.json.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.general.BaseBean" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />
<%

/*用户验证*/
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
if(user==null) {
    return;
}
	Enumeration em = request.getParameterNames();
	boolean isinit = true;
	while(em.hasMoreElements())
	{
		String paramName = (String)em.nextElement();
		if(!paramName.equals(""))
			isinit = false;
		break;
	}
	String loadtree = Util.null2String(request.getParameter("loadtree"));
	int date2during = Util.getIntValue(request.getParameter("date2during"),0);
    String resourceid= Util.null2String(request.getParameter("resourceid"));
    String logintype = ""+user.getLogintype();
    int usertype = 0;
    String offical = Util.null2String(request.getParameter("offical"));
    int officalType = Util.getIntValue(request.getParameter("officalType"),-1);

    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
    String menuType = Util.null2String(request.getParameter("menuType"));
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);
    if(selectedContent!=null && selectedContent.startsWith("key_")){
		String menuid = selectedContent.substring(4);
		RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
		selectedContent = "";
		while(RecordSet.next()){
			String keyVal = RecordSet.getString(2);
			selectedContent += keyVal +"|";
		}
		if(selectedContent.indexOf("|")!=-1)
			selectedContent = selectedContent.substring(0,selectedContent.length()-1);
	}
    if(fromAdvancedMenu == 1){
		response.sendRedirect("/workflow/search/WFSearchCustom.jsp?offical="+offical+"&officalType="+officalType+"&fromadvancedmenu=1&infoId="+infoId+"&selectedContent="+selectedContent+"&menuType="+menuType);
		return;
	}
    String selectedworkflow = "";
    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
    if(info!=null){
    	selectedworkflow = info.getSelectedContent();
    }
    if(!"".equals(selectedContent))
    {
    	selectedworkflow = selectedContent;
    }
    selectedworkflow+="|";
    /* edited end */    
    
String userID = String.valueOf(user.getUID());
String userIDAll = String.valueOf(user.getUID());
int userid=user.getUID();
String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
		if(RecordSet.next()){
			belongtoshow = RecordSet.getString("belongtoshow");
		}
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}




    if(resourceid.equals("")) {
        resourceid = ""+user.getUID();
        if(logintype.equals("2")) usertype= 1;
        session.removeAttribute("RequestViewResource") ;
    }
    else {
        session.setAttribute("RequestViewResource",resourceid) ;
    }

    char flag = Util.getSeparator();

    String username = Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage());

    if(logintype.equals("2")) username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+user.getUID()),user.getLanguage()) ;

    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename =  SystemEnv.getHtmlLabelName(17991,user.getLanguage()) + ": "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    
	int olddate2during = 0;
    BaseBean baseBean = new BaseBean();
	String date2durings = "";
	try
	{
		date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
	}
	catch(Exception e)
	{}
	String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
	if(date2duringTokens.length>0)
	{
		olddate2during = Util.getIntValue(date2duringTokens[0],0);
	}
	if(olddate2during<0||olddate2during>36)
	{
		olddate2during = 0;
	}
	if(isinit)
	{
		date2during = olddate2during;
	}
%>

<%
	String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
    String newremarkwfcount0="";
    String newremarkwfcount="";
	String workflowname="";

    ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();//反馈
    ArrayList newremarkwfcount0s=new ArrayList();//未读
    ArrayList newremarkwfcounts=new ArrayList();
    int totalcount=0;
    String _wftypes = "";
    String demoLeftMenus = "";

	StringBuffer sqlsb = new StringBuffer();
	sqlsb.append("select workflowtype, ");
	sqlsb.append("   workflowid, ");
	sqlsb.append("   viewtype, ");
	if("1".equals(belongtoshow)){
		sqlsb.append("   count(requestid) workflowcount ");
		}else{
		sqlsb.append("   count(distinct requestid) workflowcount ");
		}
	sqlsb.append("  from workflow_currentoperator ");
	sqlsb.append(" where (isremark in('2','4') or (isremark=0 and takisremark =-2)) ");
	sqlsb.append("   and islasttimes = 1 ");
		if("1".equals(belongtoshow)){
		sqlsb.append(" and userid in ( ").append(userIDAll);	
			}else{
		sqlsb.append(" and userid in (").append(user.getUID());
			}
	sqlsb.append("  ) and usertype = ").append(usertype).append(WorkflowComInfo.getDateDuringSql(date2during));
	sqlsb.append("	 and exists ");
	sqlsb.append("	  (select 1 ");
	sqlsb.append("	           from workflow_requestbase c ");
	sqlsb.append("	          where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.workflowid = workflow_currentoperator.workflowid ");
	sqlsb.append("	            and c.requestid = workflow_currentoperator.requestid ");
		if("1".equals(belongtoshow)){
	if(RecordSet.getDBType().equals("oracle"))
	{
		sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater in ("+userIDAll+"))) ");
	}else if(RecordSet.getDBType().equals("mysql")){
		sqlsb.append(" and (ifnull(c.currentstatus,-1) = -1 or (ifnull(c.currentstatus,-1)=0 and c.creater in ("+userIDAll+"))) ");
	}
	else
	{
		sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater in ("+userIDAll+"))) ");
	}
		}else{
			if(RecordSet.getDBType().equals("oracle"))
	{
		sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
	}else if(RecordSet.getDBType().equals("mysql")){
		sqlsb.append(" and (ifnull(c.currentstatus,-1) = -1 or (ifnull(c.currentstatus,-1)=0 and c.creater in ("+userIDAll+"))) ");
	}
	else
	{
		sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
	}
		}
	sqlsb.append(")");
	if(offical.equals("1")){
		if(officalType==1){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
		}else if(officalType==2){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
		}
	}
	sqlsb.append(" group by workflowtype, workflowid, viewtype ");
	sqlsb.append(" order by workflowtype, workflowid");
	//RecordSet.executeSql("select workflowtype, workflowid, viewtype, count(distinct requestid) workflowcount from workflow_currentoperator where isremark='2' and iscomplete=0 and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +" group by workflowtype, workflowid, viewtype order by workflowtype, workflowid " ) ;
	RecordSet.executeSql(sqlsb.toString()) ;
	//System.out.println(sqlsb.toString());
	while(RecordSet.next()){       
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
		int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
		int viewtype = Util.getIntValue(RecordSet.getString("viewtype"),-2) ;  
		
		theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
		
        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
            /* added by wdl 2006-06-14 left menu advanced menu */
    	 	if(selectedworkflow.indexOf("T"+theworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
    	 	if(selectedworkflow.indexOf("W"+theworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
    	 	/* added end */
        	
            int wfindex = workflows.indexOf(theworkflowid) ;
            if(wfindex != -1) {
                workflowcounts.set(wfindex,""+(Util.getIntValue((String)workflowcounts.get(wfindex),0)+theworkflowcount)) ;
                if(viewtype==-1){
                    newremarkwfcounts.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts.get(wfindex),0)+theworkflowcount)) ;
                }
                	
            }else{
                workflows.add(theworkflowid) ;
                workflowcounts.add(""+theworkflowcount) ;	
                if(viewtype==-1){
                    newremarkwfcounts.add(""+theworkflowcount);
                    newremarkwfcount0s.add(""+0);
                }else{
                    newremarkwfcounts.add(""+0);
                    newremarkwfcount0s.add(""+0);
                }
            }

            int wftindex = wftypes.indexOf(theworkflowtype) ;
            if(wftindex != -1) {
                wftypecounts.set(wftindex,""+(Util.getIntValue((String)wftypecounts.get(wftindex),0)+theworkflowcount)) ;
            }
            else {
                wftypes.add(theworkflowtype) ;
                wftypecounts.add(""+theworkflowcount) ;
            }

            totalcount += theworkflowcount;
        }
	}
	sqlsb = new StringBuffer();
	sqlsb.append("select workflowtype, ");
	sqlsb.append("      workflowid, ");
	sqlsb.append("      viewtype, ");
	sqlsb.append("      count(distinct requestid) workflowcount ");
	sqlsb.append("  from workflow_currentoperator ");
	sqlsb.append(" where (isremark in('2','4') or (isremark=0 and takisremark =-2)) ");
	//sqlsb.append("   and iscomplete = 0 ");
	sqlsb.append("   and islasttimes = 1 ");
		if("1".equals(belongtoshow)){
		sqlsb.append(" and userid in ( ").append(userIDAll);	
			}else{
		sqlsb.append(" and userid in (").append(user.getUID());
			}
	sqlsb.append("  ) and usertype = ").append(usertype);
	sqlsb.append("   and viewtype = 0 ");
	sqlsb.append("   and (agentType <> '1' or agentType is null) ").append(WorkflowComInfo.getDateDuringSql(date2during));
	sqlsb.append("	 and exists (select 1 ");
	sqlsb.append("	           from workflow_requestbase c ");
	sqlsb.append("	          where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.workflowid = workflow_currentoperator.workflowid ");
	sqlsb.append("	            and c.requestid = workflow_currentoperator.requestid ");
	if(RecordSet.getDBType().equals("oracle"))
	{
		sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
	}else if(RecordSet.getDBType().equals("mysql")){
		sqlsb.append(" and (ifnull(c.currentstatus,-1) = -1 or (ifnull(c.currentstatus,-1)=0 and c.creater in ("+userIDAll+"))) ");
	}
	else
	{
		sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
	}
	sqlsb.append(")");
	if(offical.equals("1")){
		if(officalType==1){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and isvalid=1)");
		}else if(officalType==2){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and isvalid=1)");
		}
	}
	sqlsb.append(" group by workflowtype, workflowid, viewtype ");
	sqlsb.append(" order by workflowtype, workflowid");
	//System.out.println("sqlsb====>:"+sqlsb.toString());
	
	//已办/办结事宜，红色new标记
	//RecordSet.executeSql("select workflowtype, workflowid, viewtype, count(distinct requestid) workflowcount from workflow_currentoperator where isremark='2' and iscomplete=0 and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +" and viewtype=0 and (agentType<>'1' or agentType is null) group by workflowtype, workflowid, viewtype order by workflowtype, workflowid " ) ;
	RecordSet.executeSql(sqlsb.toString()) ;
	while(RecordSet.next()){       
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
		int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
		int viewtype = Util.getIntValue(RecordSet.getString("viewtype"),-2) ;       
        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
        	
            /* added by wdl 2006-06-14 left menu advanced menu */
    	 	if(selectedworkflow.indexOf("T"+theworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
    	 	if(selectedworkflow.indexOf("W"+theworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
    	 	/* added end */
        	
            int wfindex = workflows.indexOf(theworkflowid) ;
            if(wfindex != -1) {
				newremarkwfcount0s.set(wfindex,""+(Util.getIntValue((String)newremarkwfcount0s.get(wfindex),0)+theworkflowcount)) ;
            }
        }else{
	        theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
	        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
	    	 	if(selectedworkflow.indexOf("T"+theworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
	    	 	if(selectedworkflow.indexOf("W"+theworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
	            int wfindex = workflows.indexOf(theworkflowid) ;
	            if(wfindex != -1) {
	            	if(viewtype==0){
	                	newremarkwfcount0s.set(wfindex,""+(Util.getIntValue((String)newremarkwfcount0s.get(wfindex),0)+theworkflowcount)) ;
	                }
	            }
	        }
        }
	}

	/*******************************/
	demoLeftMenus="[";
		for(int i=0;i<wftypes.size();i++){
			typeid=(String)wftypes.get(i);
			typecount=(String)wftypecounts.get(i);
			typename=WorkTypeComInfo.getWorkTypename(typeid);
			demoLeftMenus+="{";	
			demoLeftMenus+="\"__domid__\":\"__type_"+typeid+"\",";
			List<Map> maps=new ArrayList(0);
			
			int flowNew=0;
			int flowResponse=0;
			int flowAll=0;
			
			for(int j=0;j<workflows.size();j++){
				workflowid=(String)workflows.get(j);
				String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
				if(!curtypeid.equals(typeid)){
					continue;	
				}
				workflowcount=(String)workflowcounts.get(j);
				newremarkwfcount0=(String)newremarkwfcount0s.get(j);
				newremarkwfcount=(String)newremarkwfcounts.get(j);
				workflowname=WorkflowComInfo.getWorkflowname(workflowid);
 				Map map=new HashMap();
 				map.put("name",Util.toScreen(workflowname,user.getLanguage()));
 				map.put("workflowid",workflowid);
 				map.put("flowResponse",Util.toScreen(newremarkwfcount,user.getLanguage()));//
 				map.put("flowNew",newremarkwfcount0);
 				map.put("flowAll",Util.toScreen(workflowcount,user.getLanguage()));//
 	
				flowNew+=Integer.valueOf(newremarkwfcount0);
				flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
				flowAll+=Integer.valueOf(Util.toScreen(workflowcount,user.getLanguage()));
 				
 				maps.add(map);
			}
			
			demoLeftMenus+="\"numbers\":{";
			demoLeftMenus+="\"flowNew\":"+flowNew+",";
			demoLeftMenus+="\"flowResponse\":"+flowResponse+",";
			demoLeftMenus+="\"flowAll\":"+flowAll;
			demoLeftMenus+="}";
			demoLeftMenus+="}";
			
			if (maps.size() > 0) {
				demoLeftMenus += ",";
			}
			
			for(int x=0;x<maps.size();x++){
				Map map=maps.get(x);
				flowNew+=Integer.valueOf(map.get("flowNew")+"");
				flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
				flowAll+=Integer.valueOf(map.get("flowAll")+"");
				demoLeftMenus+="{";
				demoLeftMenus+="\"__domid__\":\"__wf_"+map.get("workflowid")+"\",";
				demoLeftMenus+="\"numbers\":{";
				demoLeftMenus+="\"flowNew\":"+map.get("flowNew")+",";
				demoLeftMenus+="\"flowResponse\":"+map.get("flowResponse")+",";
				demoLeftMenus+="\"flowAll\":"+map.get("flowAll");
				demoLeftMenus+="}";
				demoLeftMenus+="}";
				demoLeftMenus += (x==maps.size()-1)?"":",";
			}
//			demoLeftMenus+="],";
			if (i < wftypes.size() - 1) {
				demoLeftMenus += ",";
			}
		}

        if(requestutil.getOfsSetting().getIsuse() == 1 &&requestutil.getOfsSetting().getShowdone().equals("1")){
			RecordSet rs1 = new RecordSet();
			RecordSet rs = new RecordSet();
			int wftype_count = 0;
			//rs.executeSql("select sysid,sysshortname from ofs_sysinfo order by sysid desc");
			//wftype_count = rs.getCounts();
			//while (rs.next()) {
			//记录当前异构系统流程id， 用于查询类型信息
			StringBuilder sb = new StringBuilder();
			//流程请求数量信息，结构说明：Map<流程id, Map<流程id，全部数量，未读数量>>
			Map<String, Map<String, String>> ofsReqInfos = new HashMap<String, Map<String, String>>();
			int ofsWfAllReqCount = 0;
			int ofsWfNewReqCount = 0;
			//查询指定人员所有的待办流程数量
			rs.executeQuery("select workflowid, viewtype, COUNT(requestid) count from ofs_todo_data where userid=? and isremark in (2,4) and islasttimes=1 group by workflowid, viewtype", user.getUID());
			boolean hasOfsReq = rs.getCounts() > 0;
			while (rs.next()) {
				String ofsWfid = Util.null2String(rs.getString("workflowid"));
				int ofsViewType = Util.getIntValue(rs.getString("viewtype"), 0);
				int ofsReqCount = Util.getIntValue(rs.getString("count"), 0);
				ofsWfAllReqCount += ofsReqCount;

				Map<String, String> ofsReqInfoBean = ofsReqInfos.get(ofsWfid);
				if (ofsReqInfoBean == null) {
					ofsReqInfoBean = new HashMap<String, String>();
					ofsReqInfos.put(ofsWfid, ofsReqInfoBean);
					ofsReqInfoBean.put("ofswfid", ofsWfid);
				}
				if (ofsViewType == 0) {
					ofsReqInfoBean.put("newcount", ofsReqCount + "");
				} else {
					//viewtype不为0 全部统计到全部中。
					int tempOfsReqCount = Util.getIntValue(ofsReqInfoBean.get("count"), 0);
					ofsReqInfoBean.put("count", (ofsReqCount + tempOfsReqCount) + "");
				}
				sb.append(ofsWfid).append(",");
			}

			if (hasOfsReq) {
				Map<String, List<Map<String, String>>> ofsWfTypeInfos = new HashMap<String, List<Map<String, String>>>();
				rs.executeSql("select a.workflowid, a.workflowname, b.sysid, b.sysshortname from ofs_workflow a, ofs_sysinfo b where a.workflowid in (" + sb.toString() + " 0) and a.sysid=b.sysid and a.Cancel=0 order by a.workflowid desc");
				while (rs.next()) {
					String ofsWfid = Util.null2String(rs.getString("workflowid"));
					String ofsWfName = Util.null2String(rs.getString("workflowname"));
					String ofsWfTypeId = Util.null2String(rs.getString("sysid"));
					String ofsWfTypeName = Util.null2String(rs.getString("sysshortname"));
					List<Map<String, String>> ofsWfList = ofsWfTypeInfos.get(ofsWfTypeId);
					if (ofsWfList == null) {
						ofsWfList = new ArrayList<Map<String, String>>();
						ofsWfTypeInfos.put(ofsWfTypeId, ofsWfList);
					}
					Map<String, String> ofswfBean = new HashMap<String, String>();
					ofswfBean.put("ofswfid", ofsWfid);
					ofswfBean.put("ofswfname", ofsWfName);
					ofswfBean.put("ofswftypeid", ofsWfTypeId);
					ofswfBean.put("ofswftypename", ofsWfTypeName);
					ofsWfList.add(ofswfBean);
				}

				StringBuilder demoLeftMenusSb = new StringBuilder();

				int zflg = 0;
				Set<Map.Entry<String, List<Map<String, String>>>> ofsTypeInfoSet = ofsWfTypeInfos.entrySet();
				for (Iterator<Map.Entry<String, List<Map<String, String>>>> it = ofsTypeInfoSet.iterator(); it.hasNext(); ) {
					Map.Entry<String, List<Map<String, String>>> ofsWfTypeInfo = it.next();
					String wfTypeid = ofsWfTypeInfo.getKey();
					List<Map<String, String>> ofsWfInfos = ofsWfTypeInfo.getValue();

					int ofsWfTypeReqCount = 0;
					int ofsWfTypeNewReqCount = 0;

					StringBuilder ofsReqInfoSb = new StringBuilder();
					for (int i = 0; i < ofsWfInfos.size(); i++) {
						Map<String, String> ofswfInfo = ofsWfInfos.get(i);

						String ofswfid = ofswfInfo.get("ofswfid");
						String ofswfname = ofswfInfo.get("ofswfname");
						String ofswftypeid = ofswfInfo.get("ofswftypeid");
						String ofswftypename = ofswfInfo.get("ofswftypename");
						Map<String, String> ofsReqInfo = ofsReqInfos.get(ofswfid);
						int ofsNewReqCount = Util.getIntValue(ofsReqInfo.get("newcount"), 0);
						int ofsReqCount = Util.getIntValue(ofsReqInfo.get("count"), 0);
						ofsReqCount += ofsNewReqCount;
						ofsWfTypeReqCount += ofsReqCount;
						ofsWfTypeNewReqCount += ofsNewReqCount;

						ofsReqInfoSb.append(",{");
						ofsReqInfoSb.append("\"__domid__\":\"__wf_").append(ofswfid).append("\",");
						ofsReqInfoSb.append("\"attr\":{");
						ofsReqInfoSb.append("\"flowNew\":").append(ofsNewReqCount).append(",");
						ofsReqInfoSb.append("\"flowResponse\":0,");
						ofsReqInfoSb.append("\"flowOut\":0,");
						ofsReqInfoSb.append("\"flowAll\":").append(ofsReqCount).append(",");
						ofsReqInfoSb.append("\"flowSup\":0");
						ofsReqInfoSb.append("},");
						ofsReqInfoSb.append("\"numbers\":{");
						ofsReqInfoSb.append("\"flowNew\":").append(ofsNewReqCount).append(",");
						ofsReqInfoSb.append("\"flowResponse\":0,");
						ofsReqInfoSb.append("\"flowOut\":0,");
						ofsReqInfoSb.append("\"flowAll\":").append(ofsReqCount).append(",");
						ofsReqInfoSb.append("\"flowSup\":0");
						ofsReqInfoSb.append("}");
						ofsReqInfoSb.append("}");
					}
					if (zflg++ > 0) {
						demoLeftMenusSb.append(",");
					}
					demoLeftMenusSb.append("{");
					demoLeftMenusSb.append(" \"__domid__\":\"__type_").append(wfTypeid).append("\",");
					demoLeftMenusSb.append("\"attr\":{");
					demoLeftMenusSb.append("\"flowNew\":" + ofsWfTypeNewReqCount + ",");
					demoLeftMenusSb.append("\"flowResponse\":0,");
					demoLeftMenusSb.append("\"flowOut\":0,");
					demoLeftMenusSb.append("\"flowAll\":").append(ofsWfTypeReqCount).append(",");
					demoLeftMenusSb.append("\"flowSup\":0");
					demoLeftMenusSb.append("},");
					demoLeftMenusSb.append("\"numbers\":{");
					demoLeftMenusSb.append("\"flowNew\":" + ofsWfTypeNewReqCount + ",");
					demoLeftMenusSb.append("\"flowResponse\":0,");
					demoLeftMenusSb.append("\"flowOut\":0,");
					demoLeftMenusSb.append("\"flowAll\":").append(ofsWfTypeReqCount).append(",");
					demoLeftMenusSb.append("\"flowSup\":0");
					demoLeftMenusSb.append("}");
					demoLeftMenusSb.append("}");
					//添加类型下流程数据
					demoLeftMenusSb.append(ofsReqInfoSb);
				}

				if (demoLeftMenus.length() > 10 && demoLeftMenusSb.length() > 10) {
					demoLeftMenus += ",";
				}
				demoLeftMenus += demoLeftMenusSb.toString();
			}
        }

		demoLeftMenus += "]";
		//out.clear();
		out.print(demoLeftMenus);

	/*******************************/

%>


