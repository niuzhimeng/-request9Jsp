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
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
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
//是否需要加载树
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String loadtree = Util.null2String(request.getParameter("loadtree"));
int date2during = Util.getIntValue(request.getParameter("date2during"),0);
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(1210,user.getLanguage()) +":"+SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";

String resourceid=""+user.getUID();
int userid = user.getUID();
String userID = String.valueOf(user.getUID());
String belongtoshow = "";				
								RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
								if(RecordSet.next()){
									belongtoshow = RecordSet.getString("belongtoshow");
								}
String userIDAll = String.valueOf(user.getUID());
		
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

session.removeAttribute("RequestViewResource");
String logintype = ""+user.getLogintype();
int usertype = 0; 

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

if(logintype.equals("2"))
	usertype= 1;
char flag = Util.getSeparator();

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

ArrayList wftypes=new ArrayList();
ArrayList wftypecounts=new ArrayList();
ArrayList workflows=new ArrayList();
ArrayList wftypecountsy=new ArrayList();
ArrayList workflowcounts=new ArrayList();//未归档的
ArrayList workflowcountsy=new ArrayList();//归档
ArrayList newcountslist = new ArrayList();//未读
ArrayList supedcountslist = new ArrayList();//反馈
ArrayList overcountslist = new ArrayList();//超时

Map workflowcountsMap=new Hashtable();//未归档的数量
Map workflowcountsyMap=new Hashtable();//归档数量
Map newcountsMap=new Hashtable();     //未读
Map supedcountsMap=new Hashtable();//反馈数量
Map overcountsMap = new Hashtable();	//超时数量

String _viewtype = "";	//
int totalcount=0;
int totalcounty=0;
String currworkflowtype="";

String currworkflowid="";
String currentnodetype="";
String _wftypes = "";
String demoLeftMenus = "";

StringBuffer sqlsb = new StringBuffer();

sqlsb.append("select count(distinct t1.requestid) typecount, ");
sqlsb.append("      t2.workflowtype, ");
sqlsb.append("      t1.workflowid, ");
sqlsb.append("      t1.currentnodetype ");
sqlsb.append(" from workflow_requestbase t1, workflow_base t2,workflow_currentoperator t3 ");
	if("1".equals(belongtoshow)){
		sqlsb.append(" where t1.creater in ( ").append(userIDAll);	
			}else{
		sqlsb.append(" where t1.creater in (").append(resourceid);
			}
sqlsb.append(") and t1.creatertype = ").append(usertype);
sqlsb.append("  and t1.workflowid = t2.id ");
sqlsb.append("  and t1.requestid = t3.requestid ");
sqlsb.append("  and t3.islasttimes=1 ");
sqlsb.append("  and (t2.isvalid='1' or t2.isvalid='3') ");
if(RecordSet.getDBType().equals("oracle"))
{
	sqlsb.append(" and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
}else if(RecordSet.getDBType().equals("mysql")){
	sqlsb.append(" and (ifnull(t1.currentstatus,-1) = -1 or (ifnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
}
else
{
	sqlsb.append(" and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
}
sqlsb.append("  and exists ");
sqlsb.append("		(select 1 ");
sqlsb.append("         from workflow_currentoperator ");
sqlsb.append("        where workflow_currentoperator.islasttimes='1' ");
if("1".equals(belongtoshow)){
		sqlsb.append("          and workflow_currentoperator.userid in (" + userIDAll + WorkflowComInfo.getDateDuringSql(date2during) +")) ");
		}else{
		sqlsb.append("          and workflow_currentoperator.userid in ( " + resourceid + WorkflowComInfo.getDateDuringSql(date2during) +")) ");
		}
if(offical.equals("1")){//发文/收文/签报
	if(officalType==1){
		sqlsb.append(" and t1.workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and isvalid=1)");
	}else if(officalType==2){
		sqlsb.append(" and t1.workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and isvalid=1)");
	}
}
sqlsb.append("group by t2.workflowtype, t1.workflowid, t1.currentnodetype");
RecordSet.executeSql(sqlsb.toString());
//System.out.println("sqlsb.toString():"+sqlsb.toString());
   //RecordSet.executeProc("workflow_requestbase_MyRequest",resourceid+flag+usertype);
while (RecordSet.next())
{
	currworkflowtype = RecordSet.getString("workflowtype");
	currworkflowid = RecordSet.getString("workflowid");
	 
	currworkflowid = WorkflowVersion.getActiveVersionWFID(currworkflowid);
	 
	currentnodetype=RecordSet.getString("currentnodetype");
	_viewtype = RecordSet.getString("viewtype");
	int theworkflowcount=RecordSet.getInt("typecount");
	if(selectedworkflow.indexOf("T"+currworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
	if(selectedworkflow.indexOf("W"+currworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
	int temps=wftypes.indexOf(currworkflowtype);
	if (temps!=-1)
	{
	 	if (currentnodetype.equals("3"))
	 		wftypecountsy.set(temps,""+(Util.getIntValue((String)wftypecountsy.get(temps),0)+theworkflowcount));
	 	else
	  		wftypecounts.set(temps,""+(Util.getIntValue((String)wftypecounts.get(temps),0)+theworkflowcount));
	}
	else
	{
	 	wftypes.add(currworkflowtype);
	 	if (currentnodetype.equals("3"))
	 	{
	 		wftypecountsy.add(""+RecordSet.getString("typecount"));
	 		wftypecounts.add(""+0);
	 	}
	 	else
	 	{
	 		wftypecounts.add(""+RecordSet.getString("typecount"));
	 		wftypecountsy.add(""+0);
	 	}
	}
	temps=workflows.indexOf(currworkflowid);
	if (temps!=-1)
	{
		if (currentnodetype.equals("3"))
	 		workflowcountsy.set(temps,""+(Util.getIntValue((String)workflowcountsy.get(temps),0)+theworkflowcount));	
	 	else
	 		workflowcounts.set(temps,""+(Util.getIntValue((String)workflowcounts.get(temps),0)+theworkflowcount));
	}
	else
	{
	 	workflows.add(currworkflowid);
	 	if (currentnodetype.equals("3"))
	 	{
	 		workflowcountsy.add(""+RecordSet.getString("typecount"));
	 		workflowcounts.add(""+0);
	 	}
	 	else
	 	{
	 		workflowcounts.add(""+RecordSet.getString("typecount"));
	 		workflowcountsy.add(""+0);
	 	}
	}
	 
	if (currentnodetype.equals("3"))
	 	totalcounty+=theworkflowcount;
	else
	 	totalcount+=theworkflowcount;
}

StringBuffer wftypesb = new StringBuffer();
  	StringBuffer wfsb = new StringBuffer();
  	StringBuffer wfnodesb = new StringBuffer();

for(int x=0;x<workflows.size();x++)
{
	String _wfid = (String)workflows.get(x);
	String _wftype = (String)WorkflowComInfo.getWorkflowtype(_wfid);
}

for(int i=0;i<workflows.size();i++){
    String tworkflowid = (String)workflows.get(i);
	 String tworkflowtype = (String)WorkflowComInfo.getWorkflowtype(tworkflowid);
    if(tworkflowtype.equals("")){
	    tworkflowtype = "0";
    }
    int newcount=0;
    int newcount1=0;
    //tworkflowNodeIDs = Util.null2String((String)wfNodeHahstable.get(tworkflowid));
    if(!"".equals(tworkflowtype)){
	 wftypesb.append(",").append(tworkflowtype);
	 String tempworkflowid = WorkflowVersion.getAllVersionStringByWFIDs(tworkflowid) ;
	 if(tempworkflowid.equals("")){
		 tempworkflowid = "0";
	 }
	 wfsb.append(",").append(tempworkflowid);
    }
	 /*
	 String tempnodeid = WorkflowVersion.getAllRelationNodeStringByNodeIDs(tworkflowNodeIDs);
	 if (tempnodeid != null && !"".equals(tempnodeid)) {
	 	wfnodesb.append(",").append(tempnodeid);
	 }
	 */
	 
	 }

	 if (wftypesb.length() > 0) {
	  	wftypesb = wftypesb.delete(0, 1);
		wfsb = wfsb.delete(0, 1);
	 }
	 if (wfnodesb.indexOf(",") == 0) {
		wfnodesb = wfnodesb.delete(0, 1);
	 }
	 

	sqlsb = new StringBuffer();
	sqlsb.append(" select t3.workflowtype, t3.workflowid, count(distinct t1.requestid) viewcount,t3.viewtype,t3.isremark ");
	sqlsb.append(" from workflow_requestbase t1, workflow_base t2,workflow_currentoperator t3 ");
	sqlsb.append(" where t1.creater = ").append(resourceid);
	sqlsb.append(" and t3.userid = ").append(resourceid);
	sqlsb.append("  and t1.creatertype = ").append(usertype);
	sqlsb.append("  and t1.workflowid = t2.id ");
	sqlsb.append("	    and t3.workflowtype in ( ").append(wftypesb).append(") ");
	sqlsb.append("	    and t3.workflowid in (").append(wfsb).append(")");
	sqlsb.append("  and t1.requestid = t3.requestid ");
	sqlsb.append("  and t3.islasttimes=1 ");
	sqlsb.append("  and (t2.isvalid='1' or t2.isvalid='3') ");
	sqlsb.append(" and (t1.deleted=0 or t1.deleted is null) and ((t3.isremark in('2','4') and t1.currentnodetype = '3') or t1.currentnodetype <> '3' ) ");
	if(RecordSet.getDBType().equals("oracle"))
	{
		sqlsb.append(" and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
	}else if(RecordSet.getDBType().equals("mysql")){
		sqlsb.append(" and (ifnull(t1.currentstatus,-1) = -1 or (ifnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
	}
	else
	{
		sqlsb.append(" and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
	}
	sqlsb.append("  and exists ");
	sqlsb.append("		(select 1 ");
	sqlsb.append("         from workflow_currentoperator ");
	sqlsb.append("        where workflow_currentoperator.islasttimes='1' ");
	sqlsb.append("          and workflow_currentoperator.userid = " + resourceid + WorkflowComInfo.getDateDuringSql(date2during) +") ");
	if(offical.equals("1")){//发文/收文/签报
		if(officalType==1){
			sqlsb.append(" and t1.workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and isvalid=1)");
		}else if(officalType==2){
			sqlsb.append(" and t1.workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and isvalid=1)");
		}
	}
	sqlsb.append(" group by viewtype,t3.isremark, t3.workflowtype, t3.workflowid");
	RecordSet.execute(sqlsb.toString());
	//System.out.println(sqlsb.toString());
	int _newcount = 0;
	int _rescount = 0;
	int _outcount = 0;
	while(RecordSet.next()) {
	    
	    String tworkflowtype = Util.null2String(RecordSet.getString("workflowtype"));
        String tworkflowid = WorkflowVersion.getActiveVersionWFID(Util.null2String(RecordSet.getString("workflowid")));
        
        
		int _vc = Util.getIntValue(RecordSet.getString("viewcount"),0);
		
		String _im = RecordSet.getString("isremark");
		String _vt = RecordSet.getString("viewtype"); 
		//System.out.println(WorkflowComInfo.getWorkflowname(_wfid) +" 有"+(_vt.equals("-1")?"反馈":(_vt.equals("0")?"未读":"一般"))+"流程 ："+_vc+" 条");
		int wfindex = workflows.indexOf(tworkflowid) ;
		if(wfindex != -1) {
			if(_im.equals("5")) {
				//_outcount += _vc;
				Object tempobj = overcountsMap.get(tworkflowid);
                if (tempobj != null) {
                	int wf0countindex = (Integer)tempobj ;
                	overcountsMap.put(tworkflowid, wf0countindex + _vc);
                } else {
                    overcountsMap.put(tworkflowid, _vc);  
                }
			}else{
			    
				if(_vt.equals("-1")) {
				 	
				    Object tempobj = supedcountsMap.get(tworkflowid);
	                if (tempobj != null) {
	                	int wf0countindex = (Integer)tempobj ;
	                	supedcountsMap.put(tworkflowid, wf0countindex + _vc);
	                } else {
	                    supedcountsMap.put(tworkflowid, _vc);  
	                }
				    
					//_rescount += _vc;
					
				}
				if(_vt.equals("0")) {
				    Object tempobj = newcountsMap.get(tworkflowid);
	                if (tempobj != null) {
	                	int wf0countindex = (Integer)tempobj ;
	                	newcountsMap.put(tworkflowid, wf0countindex + _vc);
	                } else {
	                    newcountsMap.put(tworkflowid, _vc);  
	                }
					//_newcount += _vc;
				}
			}
		}
	}
	//newcountslist.add(_newcount+"");
	//supedcountslist.add(_rescount+"");
	//overcountslist.add(_outcount+"");
//}

/***************************************/
//左侧树 json 数据生成逻辑
demoLeftMenus+="[";
String typeid="";
String typecount="";	//未归档的type数量
String typecounty = "";	//已归档的type数量
String typename="";
String workflowid="";
String workflowcount="";	//未归档的数量
String workflowcounty = "";	//归档的数量

String wfnewcount = ""; //未读
String wfrescount = ""; //反馈
String wfoutcount = ""; //超时
String workflowname="";
       				
for(int i=0;i<wftypes.size();i++){
	typeid=(String)wftypes.get(i);
	typename=WorkTypeComInfo.getWorkTypename(typeid);

	demoLeftMenus+="{";
	demoLeftMenus+="\"__domid__\":\"__type_"+typeid+"\",";
	
	List<Map> maps=new ArrayList(0);
	int flowAll=0;
	int flowNew=0;
	int flowResponse=0;
	int flowOut=0;
	
	for(int j=0;j<workflows.size();j++){
		workflowid=(String)workflows.get(j);
		String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
		if(!curtypeid.equals(typeid)){
			continue;
		}
		workflowcount=(String)workflowcounts.get(j);
		workflowcounty = (String)workflowcountsy.get(j);
		//wfnewcount = (String)newcountslist.get(j);
		//wfrescount = (String)supedcountslist.get(j);
		//wfoutcount = (String)overcountslist.get(j);
		
		Object tempovtimenumObj = newcountsMap.get(workflowid);
		if (tempovtimenumObj != null) {
		    wfnewcount = tempovtimenumObj.toString();
		} else {
		    wfnewcount = "0";
		}
		
		Object tempovtimenumObj2 = supedcountsMap.get(workflowid);
		if (tempovtimenumObj2 != null) {
		    wfrescount = tempovtimenumObj2.toString();
		} else {
		    wfrescount = "0";
		}
		
		Object tempovtimenumObj3 = overcountsMap.get(workflowid);
		if (tempovtimenumObj3 != null) {
		    wfoutcount = tempovtimenumObj3.toString();
		} else {
		    wfoutcount = "0";
		}
		
		String wfallcount = (Util.getIntValue(workflowcount) + Util.getIntValue(workflowcounty))+"";
		//System.out.println("未归档："+workflowcount+"   已归档："+workflowcounty);
		workflowname=WorkflowComInfo.getWorkflowname(workflowid);
		//System.out.println(workflowname+"   未读流程："+wfnewcount+"反馈流程："+wfrescount);
			Map map=new HashMap();
			map.put("name",Util.toScreen(workflowname,user.getLanguage()));
			map.put("workflowid",workflowid);
			map.put("flowAll",Util.toScreen(wfallcount,user.getLanguage()));
			map.put("flowNew",Util.toScreen(wfnewcount,user.getLanguage()));
			map.put("flowResponse",Util.toScreen(wfrescount,user.getLanguage()));
			map.put("flowOut",Util.toScreen(wfoutcount,user.getLanguage()));
			if(workflowcount.equals("")) workflowcount = "0";
			if(workflowcounty.equals("0")) workflowcounty = "0";
			//把未归档的和已归档的合并起来 modifier Dracula 2014-7-7
			if(workflowcount.equals("0") && workflowcounty.equals("0"));
			else{
				maps.add(map);
			}
		
		flowAll+=Integer.valueOf(map.get("flowAll")+"");
		flowNew+=Integer.valueOf(map.get("flowNew")+"");
		flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
		flowOut+=Integer.valueOf(map.get("flowOut")+"");
	}
	
	
	demoLeftMenus+="\"numbers\":{";
	demoLeftMenus+="\"flowAll\":"+flowAll+",";
	demoLeftMenus+="\"flowNew\":"+flowNew+",";
	demoLeftMenus+="\"flowResponse\":"+flowResponse+",";
	demoLeftMenus+="\"flowOut\":"+flowOut;
	demoLeftMenus+="}";
	demoLeftMenus+="}";
	if (maps.size() > 0) {
		demoLeftMenus += ",";
	}
	
	for(int x=0;x<maps.size();x++){
		Map map=maps.get(x);
		demoLeftMenus+="{";	
		demoLeftMenus+="\"__domid__\":\"__wf_"+map.get("workflowid")+"\",";
		demoLeftMenus+="\"numbers\":{";
		demoLeftMenus+="\"flowAll\":"+map.get("flowAll")+",";
		demoLeftMenus+="\"flowNew\":"+map.get("flowNew")+",";
		demoLeftMenus+="\"flowResponse\":"+map.get("flowResponse")+",";
		demoLeftMenus+="\"flowOut\":"+map.get("flowOut");
		demoLeftMenus+="}";
		demoLeftMenus+="}";
		demoLeftMenus += (x==maps.size()-1)?"":",";
	}
	if (i < wftypes.size() - 1) {
		demoLeftMenus += ",";
	}
}

    if(requestutil.getOfsSetting().getIsuse()==1){
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
		rs.executeQuery("select workflowid, viewtype, COUNT(requestid) count from ofs_todo_data where creatorid=? and creatorid = userid and islasttimes=1 group by workflowid, viewtype", user.getUID());
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
out.print(demoLeftMenus);
	
%>


